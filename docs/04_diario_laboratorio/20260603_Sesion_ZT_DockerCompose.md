# Diario de Laboratorio — 2026-06-03
## Escenario B: Fases 1–4 (Segmentación + Secretos + mTLS)

> **Sesión:** `zerotrust_sesion_20260603`
> **Operador:** Cory
> **Directorio de trabajo:** `infra/zero_trust/`
> **Duración aproximada:** tarde-noche del 03/06/2026
> **Objetivo del día (admin/HOY.md):** Levantar `infra/zero_trust/` con las 3 redes aisladas, servicios healthy y, si daba tiempo, iniciar mTLS.
> **Resultado real:** Fases 1–4 completadas. mTLS verificado y funcionando. Wazuh pendiente (mañana 04/06, checkpoint 20:00).

---

## Contexto previo al inicio de la sesión

- El Escenario A (perimetral) estaba cerrado y con baseline KPI capturado desde la sesión del 23/05/2026.
- `infra/zero_trust/` existía como directorio vacío con `.gitkeep`.
- El `docker-compose.yaml` de `infra/zero_trust/` tenía las redes `web_zone`, `backend_zone`, `db_zone` ya declaradas pero los servicios seguían referenciando `net_dmz`/`net_interna` del Escenario A, lo que habría causado fallo al levantar.

---

## Fase 0 — Investigación y documentación previa

Antes de la implementación, se generaron tres documentos de investigación que sirven como base teórica del Capítulo 2 y Capítulo 4 del TFG:

| Documento | Descripción |
|---|---|
| `docs/01_investigacion/20260603_ZeroTrust_Dump` | Dump raw de investigación desde IA (Perplexity): NIST SP 800-207, mTLS, MITRE ATT&CK, Wazuh, papers comparativos 2020–2025 |
| `docs/01_investigacion/Investigacion_ZeroTrust.md` | Síntesis consolidada, sin redundancias, con 18 secciones pedagógicas, diagramas Mermaid y marcadores `[CITAR:]` |
| `docs/01_investigacion/20260603_Prototipo_ZeroTrust.md` | Traducción práctica de la investigación a arquitectura implementable: 12 secciones, matriz de segmentación, roadmap, KPIs |

**Decisión arquitectónica registrada aquí:** el prototipo establece que todas las decisiones deben tener trazabilidad a la investigación. No se introducen tecnologías ajenas a la misma.

---

## Fase 1 — Inventario de flujos (análisis pre-implementación)

Análisis del Escenario A (`infra/perimetral/`) para identificar los flujos reales necesarios:

| Origen | Destino | Puerto | ¿Necesario? |
|---|---|---|---|
| nginx | webapp | 5000 | Sí |
| webapp | backend | 5000 | Sí (único uso real) |
| backend | db | 5432 | Sí |
| webapp | db | 5432 | **No** — punto de fallo del modelo perimetral |

**Conclusión:** `webapp` no necesita acceso a `db` en absoluto. Toda la lógica de datos pasa por `backend`. Esto define la segmentación: tres zonas, sin interfaz común entre `webapp` y `db`.

**Vulnerabilidades identificadas en el Escenario A (útiles para el Cap. 5):**
- `GET /backup.txt` expone credenciales admin en texto claro (CWE-200)
- `ADMIN_USER`/`ADMIN_PASSWORD` hardcodeados en `webapp/app.py`
- SSTI en `/admin/diagnostico?host=` via `render_template_string` sin sanitizar (CWE-1336)
- `DB_PASSWORD=supersecret` compartido entre `webapp` y `backend` → exfiltrable con `env` tras RCE
- `backend:5000/empleados` sin autenticación — cualquier contenedor en `net_interna` podía llamarlo
- `webapp` tenía acceso directo a `db:5432` sin ningún control

---

## Fase 2 — Segmentación por zonas

### Cambios realizados en `infra/zero_trust/docker-compose.yaml`

