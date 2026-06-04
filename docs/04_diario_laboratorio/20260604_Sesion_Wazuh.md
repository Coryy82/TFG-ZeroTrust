# Diario de Laboratorio — 2026-06-04
## Escenario B: Fase 5 (Observabilidad y Detección con Wazuh) + Examen final de integración

> **Sesión:** `zerotrust_sesion_20260604`
> **Operador:** Cory
> **Directorio de trabajo:** `infra/zero_trust/wazuh/` y `infra/zero_trust/`
> **Duración aproximada:** mañana-tarde del 04/06/2026 (checkpoint duro 20:00)
> **Objetivo del día (admin/HOY.md):** Levantar `wazuh-manager` + `wazuh-agent` comunicándose, con al menos 1 alerta activa visible en los logs del manager.
> **Resultado real:** Fase 5 completada y verificada. Stack Wazuh operativo (manager + agente Docker), enrollment estable, FIM realtime, docker-listener y reglas MITRE personalizadas. Examen final de integración con el resto de la red ZT superado: microsegmentación, mTLS y detección verificados end-to-end.

---

## Contexto previo al inicio de la sesión

- Fases 1–4 del Escenario B completadas el 03/06: segmentación en 3 zonas (`web_zone`, `backend_zone`, `db_zone`), separación de secretos y mTLS `webapp ↔ backend` verificado.
- El ADR de arquitectura Wazuh **Opción B** (manager + agente como contenedores Docker, frente a Opción A = agente en host) ya estaba registrado en `admin/DECISIONS_LOG.md`, justificado por las limitaciones de `auditd` y namespaces en el entorno Windows + Docker Desktop + WSL2.
- El stack de Wazuh ya estaba esbozado en `infra/zero_trust/wazuh/`:
  - `docker-compose.yaml` (manager + agente)
  - `agent/Dockerfile`, `agent/ossec.conf`, `agent/entrypoint.sh`
  - `manager/local_rules.xml` con reglas custom del grupo `zerotrust,`

### Componentes de partida

| Archivo | Función |
|---|---|
| `wazuh/docker-compose.yaml` | Orquestación manager + agente, red `wazuh_net` |
| `wazuh/agent/Dockerfile` | Imagen Ubuntu 22.04 + `wazuh-agent` 4.9.2 + `python3-docker` + `netcat` |
| `wazuh/agent/ossec.conf` | Enrollment, docker-listener, FIM sobre `/monitored/certs`, command monitoring (`ps auxww`) |
| `wazuh/agent/entrypoint.sh` | Espera al manager, enrolla el agente y arranca servicios |
| `wazuh/manager/local_rules.xml` | Reglas 100100/100101/100110/100111/100120 (MITRE T1046, T1041, TA0008, T1552.004) |

---

## Resumen cronológico de la sesión

La sesión fue una cadena de depuración: cada arranque del stack reveló un problema distinto, se diagnosticó la causa raíz y se aplicó el fix antes de pasar al siguiente. El orden fue:

1. Error de credenciales Docker (credential helper en WSL2)
2. Manager no arranca — `ossec.conf` ausente por volumen anónimo
3. Manager no arranca — `sed` no puede renombrar bind mount de fichero
4. Manager arranca pero el healthcheck da falso negativo (NTFS + `wazuh-control status`)
5. Healthcheck con `ss` no instalado en la imagen
6. Bucle de re-enrollment del agente por nombre duplicado
7. `agent-auth: invalid option -- 'F'` (flag inexistente en 4.9.x)
8. `ossec-control: No such file` (binario renombrado en 4.x)
9. Verificación del stack y examen final de integración con la red ZT

---

## Problema 1 — Error de credenciales de Docker en WSL2

### Síntoma
Durante el build del agente, al hacer pull de `ubuntu:22.04`:
```
failed to solve: error getting credentials
```
`docker login` fallaba con:
```
failed to store tokens: error storing credentials
```

### Diagnóstico
Problema conocido de Docker Desktop + WSL2: el credential helper configurado en `~/.docker/config.json` (`"credsStore": "desktop.exe"`) no es accesible desde dentro del entorno WSL2, impidiendo cachear o recuperar credenciales incluso para imágenes públicas.

