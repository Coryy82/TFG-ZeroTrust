# Capítulo 5 — Desarrollo e Implantación

> **Estado:** BORRADOR — §5.1–§5.5 redactados [HUMANO]. Pendiente: insertar figuras y anexos de configuración.
> Criterio del tutor: documentar decisiones y resultados relevantes de la implantación, no cada cambio menor del laboratorio.
> Configuraciones completas (compose, reglas Wazuh, certificados) → Anexos.
> Objetivo de extensión: 10-14 páginas.

[REV-ESTILO: §5 (general) — alto volumen de bloques de comandos en el cuerpo. La guía editorial recomienda llevar lo extenso/prescindible a Anexos y dejar en el cuerpo solo los comandos de verificación mínimos. Sugerencia: mover los bloques más largos al anexo. Sin reescribir; decide el autor. Prioridad 2.]

---

## 5.1 Infraestructura como código (IaC)

#### Texto redactado [HUMANO]

El capítulo de diseño fijó la topología, los controles y el protocolo de pruebas de cada escenario. En este capítulo describimos cómo trasladamos ese diseño a contenedores Docker ejecutables: qué servicios levantamos, qué comandos validamos en cada fase y qué decisiones tomamos cuando la implementación chocaba con el entorno de laboratorio.

Hemos representado los dos escenarios comparativos como dos conjuntos de Docker Compose independientes. Cada servicio, red y variable de entorno queda definido en ficheros de configuración versionados, de modo que cualquier sesión puede reproducirse desde un estado conocido con:

```bash
docker compose up --build -d
```

Para no depender de copias manuales durante las pruebas, automatizamos la captura con dos scripts bash: uno para el escenario perimetral y otro para Zero Trust. Ambos levantan el entorno, dejan una pausa para ejecutar el ataque manual, copian los artefactos generados en `webapp` y vuelcan los logs de los contenedores a una carpeta de sesión en el host. El detalle línea a línea de cada script figura en el anexo.

[FIG: Esquema del flujo IaC — diseño (cap. 4) → ficheros compose → `docker compose up` → contenedores en ejecución → script de captura → carpeta de sesión]

---

## 5.2 Implementación del Escenario A (Perimetral)

### 5.2.1 Estructura de la aplicación

#### Texto redactado [HUMANO]

Trasladamos el diseño perimetral a un compose con cuatro servicios:

1. **Nginx** escucha en el puerto `:80` del host y es el único punto de entrada externo.
2. **La aplicación web** (`webapp`) corre Flask con plantillas Jinja2 y se conecta a dos redes Docker: `net_dmz` y `net_interna`, lo que la convierte en el pivot natural del ataque una vez obtenida ejecución remota.
3. **El backend** expone una API REST de empleados en `/empleados` sin autenticación adicional.
4. **PostgreSQL** almacena los datos de prueba.

La lógica de negocio es la misma que en el Escenario B, lo que cambia es la topología de red y la ausencia de controles post-compromiso. Para comprobar que el stack arranca correctamente ejecutamos:

```bash
docker compose up --build -d
docker compose ps
curl -I http://localhost/
```

[FIG: Captura de `docker compose ps` con los cuatro servicios del Escenario A en estado *Up*]

[FIG: Diagrama de implantación Escenario A — asignación de contenedores a `net_dmz` y `net_interna`]

---

### 5.2.2 Punto de entrada: cadena hasta la ejecución remota

[REV-ESTILO: §5.2.2 — tecnicismos sin glosa en primera mención (SSTI, CWE-xxxx) para un tribunal generalista. Sugerencia: nota breve o remitir al glosario. Sin reescribir; decide el autor. Prioridad 3.]

#### Texto redactado [HUMANO]

El diseño exige un atacante externo que, tras comprometer `webapp`, inicie la ventana de medición post-explotación. En la implementación materializamos ese acceso inicial con una cadena encadenada (no con un único endpoint vulnerable) que termina en ejecución remota vía SSTI en Jinja2 [CITAR: OWASP CWE-1336 — Server Side Template Injection]:

1. Reconocimiento HTTP del portal.
2. Filtrado de rutas internas en `robots.txt` (CWE-200).
3. Recuperación de credenciales de administrador en `backup.txt` (CWE-522 / CWE-798).
4. Acceso al panel de administración sin segundo factor (CWE-306).
5. Confirmación de inyección de plantillas en `/admin/diagnostico?host=` y obtención de RCE (CWE-1336).