Asignación de interfaces por servicio según el principio "si comprometer A no debe dar acceso a B, A y B van en segmentos distintos" (Investigacion_ZeroTrust.md §Segmentación):

| Servicio | web_zone | backend_zone | db_zone |
|---|---|---|---|
| nginx | ✅ | — | — |
| webapp | ✅ | ✅ | — |
| backend | — | ✅ | ✅ |
| db | — | — | ✅ |

`webapp` es multihomed en `web_zone` + `backend_zone` pero **sin interfaz en `db_zone`**, rompiendo la cadena directa `webapp → db` a nivel L3.

### Verificación de la segmentación

```bash
# Camino legítimo webapp → backend: debe funcionar
docker exec zero_trust-webapp-1 curl -s http://backend:5000/health
# Resultado: {"status":"ok"}  ✓

# Bloqueo webapp → db: debe fallar
docker exec zero_trust-webapp-1 python -c "import socket; socket.create_connection(('db',5432),timeout=3)"
# Resultado: socket.gaierror: [Errno -5] No address associated with hostname  ✓
```

**Análisis del resultado del bloqueo:** no es un simple timeout ni `Connection refused`. Docker DNS directamente **no resuelve el nombre `db`** desde `webapp` porque no comparten red. Ningún contenedor en `db_zone` es visible para `webapp`. Esto es contención a nivel de segmentación de red + DNS interno, más sólido que una regla de firewall (que podría tener errores de configuración). Impacto en KPIs: G2 (profundidad ≤ 2 nodos), E1 (superficie reducida).

**Nota operativa:** `docker compose exec webapp <cmd>` no funcionó inicialmente (devolvía "no configuration file provided: not found"). El comando estable desde el repositorio raíz es `docker exec zero_trust-webapp-1 <cmd>`. Desde `infra/zero_trust/` sí funciona `docker compose exec`.

### Estado de los 4 contenedores tras Fase 2

```
zero_trust-nginx-1     Up — 0.0.0.0:8080->80/tcp
zero_trust-webapp-1    Up
zero_trust-backend-1   Up (healthy)
zero_trust-db-1        Up — 5432/tcp (no expuesto al host)
```

---

## Fase 3 — Separación de secretos

### Cambio en `infra/zero_trust/docker-compose.yaml`

Se eliminaron `DB_HOST` y `DB_PASSWORD` del servicio `webapp`. En el Escenario A, estas variables estaban presentes en `webapp` aunque no las necesitaba funcionalmente (solo llama a `backend`, nunca a `db`). Tras RCE, el atacante podía exfiltrarlas con `env | grep DB_` en ~24 segundos (T_exfil_creds del baseline).

**Antes (Escenario A / estado inicial de infra/zero_trust):**
```yaml
webapp:
  environment:
    - DB_HOST=db
    - DB_PASSWORD=supersecret   # exfiltrable con env tras RCE
```

**Después (Escenario B):**
```yaml
webapp:
  environment:
    - BACKEND_URL=https://backend:443/empleados   # único secret necesario
    # DB_HOST y DB_PASSWORD eliminados
```

`backend` conserva sus credenciales de BD porque sí las necesita:
```yaml
backend:
  environment:
    - DB_HOST=db
    - DB_PASSWORD=supersecret
```

**Verificación:**
```bash
docker exec zero_trust-webapp-1 env | grep -i -E "db_|pass"
# Resultado: (vacío) ✓
```

**Impacto en KPIs:** E2 — el atacante que obtiene RCE en `webapp` ya no puede exfiltrar credenciales de BD con `env`. Volumen exfiltrable en ese vector: 0 bytes (vs ~35 bytes en Escenario A, archivo `creds.txt`).

---

## Fase 4 — mTLS webapp ↔ backend

### Decisión arquitectónica: Opción B (único contenedor Nginx+Flask)

**Contexto de la decisión:** La IA sugirió inicialmente un patrón "sidecar" con dos servicios separados (`backend` como Nginx y `backend-api` como Flask) más una red `backend_internal`. Al cuestionarse la fuente de esa decisión, se identificó que no estaba documentada en la investigación y violaba la regla de trazabilidad del prototipo.