### Solución
Editar `~/.docker/config.json` en WSL2 y vaciar el helper:
```json
{
  "credsStore": ""
}
```
Con el helper deshabilitado, Docker recurre al comportamiento por defecto y puede tirar imágenes públicas sin autenticación. **El build del agente pasó a completarse limpiamente.**

---

## Problema 2 — `wazuh-manager` no arranca: `ossec.conf` no existe

### Síntoma
```
The path /var/ossec/etc is already mounted
No Wazuh configuration files to mount...
sed: can't read /var/ossec/etc/ossec.conf: No such file or directory
wazuh-csyslogd: Configuration error. Exiting
dependency failed to start: container wazuh-wazuh-manager-1 is unhealthy
```

### Diagnóstico
La imagen `wazuh/wazuh-manager:4.9.2` declara `VOLUME /var/ossec/etc` en su propio Dockerfile. Docker crea **automáticamente un volumen anónimo** vacío en esa ruta aunque no se especifique en el compose. El script de init detecta el mount, asume que la configuración ya está provista y **se salta la copia del `ossec.conf` por defecto** → el manager no encuentra su configuración y muere.

Eliminar el volumen `wazuh_etc` explícito del compose no bastaba: Docker seguía creando el anónimo por la directiva `VOLUME` de la imagen.

### Solución (intermedia, ver Problema 3)
Extraer la configuración por defecto de la imagen y montarla. Primer intento: bind mount del fichero individual `ossec.conf`. Esto desencadenó el Problema 3.

---

## Problema 3 — `sed: cannot rename ... Device or resource busy` + `shared/ar.conf` ausente

### Síntoma
Tras bind-montar solo `ossec.conf`:
```
sed: cannot rename /var/ossec/etc/sedFyxeoa: Device or resource busy
wazuh-analysisd: ERROR: (1103): Could not open file 'etc/shared/ar.conf'
wazuh-analysisd: CRITICAL: (1202): Configuration error at 'etc/ossec.conf'.
```

### Diagnóstico (dos problemas encadenados)
1. **`sed -i` sobre un bind mount de fichero individual falla.** `sed -i` crea un temporal (`sedXXXXXX`) y hace `rename()` sobre el original. El kernel no permite `rename()` sobre un mount point de fichero → "Device or resource busy".
2. **Faltaba el directorio `shared/`** (`ar.conf`, `agent.conf`, etc.) porque solo se montó el fichero `ossec.conf`, no el árbol completo de `/var/ossec/etc`.

### Solución definitiva
Extraer el directorio **completo** `/var/ossec/etc` de la imagen a un directorio local y montarlo entero (writable):

```bash
docker create --name tmp_manager wazuh/wazuh-manager:4.9.2
docker cp tmp_manager:/var/ossec/data_tmp/permanent/var/ossec/etc ./manager/wazuh_etc
docker rm tmp_manager

# Copiar las reglas custom dentro del árbol extraído
cp ./manager/local_rules.xml ./manager/wazuh_etc/rules/local_rules.xml
```

Compose del manager:
```yaml
volumes:
  - ./manager/wazuh_etc:/var/ossec/etc     # directorio completo, writable
  - wazuh_logs:/var/ossec/logs
  - wazuh_queue:/var/ossec/queue
```

**Por qué funciona:** un bind mount de directorio es writable en su interior — `sed` puede crear y renombrar temporales dentro del mismo filesystem. Y todos los subdirectorios (`shared/`, `rules/`, `decoders/`) existen desde el primer arranque.

### Resultado
```
Starting Wazuh v4.9.2...
Started wazuh-analysisd...
Started wazuh-remoted...
Completed.
[cont-init.d] 2-manager: exited 0.
```
**El manager arrancó con todos sus daemons.** Quedaba el healthcheck.

---

## Problema 4 — Healthcheck da falso negativo (`wazuh-control status` + NTFS)

### Síntoma
El manager arrancaba correctamente pero el contenedor se marcaba `unhealthy` tras ~3 min, bloqueando al agente (que dependía de `service_healthy`). En el log aparecía antes:
```
Could not chmod cdb list 'etc/lists/audit-keys.cdb' to 660: Operation not permitted
```