Esta cadena nos permite fijar de forma reproducible el instante en que el atacante dispone de reverse shell en `webapp`, que es el punto de partida común a ambos escenarios. El detalle de la cadena de ataque y sus resultados corresponde al capítulo de pruebas, aquí documentamos únicamente que la aplicación se implementó con esos endpoints deliberadamente débiles para habilitar el acceso inicial acordado en el diseño.

[FIG: Secuencia de capturas del panel de administración y confirmación de SSTI hasta reverse shell en `webapp`]

---

### 5.2.3 Decisiones de implementación

#### Texto redactado [HUMANO]

Al implantar el Escenario A tomamos dos decisiones que condicionaron el laboratorio y no formaban parte del diseño en papel:

1. **Refactor del servicio web con SSTI en Jinja2.** La primera versión implementada usaba un único endpoint con ejecución de comandos. Lo sustituimos por la cadena documentada en §5.2.2 para fijar un acceso inicial reproducible sin cambiar el stack Flask ni añadir contenedores nuevos.
2. **Script de captura automatizado.** Los primeros ensayos copiaban artefactos a mano y se perdían al tumbar el compose. Automatizamos el flujo con un script que integra `docker compose cp` antes del volcado de logs y del posible `compose down`.

[FIG: Esquema del script de captura perimetral — pausa de ataque, copia de artefactos y volcado de logs]

---

### 5.2.4 Protocolo de captura de evidencias

[REV-ESTILO: §5.2.4 (y §5.2.3, línea con "tumbar el compose") — coloquialismo "tumbar el entorno/el compose"; la guía pide registro denotativo. Sugerencia: "detener/desmontar el entorno". Sin reescribir; decide el autor. Prioridad 3.]

#### Texto redactado [HUMANO]

El script de captura del Escenario A estructura el trabajo en cinco pasos:

1. Levantar el docker-compose (`docker compose up --build -d`).
2. Ejecutar manualmente la cadena de ataque y los hitos post-RCE desde la reverse shell.
3. Copiar desde `webapp` los cinco artefactos esperados: `lateral.pcap`, `lateral.json`, `creds.txt`, `dump.txt`, `e1_scan.log`.
4. Volcar los logs por servicio (Nginx, webapp, backend, base de datos).
5. Opcionalmente, tumbar el entorno o mantenerlo activo si se requieren pruebas adicionales.

[FIG: Terminal con el paso de copia de artefactos desde `webapp` y listado de ficheros de la sesión con tamaño en bytes]

---

## 5.3 Implementación del Escenario B (Zero Trust)

La implantación del Escenario B siguió el orden del diseño: primero segmentación, después separación de secretos, después mTLS y, por último, despliegue de Wazuh. Cada fase se validó antes de pasar a la siguiente.

### 5.3.1 Segmentación de redes

[REV-ESTILO: §5.3.1 — "multihomed" es un tecnicismo sin glosa en primera mención. Sugerencia: aclaración breve ("conectado a varias redes") o glosario. Sin reescribir; decide el autor. Prioridad 3.]

#### Texto redactado [HUMANO]

Sustituimos las dos redes del Escenario A por tres zonas aisladas en el compose de Zero Trust:

1. `web_zone` — Nginx y `webapp`.
2. `backend_zone` — `webapp` y `backend`.
3. `db_zone` — `backend` y `db`.

`webapp` queda multihomed en `web_zone` y `backend_zone`, pero sin interfaz en `db_zone`, porque la aplicación web no necesita hablar con PostgreSQL: toda la lógica de datos pasa por la API interna.

Tras `docker compose up --build -d`, verificamos la segmentación desde `webapp`:

```bash
# Camino legítimo — debe responder
docker exec <contenedor_webapp> curl -s http://backend:5000/health

# Salto prohibido webapp → db — debe fallar la resolución DNS
docker exec <contenedor_webapp> python -c \
  "import socket; socket.create_connection(('db',5432), timeout=3)"
```

El segundo comando devuelve `No address associated with hostname`: Docker no resuelve el nombre `db` fuera de `db_zone`. La contención es de capa 3, no solo de una regla de firewall que pudiera omitirse por error de configuración.

[FIG: Salida de terminal — `curl` a backend OK y fallo de resolución DNS al intentar `db:5432` desde `webapp`]

[FIG: Diagrama de implantación Escenario B — tres zonas y contenedores multihomed]

---

### 5.3.2 Identidad de servicio y credenciales

#### Texto redactado [HUMANO]