**Opciones consideradas:**
- **Opción A** (Nginx sidecar): `backend` = Nginx PEP + `backend-api` = Flask. Requería nuevo servicio y nueva red no documentados.
- **Opción B** (único contenedor): Un solo contenedor `backend` que ejecuta Nginx (443, mTLS) y Flask (5000 interno). Fiel al diagrama del prototipo §3.
- **Opción C** (Flask TLS nativo): Flask con `ssl_context`. No documentado en la investigación.

**Decisión: Opción B.** Un solo servicio `backend` en el compose. Nginx como PEP termina TLS en 443 y hace `proxy_pass` a `localhost:5000` (Flask). Tecnología: Nginx (única documentada en `Investigacion_ZeroTrust.md`).

*Pendiente registrar en `admin/DECISIONS_LOG.md`.*

---

### 4.1 Generación de certificados con OpenSSL

Directorio: `infra/zero_trust/certs/`

```bash
# CA local
openssl req -x509 -newkey rsa:4096 -nodes -days 365 \
  -keyout ca.key -out ca.crt -subj "/CN=ZeroTrust-Lab-CA"

# Certificado de servidor (backend) — con SAN obligatorio para TLS moderno
openssl req -newkey rsa:4096 -nodes -keyout server.key -out server.csr \
  -subj "/CN=backend" -addext "subjectAltName=DNS:backend"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -days 365 -out server.crt \
  -extfile <(printf "subjectAltName=DNS:backend\nextendedKeyUsage=serverAuth")

# Certificado de cliente (webapp)
openssl req -newkey rsa:4096 -nodes -keyout client.key -out client.csr \
  -subj "/CN=webapp"
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -days 365 -out client.crt \
  -extfile <(printf "extendedKeyUsage=clientAuth")
```

**Ficheros generados en `infra/zero_trust/certs/`:**
```
ca.key  ca.crt  ca.srl
server.key  server.csr  server.crt
client.key  client.csr  client.crt
```

**Aprendizaje técnico:** el `subjectAltName=DNS:backend` es obligatorio en TLS moderno. Sin él, `requests` de Python y `curl` rechazan el certificado del servidor porque el CN solo ya no es suficiente para validar el hostname. Este requisito no aparecía explícitamente en la documentación de OpenSSL consultada previamente.

---

### 4.2 Configuración de Nginx como PEP mTLS (`infra/zero_trust/backend/nginx.conf`)

```nginx
events {}
http {
    access_log /dev/stdout;
    error_log  /dev/stderr warn;

    server {
        listen 443 ssl;
        server_name backend;

        ssl_certificate        /certs/server.crt;
        ssl_certificate_key    /certs/server.key;
        ssl_client_certificate /certs/ca.crt;
        ssl_verify_client      on;
        ssl_verify_depth       1;

        location / {
            proxy_pass http://localhost:5000;
            proxy_set_header X-SSL-Client-Verify $ssl_client_verify;
            proxy_set_header X-SSL-Client-DN     $ssl_client_s_dn;
        }
    }
}
```

**Directivas clave y su función:**
- `ssl_verify_client on`: obliga a que el cliente presente certificado válido. Sin esto, cualquier conexión TLS se acepta sin autenticación mutua.
- `ssl_client_certificate`: indica la CA contra la que se verifica el cert del cliente. Sin esto, Nginx no puede construir la cadena de confianza.
- `ssl_verify_depth 1`: limita la cadena a un nivel (CA directa). No sustituye autorización.
- `proxy_pass http://localhost:5000`: Flask y Nginx en el mismo contenedor. No hay red interna adicional.
- Cabeceras `X-SSL-Client-Verify` y `X-SSL-Client-DN`: propagan la identidad del cliente verificado al backend (RFC 9440).