### Diagnóstico
El healthcheck original era:
```yaml
test: ["CMD", "/var/ossec/bin/wazuh-control", "status"]
```
`wazuh-control status` hace `chmod 660` sobre ficheros `.cdb` en `/var/ossec/etc/lists/` antes de comprobar el estado. Como ese directorio está montado desde Windows (NTFS), el `chmod` falla con "Operation not permitted". El script interpreta ese fallo como estado no saludable y devuelve exit 1 **aunque todos los procesos estén corriendo**. Es un **falso negativo** por limitación del filesystem, no un fallo real.

### Análisis de la decisión (¿es trampa cambiar el healthcheck?)
Se discutió explícitamente. Conclusión: no es "hacer que pase a la fuerza", es adaptar la comprobación a las limitaciones reales del entorno. `wazuh-control status` es exhaustivo (lee `ossec.conf`, ficheros `.pid` y hace `kill -0`), pero da falsos negativos en NTFS/WSL2. Se documenta como limitación de lab.

### Solución (ver Problema 5 para el binario final)
Cambiar a una comprobación de puertos / procesos que no dependa de `chmod`.

---

## Problema 5 — Healthcheck con `ss` no instalado en la imagen

### Síntoma
Primer reemplazo del healthcheck con `ss`:
```yaml
test: ["CMD-SHELL", "ss -tlnp | grep -q ':1514' && ss -tlnp | grep -q ':1515'"]
```
Seguía marcando `unhealthy` agotando todos los reintentos (~180s).

### Diagnóstico
La imagen del manager está basada en Amazon Linux 2023 minimal y **no incluye `ss`** (paquete `iproute`). Al ejecutar `ss`, la shell devuelve `127` (command not found) → unhealthy en todos los intentos.

### Solución final
Usar `pgrep` (de `procps-ng`, sí presente en la imagen):
```yaml
healthcheck:
  test: ["CMD-SHELL", "pgrep wazuh-remoted >/dev/null 2>&1 && pgrep wazuh-authd >/dev/null 2>&1"]
  interval: 10s
  timeout: 5s
  retries: 15
  start_period: 30s
```
- `wazuh-remoted` → puerto 1514 (los agentes conectan)
- `wazuh-authd` → puerto 1515 (enrollment)

**El manager pasó a `Healthy` y el agente arrancó.**

---

## Problema 6 — Bucle de re-enrollment del agente: nombre duplicado

### Síntoma
```
wazuh-authd: WARNING: Duplicate name 'zt-lab-agent', rejecting enrollment.
              Agent '001' key already exists on the manager.
agent-auth: ERROR: Duplicate agent name: zt-lab-agent (from manager)
wazuh-agent-1 exited with code 1 (restarting)
```
El agente entraba en bucle infinito de reinicios.

### Diagnóstico
El directorio `./manager/wazuh_etc/` es un **bind mount**, no un volumen nombrado. `docker compose down -v` borra los volúmenes nombrados (`wazuh_logs`, `wazuh_queue`) pero **no el bind mount**, así que el `client.keys` con el agente registrado persiste entre reinicios.

### Solución inmediata
Borrar el agente registrado:
```bash
docker exec wazuh-wazuh-manager-1 /var/ossec/bin/manage_agents -r 001
# -> Agent '001' removed.
```

### Solución permanente (re-enrollment forzado)
En `manager/wazuh_etc/ossec.conf`, dentro de `<auth>`, añadir el bloque `<force>`:
```xml
<force>
  <enabled>yes</enabled>
  <disconnected_time enabled="no">0s</disconnected_time>
  <after_registration_time>0s</after_registration_time>
  <key_mismatch>yes</key_mismatch>
</force>
```
> **Nota de afinado:** se probó primero con `disconnected_time enabled="yes"`, pero ese parámetro solo aplica a agentes que **llegaron a conectarse** y luego se desconectaron. Como el agente fallaba antes de conectar, había que poner `enabled="no"` para que esa condición se ignore y el `<force>` acepte el re-enrollment de cualquier agente. El `<purge>yes</purge>` ya presente elimina la clave anterior al re-enrollar.