El diseño exigía que comprometer `webapp` no expusiera las credenciales de base de datos. En la implementación eliminamos `DB_HOST` y `DB_PASSWORD` del entorno de `webapp` y dejamos únicamente la URL del backend cifrado:

```
BACKEND_URL=https://backend:443/empleados
```

Las credenciales de PostgreSQL permanecen solo en `backend`, el único servicio con ruta hacia `db`. Comprobamos el aislamiento con:

```bash
docker exec <contenedor_webapp> env | grep -iE "db_|pass"
```

La salida debe quedar vacía. Este cambio no altera la funcionalidad del portal: `webapp` nunca consultaba la base de datos directamente, solo consumía la API interna.

[FIG: Comparativa lado a lado — variables de entorno de `webapp` en Escenario A (con `DB_PASSWORD`) frente a Escenario B (solo `BACKEND_URL`)]

---

### 5.3.3 Implementación de mTLS

#### Texto redactado [HUMANO]

El diseño protege el canal `webapp → backend` con mTLS. La implantación siguió estos pasos:

1. **Generar CA y certificados con OpenSSL** — certificado de servidor con `subjectAltName=DNS:backend` y `serverAuth`; certificado de cliente con `clientAuth`.
2. **Montar los certificados en runtime** — los ficheros se inyectan como volúmenes al arrancar el contenedor, no se incluyen en la imagen Docker. Así podemos rotar material criptográfico sin reconstruir la imagen.
3. **Configurar Nginx como PEP dentro de `backend`** — escucha en el puerto 443, exige certificado de cliente (`ssl_verify_client on`) y reenvía al proceso Flask en `localhost:5000`.
4. **Configurar el cliente en `webapp`** — las peticiones a la API usan HTTPS presentando el certificado de cliente firmado por la CA local.

En el contenedor `backend`, Nginx y Flask conviven según el diseño del Escenario B: Nginx termina TLS en el puerto 443 y reenvía al proceso Flask escuchando solo en la interfaz de loopback (`127.0.0.1:5000`).

Verificación operativa:

```bash
# Con certificado de cliente — debe devolver HTTP 200
docker exec <contenedor_webapp> curl -sk \
  --cert /ruta/client.crt --key /ruta/client.key \
  https://backend:443/empleados

# Sin certificado — Nginx rechaza el handshake o devuelve error TLS
docker exec <contenedor_webapp> curl -sk https://backend:443/empleados
```

[FIG: Fragmento de la configuración Nginx con `ssl_verify_client on` y `proxy_pass` a Flask — configuración completa en anexo]

[FIG: Captura de `curl` con certificado (200 OK JSON) frente a `curl` sin certificado (rechazo TLS)]

---

### 5.3.4 Despliegue de Wazuh

#### Texto redactado [HUMANO]

El montaje de Wazuh se realizó en un segundo compose, una vez levantado el stack de aplicación:

1. **Levantar manager y agente** como contenedores adicionales vinculados a las redes ya creadas por el Escenario B.
2. **Montar el socket de Docker en el agente** y arrancarlo con visibilidad de procesos del host (`--pid=host`), de modo que puede inspeccionar procesos dentro de `webapp`.
3. **Configurar el recolector** para ejecutar cada dos segundos un script que, vía API Docker, lee `/proc/*/cmdline` dentro de `webapp` (fuente `process-webapp`).
4. **Cargar las reglas locales** en el manager y reiniciar manager y agente para aplicar la configuración.
5. **Comprobar el enrollment** — el agente debe aparecer activo en el manager antes de iniciar la ventana post-RCE.

Sobre los eventos de `process-webapp` aplicamos reglas locales alineadas con los hitos de la cadena de ataque:

| Regla   | Comportamiento detectado        |
|---------|---------------------------------|
| 100100  | Escaneo con `nmap`              |
| 100101  | `curl` hacia `backend`          |
| 100102  | Captura con `tcpdump`           |
| 100103  | Acceso con `psql`               |
| 100104  | Búsqueda de credenciales (`grep`)|

Un muestreo de respaldo con `process-list` cada cinco segundos cubre procesos más duraderos. Antes de iniciar el ataque comprobamos que el agente ve procesos en `webapp`:

```bash
docker exec <contenedor_agente> bash /ruta/process-webapp.sh
```

La salida debe listar al menos el proceso Python de la aplicación. Si no es así, esperamos unos segundos y repetimos: no iniciamos la ventana post-RCE sin telemetría operativa.