**Distinción crítica documentada:** mTLS **autentica, no autoriza**. Nginx valida que el certificado está firmado por la CA, no decide qué puede hacer ese servicio una vez autenticado. La autorización fina queda como trabajo futuro (Cap. 6 del TFG).

---

### 4.3 Nginx público restaurado (`infra/zero_trust/nginx/nginx.conf`)

Este Nginx es el punto de entrada externo que recibe tráfico de Internet y lo reenvía a `webapp`. **No** es el PEP mTLS. Fue editado por error durante el desarrollo (se puso la configuración mTLS en este fichero en lugar de en `backend/nginx.conf`). Restaurado a su función original:

```nginx
events {}
http {
    access_log /dev/stdout;
    error_log  /dev/stderr warn;
    server {
        listen 80;
        resolver 127.0.0.11 valid=30s;
        location / {
            proxy_pass http://webapp:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

---

### 4.4 Dockerfile del backend (`infra/zero_trust/backend/Dockerfile`)

```dockerfile
FROM python:3.11-slim
RUN apt-get update && apt-get install -y curl nmap nginx && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["sh", "-c", "python app.py & nginx -g 'daemon off;'"]
```

**Diferencias respecto al Escenario A:**
- Añadido `nginx` al `apt-get install`.
- `CMD` arranca Flask en background (`&`) y Nginx en foreground (`daemon off`). El proceso principal del contenedor es Nginx; si cae, el contenedor para.
- El `nginx.conf` con mTLS se monta vía volumen en el compose (`:ro`), no se copia en la imagen. Clave privada tampoco va en la imagen.

**Por qué no se usó `entrypoint.sh`:** `CMD ["sh", "-c", "python app.py & nginx -g 'daemon off;'"]` es equivalente y no requiere crear un fichero adicional. Para el alcance del laboratorio es suficiente.

---

### 4.5 Adaptación de `webapp/app.py`

La función `portal()` pasó de una llamada HTTP simple a una llamada HTTPS con autenticación mutua:

**Antes (Escenario A):**
```python
resp = requests.get(f"{BACKEND_URL}/empleados", timeout=3)
empleados = resp.json()
```

**Después (Escenario B):**
```python
resp = requests.get(
    os.environ["BACKEND_URL"],              # https://backend:443/empleados
    cert=("/certs/client.crt", "/certs/client.key"),   # presenta identidad
    verify="/certs/ca.crt",                 # valida al servidor
    timeout=3,
)
empleados = resp.json()
```

Los certificados se montan como volúmenes de solo lectura en el compose, no se copian en la imagen.

**Bug detectado y corregido durante la sesión:** versión intermedia del código tenía `cert=` y `verify=` pero omitía `empleados = resp.json()`, lo que habría causado `NameError` al cargar el portal. Corregido antes del primer `docker compose up` definitivo.

**Nota residual menor:** la línea 19 de `app.py` (`BACKEND_URL = os.environ.get("BACKEND_URL", "http://backend:5000")`) es código muerto: la función usa `os.environ["BACKEND_URL"]` directamente. El fallback ya no se usa. No es un bug, pero conviene limpiar en la redacción final del Cap. 5.

---

### 4.6 Errores encontrados durante la Fase 4

#### Error 1 — `curl` sin output (silencioso)

**Síntoma:** `docker exec zero_trust-webapp-1 curl -sk https://backend/empleados` → sin output, sin error.

**Causa:** la flag `-s` suprime tanto la barra de progreso como los mensajes de error. La conexión al puerto 443 fallaba con `Connection refused` porque Nginx no estaba instalado y nada escuchaba en ese puerto. `curl` devolvía código de error 7 pero `-s` lo silenciaba completamente.

**Diagnóstico:** `docker exec zero_trust-webapp-1 curl -v https://backend/empleados 2>&1`
```
* Trying 172.19.0.2:443...
* connect to 172.19.0.2 port 443 from 172.19.0.3 port 39236 failed: Connection refused
curl: (7) Failed to connect to backend port 443 after 1 ms: Could not connect to server
```