---

## Problema 7 — `agent-auth: invalid option -- 'F'`

### Síntoma
```
/var/ossec/bin/agent-auth: invalid option -- 'F'
wazuh-agent-1 exited with code 1 (restarting)
```

### Diagnóstico
El `entrypoint.sh` usaba `agent-auth ... -F 0` para forzar re-enrollment desde el cliente. **El flag `-F` no existe en `agent-auth` 4.9.2** (era de versiones 3.x/4.x tempranas). El help del binario lo confirmó: no aparece `-F` en la lista de opciones.

En 4.9.x el re-enrollment forzado se gestiona **exclusivamente desde el manager** vía el bloque `<force>` del `ossec.conf` (Problema 6), no desde el cliente.

### Solución
Eliminar `-F 0` del comando:
```bash
/var/ossec/bin/agent-auth -m "${MANAGER}" -A "${AGENT_NAME}" -p 1515
```

---

## Problema 8 — `ossec-control: No such file or directory`

### Síntoma
```
agent-auth: INFO: Valid key received          <- enrollment OK por fin
/entrypoint.sh: line 18: /var/ossec/bin/ossec-control: No such file or directory
```
El agente se registraba bien pero el contenedor moría al intentar arrancar servicios, volviendo a un bucle de reinicio.

### Diagnóstico
En Wazuh 4.x el binario se llama `wazuh-control`, no `ossec-control` (nombre de la era 3.x). El paquete `wazuh-agent` en Ubuntu 22.04 instala `wazuh-control`.

### Solución
Cambiar la línea de arranque en `entrypoint.sh`. El `entrypoint.sh` final quedó:
```bash
#!/bin/bash
set -e

MANAGER="${WAZUH_MANAGER:-wazuh-manager}"
AGENT_NAME="${WAZUH_AGENT_NAME:-zt-lab-agent}"

echo "[wazuh-agent] Esperando a que el manager responda en ${MANAGER}:1515..."
until nc -z "${MANAGER}" 1515 2>/dev/null; do
    echo "[wazuh-agent] Manager no disponible, reintentando en 5s..."
    sleep 5
done
echo "[wazuh-agent] Manager listo."

echo "[wazuh-agent] Registrando agente '${AGENT_NAME}'..."
/var/ossec/bin/agent-auth -m "${MANAGER}" -A "${AGENT_NAME}" -p 1515

echo "[wazuh-agent] Iniciando todos los servicios..."
/var/ossec/bin/wazuh-control start
echo "[wazuh-agent] Agente en marcha."
exec tail -f /var/ossec/logs/ossec.log
```

> **Nota:** Como `entrypoint.sh` se copia en la imagen (`COPY entrypoint.sh` en el Dockerfile), cada cambio en él requiere reconstruir: `docker compose down && docker compose up --build`.

> **Iteración intermedia:** se probó `exec /var/ossec/bin/wazuh-agentd -f` (solo el daemon de comunicación). Funcionó para conectar al manager, pero **no arrancaba los módulos** (`wazuh-syscheckd`, `wazuh-modulesd`, `wazuh-logcollector`), por lo que no había FIM ni docker-listener. Se cambió a `wazuh-control start` para activar el stack completo del agente.

### Resultado
```
agent-auth: INFO: Valid key received
wazuh-agentd: INFO: Using AES as encryption method.
wazuh-agentd: INFO: (4102): Connected to the server ([wazuh-manager]:1514/tcp).
wazuh-syscheckd: Monitoring path: '/monitored/certs' ... realtime
wazuh-logcollector: Monitoring output of command(15): ps auxww
wazuh-modulesd:docker-listener: Starting to listening Docker events.
wazuh-syscheckd: Real-time file integrity monitoring started.
```

---

## Verificación del stack Wazuh (aislado)