[FIG: Arquitectura de despliegue Wazuh — manager, agente, socket Docker y flujo hacia alertas]

[FIG: Captura de una alerta en el log del manager (regla 100100 u otra) con timestamp visible]

---

## 5.4 Puesta en marcha del laboratorio (primera vez)

#### Texto redactado [HUMANO]

Pasamos de la implantación a un laboratorio operativo siguiendo un procedimiento común para ambos escenarios, con una variante en Zero Trust por la dependencia de Wazuh respecto a las redes del stack principal.

**Requisitos del host**

1. Docker Desktop con motor Linux (en nuestro caso sobre WSL2 en Windows).
2. Docker Compose v2.
3. Herramientas de línea de comandos en el host: `curl`, `openssl`, cliente PostgreSQL opcional para depuración.

**Arranque del Escenario A (perimetral)**

1. Situarse en el directorio del compose perimetral.
2. Ejecutar `docker compose up --build -d`.
3. Comprobar con `docker compose ps` que Nginx, webapp, backend y `db` están levantados.
4. Verificar respuesta HTTP: `curl -I http://localhost/`.
5. Lanzar el script de captura o, si se trabaja manualmente, confirmar que los cuatro servicios aceptan tráfico antes de iniciar el ataque.

**Arranque del Escenario B (Zero Trust)**

El orden importa: Wazuh se levanta después de Zero Trust.

1. Levantar primero el compose de Zero Trust (`docker compose up --build -d` en el directorio del escenario B).
2. Comprobar healthchecks del contenedor: `curl` desde `webapp` a `backend`.
3. Levantar después el compose de Wazuh (manager + agente).
4. Esperar unos segundos a que el manager esté operativo.
5. Validar `process-webapp` (salida distinta de «no hay contenedor webapp»).

**Checklist previo al ataque (Escenario B)**

1. Cuatro contenedores de aplicación en estado *Up*.
2. Agente Wazuh enrollado y conectado al manager.
3. `process-webapp` listando procesos de `webapp`.
4. Certificados montados y `curl` mTLS de prueba respondiendo 200.
5. Entorno limpio: sin sesiones previas que dejen artefactos en `/tmp/` de `webapp`.

[FIG: Checklist visual o tabla de verificación pre-ataque con casillas OK/NO OK]

[FIG: Secuencia de capturas — `docker compose ps` Escenario B + agente Wazuh + salida de validación `process-webapp`]

---

## 5.5 Problemas de integración encontrados

#### Texto redactado [HUMANO]

Durante la implantación aparecieron incidencias que no estaban en el diseño inicial pero condicionaron el resultado final. Documentamos las que afectaron a la reproducibilidad o a la coherencia entre diseño y realidad.

**Finales de línea CRLF en scripts bash.** Los primeros intentos de ejecutar los scripts de captura en WSL fallaron con `env: $'bash\r': No such file or directory`. Los ficheros se habían editado en Windows y conservaban CRLF. Reescribimos los scripts con finales LF y forzamos en el control de versiones que los `.sh` se almacenen siempre con LF.

**Artefactos de sesión vacíos.** En una sesión de prueba temprana, algunos logs quedaron vacíos porque el entorno se destruyó antes de copiarlos desde el contenedor. Integramos la copia con `docker compose cp` como paso obligatorio del script, siempre anterior a un posible `compose down`.

**Bypass del PEP por Flask en `0.0.0.0`.** Con Nginx terminando TLS en 443, Flask seguía escuchando en `0.0.0.0:5000` dentro de `backend_zone`, de modo que `curl http://backend:5000/empleados` devolvía JSON sin pasar por mTLS. Corregimos enlazando Flask solo a `127.0.0.1`. Las sesiones de prueba realizadas antes de ese cambio no son comparables en integridad del tráfico.

**Detección Wazuh y orden de despliegue.** En una sesión intermedia los controles de segmentación y mTLS funcionaron, pero no se generaron alertas en la ventana post-RCE: el muestreo cada quince segundos no capturaba procesos efímeros como `nmap` o `curl`, y levantar el compose de Zero Trust recreaba redes que desestabilizaban el agente si Wazuh arrancaba antes. La solución combinó `process-webapp` a la escucha cada dos segundos, reglas acopladas a esa fuente y el protocolo de arranque ZT → Wazuh → validación descrito en §5.4.

[FIG: Tabla resumen «problema → síntoma → acción correctiva» de los cuatro casos anteriores]

---