**Aprendizaje:** nunca usar `-s` para diagnóstico. Añadir siempre `-v` para ver el handshake TLS completo.

---

#### Error 2 — `nginx.conf` creado como directorio por Docker

**Síntoma:** `docker compose build --no-cache backend` fallaba con:
```
failed to compute cache key: failed to calculate checksum of ref ...: "/requirements.txt": not found
```
El contexto de build era de solo 28 bytes (prácticamente vacío).

**Diagnóstico:**
```bash
ls -la /mnt/c/Users/coryy/TFG/TFG-ZeroTrust/infra/zero_trust/backend/
# Resultado:
drwxrwxrwx 1 coryy coryy  603 Jun  3 19:14 nginx.conf   ← DIRECTORIO, no fichero
-rwxrwxrwx 1 coryy coryy   36 May 23 13:15 requirements.txt
```

**Causa raíz:** el volumen `./backend/nginx.conf:/etc/nginx/nginx.conf:ro` fue añadido al compose **antes de que el fichero existiera** en disco. Docker, al levantar el stack por primera vez con esa ruta de origen inexistente, creó `nginx.conf` como **directorio vacío** en lugar de un fichero. Este comportamiento es específico de Docker en Linux/WSL2. Una vez creado como directorio, Docker no lo sobreescribe aunque después se cree el fichero.

El directorio `nginx.conf` en el contexto de build confundía al scanner de BuildKit, que enviaba un contexto casi vacío (28 bytes), impidiendo que `requirements.txt` llegara al proceso de construcción.

**Regla aprendida:** siempre crear los ficheros que se montan como volúmenes **antes** de hacer `docker compose up`. Si el stack ya levantó con la ruta ausente, hacer `docker compose down` + eliminar el directorio creado por error antes de recrear el fichero.

**Solución aplicada:**
```bash
docker compose down
docker compose down -v
rm -rf /mnt/c/Users/coryy/TFG/TFG-ZeroTrust/infra/zero_trust/backend/nginx.conf
# Recrear nginx.conf como fichero con el contenido correcto
ls -la backend/   # verificar que aparece como fichero (-rwx...), no como directorio (drwx...)
docker compose up --build
```

---

#### Error 3 — `BACKEND_URL` con protocolo incorrecto

**Síntoma:** `webapp` no conectaba al backend aunque el puerto 443 ya existía.

**Causa:** `BACKEND_URL=http://backend:443/empleados` — se usó `http://` en lugar de `https://`. Una URL `http://` sobre el puerto 443 envía HTTP plano a un socket que espera un ClientHello TLS, produciendo un error de protocolo.

**Solución:** `BACKEND_URL=https://backend:443/empleados` (o `https://backend/empleados`; el `:443` es redundante en HTTPS).

---

### 4.7 Verificación final de mTLS — PASADA

```bash
# CON certificado de cliente → debe devolver JSON (200)
docker compose exec webapp curl -s \
  --cert /certs/client.crt \
  --key  /certs/client.key \
  --cacert /certs/ca.crt \
  https://backend/empleados
```
**Resultado:**
```json
[{"email":"ana.garcia@empresa.local","nombre":"Ana García","rol":"Directora IT","salario":85000},
 {"email":"luis.martinez@empresa.local","nombre":"Luis Martínez","rol":"Desarrollador","salario":52000},
 {"email":"sara.lopez@empresa.local","nombre":"Sara López","rol":"RRHH","salario":48000}]
```
→ HTTP 200. Datos devueltos correctamente. ✓

```bash
# SIN certificado de cliente → debe rechazar (400)
docker compose exec webapp curl -sk https://backend/empleados
```
**Resultado:**
```html
<html>
<head><title>400 No required SSL certificate was sent</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<center>No required SSL certificate was sent</center>
<hr><center>nginx/1.26.3</center>
</body>
</html>
```
→ HTTP 400. Nginx rechaza la conexión en el handshake TLS. ✓