### Procesos en el agente (`ps aux`)
Gracias a `pid: host`, el agente ve los daemons del manager (diseño de observabilidad ZT). Además, los daemons propios del agente arrancados por `wazuh-control start`:
```
wazuh-agentd        (user: wazuh)  <- comunicación, AES
wazuh-syscheckd                    <- FIM
wazuh-logcollector                 <- ps auxww
wazuh-modulesd                     <- docker-listener
wazuh-execd
```

### Estado del manager (`wazuh-control status`)
9 daemons críticos corriendo: `wazuh-remoted`, `wazuh-analysisd`, `wazuh-authd`, `wazuh-syscheckd`, `wazuh-modulesd`, `wazuh-logcollector`, `wazuh-db`, `wazuh-execd`, `wazuh-apid`. Los no activos (`wazuh-clusterd`, `wazuh-maild`, `wazuh-csyslogd`, etc.) son opcionales/deshabilitados a propósito.

### Pruebas de detección (aisladas)
| Test | Comando | Regla | Nivel | Resultado |
|---|---|---|---|---|
| Agente conectado | (enrollment) | 501 | 3 | ✅ "New wazuh agent connected" |
| docker-listener | `docker run --rm hello-world` | 87929 | 4 | ✅ "Docker: Network bridge disconnected" |
| FIM realtime | `touch .../certs/test_fim.pem` (desde host) | 554 | 5 | ✅ "File added to the system" con hashes MD5/SHA1/SHA256 |

> **Aprendizaje sobre FIM:** `cat /etc/shadow` o `su - nobody` vía `docker exec` **no** generan alertas. FIM detecta **cambios** en ficheros monitorizados (no lecturas), y sin `auditd` el acceso de lectura es invisible. Además los `docker exec` no pasan por el namespace del agente. El test válido de FIM es **modificar un fichero dentro de la ruta monitorizada** (`/monitored/certs`), preferiblemente desde el host porque el volumen está montado `:ro` dentro del contenedor (correcto por Zero Trust — los certificados no deben ser modificables desde dentro).

---

## Examen final — Integración con el resto de la red ZT

### Situación de partida: dos stacks independientes
El stack ZT (`infra/zero_trust/`) y el stack Wazuh (`infra/zero_trust/wazuh/`) se levantan por separado. Para que el agente pueda enviar tráfico a los servicios ZT, se conectó a sus redes como **redes externas**.

### Paso 1 — Levantar el stack ZT
```bash
cd /mnt/c/Users/coryy/TFG/TFG-ZeroTrust/infra/zero_trust
docker compose up --build -d
docker compose ps   # backend healthy, db/nginx/webapp Up
curl http://localhost:8080   # portal corporativo con empleados de la BD ✓
```
Pipeline completo `nginx → webapp → backend (mTLS) → db` funcionando.

### Paso 2 — Conectar el agente Wazuh a las redes ZT
Las redes del stack ZT se llaman con prefijo de directorio:
```bash
docker network ls | grep zero_trust
# zero_trust_backend_zone, zero_trust_db_zone, zero_trust_web_zone
```
Cambios en `wazuh/docker-compose.yaml`:
```yaml
  wazuh-agent:
    networks:
      - wazuh_net
      - zt_web_zone
      - zt_backend_zone

networks:
  wazuh_net:
    driver: bridge
  zt_web_zone:
    external: true
    name: zero_trust_web_zone
  zt_backend_zone:
    external: true
    name: zero_trust_backend_zone
```
```bash
cd infra/zero_trust/wazuh
docker compose up -d --force-recreate wazuh-agent
```
El docker-listener capturó la conexión del agente a las redes: reglas `87928` ("Network zero_trust_web_zone connected").

### Paso 3 — Escenarios de ataque/defensa

> **Errores de comando corregidos durante el paso 3:**
> - `nmap` no está instalado en el contenedor del agente, pero **sí en `backend`** (su Dockerfile instala `curl nmap nginx`). Se lanzó el scan desde `backend`.
> - Typos por copia: `nmap-sT` → `nmap -sT`; `curl-k` → `curl -k`.
> - Ruta duplicada: estando ya en `infra/zero_trust/`, usar `docker compose stop backend` (no `-f infra/zero_trust/...`).

#### Escenario 1 — Operación normal ✅
`curl http://localhost:8080` devuelve el portal con datos de BD.