**Interpretación para el TFG:** el rechazo no es a nivel de aplicación (no es un 401/403 de Flask) sino a nivel de protocolo TLS por Nginx. Un atacante con RCE en `webapp` que intente llamar directamente a `http://backend:5000/empleados` (como en el Escenario A) obtendrá `Connection refused` porque Flask en Escenario B solo es accesible desde `localhost` dentro del contenedor, y Nginx rechaza sin certificado. Esto cubre E3 (tráfico cifrado) y G3 (tasa de bloqueo).

---

## Estado final de todos los ficheros relevantes

### `infra/zero_trust/docker-compose.yaml`
- 3 redes: `web_zone`, `backend_zone`, `db_zone`
- `webapp`: redes `web_zone` + `backend_zone`; sin `DB_HOST`/`DB_PASSWORD`; certs cliente montados `:ro`
- `backend`: redes `backend_zone` + `db_zone`; `nginx.conf` mTLS + certs servidor montados `:ro`; healthcheck en `localhost:5000/health`
- `db`: solo `db_zone`

### `infra/zero_trust/backend/Dockerfile`
- `python:3.11-slim` + `curl nmap nginx`
- `CMD ["sh", "-c", "python app.py & nginx -g 'daemon off;'"]`

### `infra/zero_trust/backend/nginx.conf`
- Escucha en 443 SSL
- `ssl_verify_client on` + `ssl_client_certificate ca.crt`
- `proxy_pass http://localhost:5000`

### `infra/zero_trust/nginx/nginx.conf`
- Proxy HTTP estándar → `webapp:5000` (sin cambios respecto al Escenario A)

### `infra/zero_trust/webapp/app.py`
- `requests.get` con `cert=` y `verify=` para mTLS

### `infra/zero_trust/certs/`
- `ca.crt`, `ca.key`, `ca.srl`
- `server.crt`, `server.key`, `server.csr`
- `client.crt`, `client.key`, `client.csr`

---

## KPIs parciales observables tras esta sesión

| KPI | Escenario A (baseline) | Escenario B (esta sesión) | Pendiente |
|---|---|---|---|
| G1 — MTTD | `(false, ∞)` — sin SIEM | Sin valor aún (Wazuh pendiente) | Mañana |
| G2 — Profundidad | 3 nodos | `db` no alcanzable desde `webapp` → max. 1 nodo útil | Capturar formalmente |
| G3 — Tasa de bloqueo | `(false, 0%)` | `curl https://backend` sin cert → 400 ✓ | Medir todos los hitos |
| E1 — Superficie visible | 3/3 servicios | `db` no resuelve DNS desde `webapp` | Capturar formalmente |
| E2 — Volumen exfiltrado | ~766 B | `env` sin credenciales DB | Capturar formalmente |
| E3 — Integridad tráfico | Texto claro | mTLS 443 verificado → TLS 1.3 | Capturar pcap (tcpdump falló en esta sesión) |

**Nota sobre tcpdump en la sesión:** `docker compose exec webapp tcpdump -i any -A -c 20 host backend` devolvió 0 paquetes capturados. El aviso `That device doesn't support promiscuous mode` es normal en `any`. La causa probable es que no había tráfico activo hacia `backend` en ese momento. Para la sesión de captura KPI formal, lanzar tcpdump en segundo plano antes de ejecutar curl.

---

## Aprendizajes técnicos de la sesión

1. **Docker y volúmenes de fichero:** si la ruta de origen no existe cuando se ejecuta `docker compose up`, Docker la crea como directorio. Siempre crear el fichero antes. Solución: `docker compose down` + `rm -rf <ruta>` + crear fichero + `up --build`.

2. **`curl -s` oculta errores:** usar `-v` para diagnóstico TLS. El silencio de `-s` enmascara `Connection refused`, errores de handshake y certificados inválidos.

3. **SAN obligatorio en certificados TLS modernos:** `subjectAltName=DNS:<hostname>` es imprescindible. Sin él, Python `requests` y `curl` rechazan el certificado del servidor aunque el CN coincida.

4. **mTLS autentica, no autoriza:** Nginx valida la cadena de certificados pero no decide qué puede hacer el servicio autenticado. La autorización fina requiere capa adicional.

5. **Contención a nivel DNS:** en Docker con redes bridge separadas, la ausencia de interfaz común no solo bloquea el tráfico TCP/UDP sino que hace que el DNS interno no resuelva el nombre del servicio aislado. Esto es una capa de defensa adicional respecto a un firewall con reglas de deny.

6. **Dos Nginx con propósitos distintos:** `nginx/nginx.conf` (proxy público HTTP) y `backend/nginx.conf` (PEP mTLS). Confundirlos genera configuraciones silenciosamente rotas.

7. **Trazabilidad en decisiones arquitectónicas:** introducir patrones no documentados en la investigación (sidecar, redes adicionales) sin señalarlo viola la coherencia del TFG. Toda decisión debe registrarse en `admin/DECISIONS_LOG.md`.

---

## Qué NO se ha hecho hoy (y por qué)

- **Wazuh:** correctamente pospuesto para mañana 04/06 según `admin/HOY.md`. El compose estable es el prerequisito.
- **Captura formal de KPIs (plantilla v2 §2):** la verificación de mTLS fue funcional pero no se capturaron logs/pcaps en el formato oficial de `tests/logs/zerotrust_sesion_*/`. Pendiente en la sesión de pruebas A/B del 06-08/06.
- **Registro en `admin/DECISIONS_LOG.md`:** la decisión "Opción B (único contenedor Nginx+Flask)" no quedó registrada allí. Pendiente.
- **Commit:** no se realizó commit al final de la sesión. Pendiente.

---

## Información omitida al redactar este diario

- Logs repetitivos del healthcheck (`GET /health HTTP/1.1 200`) de terminal 1: se omitieron las ~120 líneas de logs. Son evidencia de que el backend estuvo healthy continuamente. Se puede reproducir con `docker compose logs backend`.
- Intentos intermedios de `curl` fallidos antes de identificar cada error (variantes de nombres de contenedor, flags incorrectos). Se conservó solo el comando estable final.
- Output completo de `docker --help` (apareció al teclear comandos incorrectos).
- Timestamps exactos de cada comando (no disponibles en el chat, solo los del log de backend que empiezan a las 17:28).

---

## Próximos pasos — Sesión del 04/06/2026 (checkpoint Wazuh 20:00)

### Pendiente inmediato (antes de Wazuh)

1. **Commit del estado actual:**
   ```bash
   cd /mnt/c/Users/coryy/TFG/TFG-ZeroTrust
   git add infra/zero_trust/ docs/04_diario_laboratorio/
   git commit -m "Escenario B: segmentacion 3 zonas + secretos + mTLS webapp-backend verificado"
   ```

2. **Registrar decisión en `admin/DECISIONS_LOG.md`:**
   - Opción B elegida para mTLS (único contenedor Nginx+Flask)
   - Razón: fidelidad al prototipo, trazabilidad a la investigación, sin introducir servicios/redes no documentados

3. **Verificar arranque limpio del stack** tras el commit:
   ```bash
   cd infra/zero_trust
   docker compose down && docker compose up --build -d
   docker compose ps   # todos healthy
   ```

### Fase 5 — Wazuh (objetivo del 04/06, checkpoint 20:00)

> **[ACTUALIZADO — 2026-06-04]** Los pasos originales asumían Opción A (agente en host WSL2). Tras el análisis del entorno Docker Desktop + WSL2, se adopta **Opción B (manager + agent como contenedores Docker)**. Ver ADR 2026-06-04 en `admin/DECISIONS_LOG.md`. Los pasos obsoletos se conservan tachados para trazabilidad.

Según el prototipo §8 y §10 Fase 5, el stack mínimo:

**Paso 1 — Wazuh manager** (fuera del compose del Escenario B, como servicio separado o compose oficial de Wazuh):
```bash
# Opción: docker run rápido para el laboratorio
docker run -d --name wazuh-manager \
  -p 1514:1514 -p 1515:1515 -p 55000:55000 \
  wazuh/wazuh-manager:4.x
```

~~**Paso 2 — Wazuh agent en el host** (no dentro del contenedor):~~
~~```bash~~
~~# En el host WSL2/Linux~~
~~curl -so wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.x_amd64.deb~~
~~dpkg -i wazuh-agent.deb~~
~~WAZUH_MANAGER=<IP_manager> wazuh-agent --enroll-agent~~
~~```~~
~~**[OBSOLETO — Opción A]** En Docker Desktop + WSL2, el agente instalado en Ubuntu WSL2 no ve los procesos de los contenedores (namespaces distintos). Ver ADR 2026-06-04.~~

**Paso 2 (revisado) — Wazuh agent como contenedor Docker (Opción B):**
Ver sesión `docs/04_diario_laboratorio/20260604_Sesion_Wazuh_Docker.md` para los comandos definitivos. Stack Docker con socket montado + `--pid=host`.

**Paso 3 — Activar docker-listener:**
En `ossec.conf` del agente (aplica igualmente en Opción B):
```xml
<wodle name="docker-listener">
  <disabled>no</disabled>
</wodle>
```

~~**Paso 4 — auditd para los 4 hitos post-RCE:**~~
~~```bash~~
~~# /etc/audit/rules.d/zerotrust.rules~~
~~-a always,exit -F arch=b64 -S execve -k zt_exec~~
~~```~~
~~**[OBSOLETO — Opción A]** `auditd` del host WSL2 no ve syscalls de los contenedores en Docker Desktop. Se sustituye por FIM + command monitoring vía docker-listener en Opción B.~~

**Paso 5 — Reglas locales Wazuh** (`/var/ossec/etc/rules/local_rules.xml`):
```xml
<group name="zerotrust,">
  <rule id="100100" level="12">
    <if_sid>80700</if_sid>
    <field name="audit.exe">nmap</field>
    <description>ZT: reconocimiento interno con nmap (T1046)</description>
  </rule>
  <rule id="100101" level="12">
    <if_sid>80700</if_sid>
    <field name="audit.exe">curl</field>
    <description>ZT: posible exfiltracion/movimiento lateral via curl (T1041)</description>
  </rule>
  <rule id="100102" level="14">
    <if_sid>80700</if_sid>
    <field name="audit.execve">env</field>
    <description>ZT: posible lectura de variables de entorno (T1552 - inferido)</description>
  </rule>
</group>
```

**Criterio de fallback (20:00 del 04/06):** si a las 20:00 no hay agent enrollado y al menos 1 alerta funcionando → activar Falco (ver ADR en `admin/DECISIONS_LOG.md`).

### Verificaciones que quedan pendientes para la sesión de KPIs (06-08/06)

Una vez el stack esté estable con Wazuh:

```bash
# Arrancar tcpdump ANTES de los tests (para E3)
docker compose exec webapp tcpdump -i eth0 -w /tmp/zt_lateral.pcap -c 100 host backend &

# Test 1: escaneo (T1046) — desde webapp post-RCE simulada
docker compose exec webapp nmap -p 1-65535 backend db

# Test 2: movimiento lateral (TA0008)
docker compose exec webapp python -c "import socket; socket.create_connection(('db',5432),timeout=3)"

# Test 3: robo de claves (T1552.004)
docker compose exec webapp env | grep -i -E "db_|pass|key|secret"

# Test 4: exfiltración (T1041) — intento directo sin cert
docker compose exec webapp curl -sk https://backend/empleados

# Rellenar plantilla KPI v2 §2 con los resultados
```

---

> **Commit de referencia de esta sesión:** pendiente (`git log` tras el commit del paso inmediato)
> **Siguiente hito:** checkpoint Wazuh 04/06/2026 a las 20:00