#### Escenario 2/3 — Port scan + microsegmentación (T1046) ✅
```bash
docker exec zero_trust-backend-1 nmap -sT -p 80,443,5432 nginx webapp db
```
Resultado:
- `nginx` → **no resuelve** (no está en `backend_zone`) → microsegmentación L3 confirmada.
- `webapp` (172.18.0.3) → 80/443/5432 **closed**.
- `db` (172.19.0.2) → solo **5432 open** (lo único que debe estar abierto).

Detección Wazuh:
```
Rule: 100100 (level 12) -> 'ZT: proceso nmap detectado - reconocimiento interno (T1046)'  (x2)
```

#### Escenario 4 — Violación mTLS ✅ BLOQUEADA
```bash
docker exec wazuh-wazuh-agent-1 curl -k https://backend:443/empleados
```
Respuesta del Nginx PEP del backend:
```
400 Bad Request — No required SSL certificate was sent
```
El PEP mTLS (`ssl_verify_client on`) rechaza el acceso sin certificado cliente. (Control de red → no genera alerta de agente, es lo correcto.)

#### Escenario 5 — Modificación/adición de certificados (T1552.004) ✅
```bash
touch /mnt/c/.../infra/zero_trust/certs/ca_exfil_copy.crt
```
Detección:
```
Rule: 554 (level 5) -> 'File added to the system.'
Rule: 100120 (level 14) -> 'ZT: modificacion en certificados mTLS - posible T1552.004'
```

#### Escenario 6 — Stop/Start de servicio ZT (docker-listener) ✅
```bash
docker compose stop backend
docker compose start backend
```
Detección:
```
Rule: 87929 (level 4) -> 'Docker: Network zero_trust_backend_zone disconnected'
Rule: 87929 (level 4) -> 'Docker: Network zero_trust_db_zone disconnected'
Rule: 87928 (level 3) -> 'Docker: Network zero_trust_db_zone connected'
Rule: 87928 (level 3) -> 'Docker: Network zero_trust_backend_zone connected'
```

### Tabla de resultados del examen final

| Escenario | Control ZT | Detección Wazuh | Regla | Nivel |
|---|---|---|---|---|
| Operación normal (curl portal) | ✅ Funciona | — | — | — |
| mTLS violation (curl sin cert) | ✅ Nginx bloquea 400 | — (control de red) | — | — |
| Port scan nmap (T1046) | ✅ Microsegmentación limita | ✅ Detectado | 100100 | 12 |
| Modificación certs (T1552.004) | ✅ FIM realtime | ✅ Detectado | 100120 | 14 |
| Fichero añadido a certs | ✅ FIM realtime | ✅ Detectado | 554 | 5 |
| Stop/Start servicio ZT | — | ✅ Detectado | 87929/87928 | 3-4 |
| Agente conectado/desconectado | — | ✅ Detectado | 501/503/506 | 3 |

---

## Comportamientos esperados (no errores)

- **`DNS lookup failure "wazuh.indexer"`** repetido en el log del manager: la imagen incluye Filebeat preconfigurado para enviar alertas al Wazuh Indexer (Elasticsearch). En este lab mínimo no hay indexer → Filebeat queda en bucle de reconexión en background. **No es fatal**: el manager procesa eventos y escribe alertas localmente en `/var/ossec/logs/alerts/alerts.json`. Se documenta como limitación conocida del stack mínimo.
- **`Could not connect to socket 'queue/sockets/com'`** (visto cuando solo corría `wazuh-agentd -f`): el socket IPC lo crea `wazuh-modulesd`. Con `wazuh-control start` (stack completo) deja de ser relevante.

---

## Cambios consolidados de la sesión

### `wazuh/docker-compose.yaml`
- Manager: volumen `./manager/wazuh_etc:/var/ossec/etc` (directorio completo extraído de la imagen) + `wazuh_logs` + `wazuh_queue`.
- Manager: healthcheck con `pgrep wazuh-remoted && pgrep wazuh-authd`.
- Agente: conectado a `wazuh_net` + redes externas `zt_web_zone` + `zt_backend_zone`.

### `wazuh/manager/wazuh_etc/` (nuevo directorio extraído)
- Árbol completo de `/var/ossec/etc` con `ossec.conf`, `shared/`, `rules/`, `decoders/`.
- `ossec.conf`: bloque `<force>` con `disconnected_time enabled="no"` y `key_mismatch yes` en `<auth>`.
- `rules/local_rules.xml`: copia de las reglas custom ZT.

### `wazuh/agent/entrypoint.sh`
- Sin flag `-F 0` en `agent-auth`.
- `wazuh-control start` (no `ossec-control`).
- `exec tail -f /var/ossec/logs/ossec.log` como proceso final.

---

## Aprendizajes clave (para el TFG, Cap. 5 y 6)

1. **`VOLUME` en imágenes Docker crea volúmenes anónimos** aunque no se declaren: hay que montar explícitamente el contenido o el init de la app puede fallar.
2. **`sed -i` no funciona sobre bind mounts de fichero individual** (rename bloqueado): montar el directorio completo.
3. **NTFS/WSL2 no soporta permisos POSIX** (`chmod` falla): los healthchecks que dependen de permisos dan falsos negativos. Preferir comprobaciones de proceso/puerto.
4. **Imágenes minimal no traen `ss`**: usar `pgrep` para healthchecks.
5. **El re-enrollment forzado en Wazuh 4.9.x es responsabilidad del manager** (`<force>` en `ossec.conf`), no del cliente; el flag `-F` de `agent-auth` ya no existe.
6. **`ossec-control` → `wazuh-control`** desde la rama 4.x.
7. **FIM detecta cambios, no lecturas**; sin `auditd` los accesos de lectura son invisibles. Los volúmenes `:ro` protegen los certificados pero impiden tests de escritura desde dentro del contenedor.
8. **Conexión entre stacks Docker Compose** mediante `external: true` + `name:` con el prefijo de directorio del proyecto.

---

## Estado al cierre de la sesión

- ✅ Fase 5 (Wazuh) implementada y verificada.
- ✅ Checkpoint Wazuh 20:00 superado con creces (no solo 1 alerta: 7 tipos de regla verificados).
- ✅ Examen final de integración con la red ZT superado: microsegmentación + mTLS + observabilidad end-to-end.
- ⏳ Fallback Wazuh→Falco **descartado** (no necesario, Wazuh operativo).

---

## Próximos pasos (para la siguiente sesión)

### Inmediato (cerrar hoy)
- [ ] **Commit** del estado estable de la Fase 5:
  ```bash
  cd /mnt/c/Users/coryy/TFG/TFG-ZeroTrust
  git add infra/zero_trust/ docs/04_diario_laboratorio/ admin/
  git commit -m "Fase 5 Wazuh: manager+agent Docker, FIM realtime, docker-listener, reglas MITRE T1046/T1552.004 verificadas"
  ```
- [ ] Actualizar `admin/STATE.md`: mover `implementar_escenario_b` a DONE; activar `ejecutar_pruebas_ab`.
- [ ] Guardar evidencia bruta:
  ```bash
  docker exec wazuh-wazuh-manager-1 cat /var/ossec/logs/alerts/alerts.json > docs/04_diario_laboratorio/alerts_20260604.json
  docker compose ps > docs/04_diario_laboratorio/stack_status_20260604.txt
  ```

### 05-08/06 — Pruebas A/B y cierre de KPIs (hito 09/06)
- [ ] Capturar KPIs comparativos Escenario A (perimetral) vs B (Zero Trust): MTTD, tasa de bloqueo mTLS, profundidad de ataque, superficie interna visible, integridad de flujo.

### 09-13/06 — Redacción
- [ ] Caps. 3 (Análisis), 4 (Diseño), 5 (Desarrollo), 6 (Pruebas) usando los diarios de laboratorio y los ADR como fuente directa.

### Pendiente vencido (de STATE.md)
- [ ] `email_tutor_31_05` — envío al tutor con estado actual.
- [ ] `redactar_eda_v0` — cerrar secciones `[TODO]` del Estado del Arte.
