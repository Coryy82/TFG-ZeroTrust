# Capítulo 6 — Pruebas y Resultados

> **Estado:** BORRADOR — §6.1–§6.4 redactados [HUMANO]. Pendiente: figuras `[FIG:]`, revisión final de estilo.
> Fuentes: `tests/00_PLANTILLA_KPI_v2.md` §1 (A), §2 (B), §3 (comparativa) — cerradas.
> Criterio del tutor (§4): métricas estrictamente comparables entre escenarios. Pruebas de post-explotación.
> Objetivo de extensión: 12-16 páginas.

---

## 6.1 Metodología de pruebas

### 6.1.1 Entorno de pruebas

#### Texto redactado [HUMANO]

**Para realizar pruebas sobre nuestras dos topologías de red, aprovechando la versatilidad y fácil despliegue de docker, hemos optado por crear un entorno de laboratorio simple. Para este entorno realmente el único requisito es tener una herramienta de virtualización a nivel de Sistema Operativo y que sea capaz de gestionar contenedores. En nuestro caso esta herramienta es Docker Desktop con Docker Compose v2, la cual ejecutamos encima de WSL2 en una máquina Windows.**

**Cada escenario, perimetral y Zero Trust, se despliega como un stack de contenedores independiente con la misma aplicación web vulnerable, pero con una topología de red distinta. De este modo podemos repetir la misma cadena de ataque y comparar únicamente lo que ocurre una vez el atacante ya dispone de ejecución remota en webapp.**

**Para garantizar un despliegue replicable y facilitar la recogida de logs para su futuro estudio, hemos creado dos scripts (`logcapture_perimetral.sh` y `logcapture_zerotrust.sh`) que levantan el entorno correspondiente, recogen los logs de los contenedores y los copian a una carpeta de sesión en la máquina host. El detalle de su funcionamiento se incluye en el anexo.**

---

### 6.1.2 Protocolo de ejecución

#### Texto redactado [HUMANO]

**El protocolo de ejecución es el mismo en ambos escenarios, con una única diferencia en el arranque: en el perimetral levantamos el stack docker y en Zero Trust además de esto, levantamos y comprobamos que el agente Wazuh esté activo.**

**Cada sesión empieza con un entorno limpio (`docker compose up --build -d`). A continuación reproducimos la cadena de ataque previa a la ejecución de código remota, reconocimiento, filtrado de información, login y confirmación de SSTI— hasta conseguir una reverse shell en webapp. En el instante en que esta queda operativa marcamos el inicio de la ventana de medición.**

**A partir de ahí medimos siempre los mismos cuatro hitos post-explotación: 

- **Exfiltración de credenciales**
- **Escaneo de la red interna**
- **Acceso al back**
- **Volcado y exfiltración de información de la Base de 
Datos**
En cada paso guardamos el output de los comandos en logs; al terminar, el script de captura vuelca esos ficheros a una carpeta de la sesión actual para analizarlos después. Cuando acabamos, tumbamos el entorno (`docker compose down`).**

---

### 6.1.3 Definición de T0_efectivo y ventana de medición

#### Texto redactado [HUMANO]

**Fijamos el inicio de la ventana de medición en el instante en que el atacante dispone de ejecución de código remota en webapp, con una reverse shell operativa. La fase previa al RCE sirve para narrar cómo se compromete el portal, pero no entra en el cuadro comparativo entre escenarios: el punto de entrada está fijado por diseño en ambos. A partir de este punto medimos:**

- **Detección**
- **Profundidad del ataque**
- **Bloqueo de comandos desde reverse shell**
- **Superficie visible**
- **Volumen exfiltrado**
- **Integridad del tráfico interno.**

---

## 6.2 Resultados — Escenario A (Perimetral)

### 6.2.1 Cronología de la sesión oficial

Sesión: `perimetral_sesion_20260523_175204`.


| Hito pre-RCE                     | Hora CEST    | Descripción                                   |
| -------------------------------- | ------------ | --------------------------------------------- |
| Compose up — 4 servicios healthy | 17:52:16     | —                                             |
| Banner grabbing (`curl -I`)      | 17:52:55     | `Server: nginx/1.25`, cabeceras expuestas     |
| Gobuster scan                    | 17:53:10     | Descubrimiento de rutas                       |
| `GET /robots.txt`                | 17:53:22     | Rutas `/admin/login`, `/backup.txt` expuestas |
| `GET /backup.txt` → creds        | 17:53:29     | `admin:Empresa2026!` en texto claro           |
| Login → 302 OK                   | 17:53:50     | Acceso al panel de administración             |
| SSTI confirmado (`{{7*7}}` → 49) | 17:54:27     | RCE confirmado                                |
| **T0_efectivo** (shell post-RCE) | **17:57:56** | **Reverse shell operativa en `webapp`**       |



| Hito post-RCE                 | Hora CEST | Δ desde T0 | Resultado                                        |
| ----------------------------- | --------- | ---------- | ------------------------------------------------ |
| `env | grep DB_` → creds.txt  | ~17:58:20 | ~24 s      | `DB_PASSWORD=supersecret`, `DB_HOST=db` visibles |
| Nmap interno                  | ~18:02:00 | ~244 s     | `backend:5000`, `db:5432`, `nginx:80` visibles   |
| `curl backend:5000/empleados` | ~18:02:00 | ~244 s     | HTTP/JSON texto claro, 3 empleados               |
| `psql -h db` → dump.txt       | ~18:02:30 | ~274 s     | 3 filas completas de tabla `empleados`           |


---

#### Texto Redactado [HUMANO]

En esta tabla podemos observar el proceso mediante el cual el atacante obtiene primero acceso como admin al dashboard de la app web, consigue RCE y por último acceso al nodo 'webapp'. Mediante técnicas de escaneo descubre rutas comunes poco protegidas y consigue hacerse con credenciales en texto plano, las cuales usa para acceder y encontrar una vulnerabilidad que le permite conseguir una "Reverse Shell" en la que poder ejecutar código remoto. En este punto consideramos la "Assumed breach" y es desde donde empezaremos a medir las diferencias entre el escenario Perimetral y Zero Trust.

[FIG: Todas las figuras hechas de PRE-RCE]

---

### 6.2.2 Métricas KPI — Escenario A


| Código | Valor                                 | Evidencia                                                     |
| ------ | ------------------------------------- | ------------------------------------------------------------- |
| G1     | `(false, ∞)` — sin SIEM, sin alerta   | `nginx.log` + `webapp.log`: solo access logs pasivos          |
| G2     | 3 nodos (webapp → backend → db)       | `e1_scan.log`, `lateral.json`, `dump.txt`                     |
| G3     | `(false, 0%)` — ningún hito bloqueado | Todos los hitos completados exitosamente                      |
| E1     | 3/3 servicios visibles desde webapp   | `e1_scan.log`                                                 |
| E2     | 3 reg. empleados + 1 cred. DB / ~766B | `lateral.json` (304B) + `dump.txt` (427B) + `creds.txt` (35B) |
| E3     | Texto claro (HTTP/JSON sin TLS)       | `lateral.pcap` — tshark confirma HTTP/1.1 sin TLS             |


[FIG: captura tshark de lateral.pcap mostrando HTTP/JSON legible]

---

#### Texto Redactado [HUMANO]

En el escenario perimetral no hay ningún sistema de detección activo: los accesos quedan solo en logs pasivos de nginx y webapp, sin alertas ni correlación de eventos.

Una vez dentro de webapp, el atacante consigue proyectarse hasta el backend y la base de datos: la brecha alcanza los tres nodos del stack sin que ningún control de segmentación lo impida.

Ningún mecanismo de bloqueo actúa sobre el movimiento lateral: la exfiltración de credenciales, las peticiones al API interno y la consulta SQL terminan con éxito.

Desde webapp el escaneo interno muestra los tres servicios, backend en el puerto 5000, la base de datos en el 5432 y nginx en el 80, con total visibilidad de la red plana. [FIG: nmap-perimetral]

La exfiltración es efectiva: obtiene la contraseña de la BD del entorno del contenedor, descarga el JSON de tres empleados desde `/empleados` y vuelca la tabla completa, unos 766 bytes entre credenciales y datos. [FIG: peticion /empleados] y [FIG: consulta SQL]

Como el tráfico entre contenedores no va cifrado, puede capturar el intercambio HTTP con tcpdump y leer el JSON en claro en el pcap. [FIG: tcpdump, etc.]

---

## 6.3 Resultados — Escenario B (Zero Trust)

Sesión oficial: `zerotrust_sesion_20260609_130120` (2026-06-09). Commit `271b38d9`. Fuente de captura: `tests/00_PLANTILLA_KPI_v2.md` §2.

### 6.3.1 Cronología de la sesión oficial

**Caracterización pre-RCE (§2.2.a):** omitida por diseño — mismo vector HTB que el Escenario A (§6.2.1 / plantilla §1.2.a). El RCE sigue siendo explotable; la comparativa A↔B se mide en la fase post-RCE. Evidencia de SSTI en `tests/logs/zerotrust_sesion_20260609_130120/nginx.log` (~11:13 UTC).

`**T0_efectivo`:** `13:14:08 CEST`


| Hito post-RCE                                                   | Hora CEST    | Δ desde T0 | Resultado                                                           | ¿Bloqueado por control ZT? |
| --------------------------------------------------------------- | ------------ | ---------- | ------------------------------------------------------------------- | -------------------------- |
| **T0_efectivo** — shell post-RCE operativa en `webapp`          | **13:14:08** | **0**      | Reverse shell SSTI + `pty.spawn`                                    | n/a                        |
| Exfiltración creds — `env | grep DB`_ → `creds.txt`             | 13:14:16     | 8 s        | Sin variables DB en entorno; `creds.txt` vacío                      | Sí                         |
| Captura tráfico — `tcpdump -c 100 host backend`                 | 13:14:50     | 42 s       | Captura `lateral.pcap`                                              | n/a                        |
| Movimiento lateral — `curl :5000` y `https://backend/empleados` | 13:15:15     | 67 s       | `:5000` connection refused; HTTPS → **400** sin certificado cliente | Sí                         |
| Acceso DB — `psql -h db` / `nmap db:5432`                       | 13:16:18     | 130 s      | `db` no resuelve por DNS; `psql` falla; 0 hosts escaneados          | Sí                         |


El escaneo interno queda reflejado en `e1_scan.log`: `nginx:80` y `backend:443` visibles; `db` no resuelve; puerto `:5000` cerrado (conn-refused).

### 6.3.2 Métricas KPI — Escenario B


| Código | Valor                                                                                                                       | Evidencia                                                                                   |
| ------ | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| G1     | `(true, 22 s)` — 1.ª alerta Wazuh regla **100100** (nmap) a `11:14:30 UTC` = `13:14:30 CEST`; Δ vs `T0_efectivo` `13:14:08` | `tests/logs/zerotrust_sesion_20260609_130120/wazuh_alerts.json` (L1) + `session_chrono.txt` |
| G2     | **1 nodo**: webapp ☑ — backend ☐ — db ☐                                                                                     | `e1_scan.log` + `dump.txt` (`db` no resuelve; lateral sin datos)                            |
| G3     | `(true, 100 %)` — exfiltración, movimiento lateral y acceso a DB fallaron; sin JSON en claro en tránsito                    | `creds.txt` (vacío) + `lateral.json` (vacío) + `lateral_attempt.log` + `dump.txt`           |
| E1     | **1 / 3** — `nginx:80` y `backend:443` visibles; `db` no resuelve; `:5000` cerrado                                          | `e1_scan.log`                                                                               |
| E2     | **0 registros / 0 B** — sin credenciales en env ni JSON de empleados                                                        | `creds.txt` + `lateral.json`                                                                |
| E3     | **cifrado + rechazado** — TLS en pcap; `curl` HTTPS → 400 sin cert cliente; `:5000` connection refused                      | `lateral.pcap` (26 pkts, 8386 B) + `lateral_attempt.log` + `backend.log` (L17)              |


[FIG: captura `lateral_attempt.log` o `backend.log` mostrando HTTP 400 «No required SSL certificate was sent»]

### 6.3.3 Observaciones de la sesión

- **Alertas Wazuh:** además de **100100** (nmap), dispararon **100102** (tcpdump, `11:14:50 UTC`) y **100103** (psql, `11:16:47 UTC`). No hubo **100101** (`curl` efímero vs poll 2 s); **100104** (`grep` creds) no apareció.
- **Controles ZT verificados:** microsegmentación (`db` invisible desde `webapp`), Flask backend solo en `127.0.0.1` (`:5000` refused), mTLS en PEP (400 sin certificado de servicio), sin secretos en variables de entorno de `webapp`.
- **Correlación:** `backend.log` L17 registra `GET /empleados` → 400 a `11:15:32 UTC` (= `13:15:32 CEST`), coherente con `lateral_attempt.log`.
- **Canal post-RCE:** reverse shell SSTI + `pty.spawn`; `nc` no instalado en `webapp` (sustituido por `nmap` para probe 5432).
- **Reproducibilidad:** `./tests/scripts/logcapture_zerotrust.sh` sobre commit `271b38d9`.

---

#### Texto redactado [HUMANO]

Con Zero Trust podemos observar como cambian los resultados y como los ajustes realizados en la red para aplicar dicha metodología dan sus frutos.

Wazuh detecta la actividad post-explotación: la primera alerta llega a los 22 segundos desde el inicio de la ventana de medición, asociada al escaneo nmap desde webapp. La detección existe, aunque no es inmediata.

Como en el caso anterior, el atacante obtiene RCE en webapp y crea una brecha en la red, pero no consigue avanzar más allá de ese nodo: no alcanza el backend ni la base de datos de forma útil para el ataque.

Los controles de bloqueo impiden completar los hitos post-explotación: no hay credenciales en el entorno del contenedor, la petición a la API interna no devuelve datos y la consulta a PostgreSQL falla por completo.

El escaneo interno solo identifica nginx en el puerto 80 y el backend en el 443; la base de datos no resuelve por DNS y el puerto 5000 del backend aparece cerrado. [FIG: nmap-zerotrust]

No se exfiltra ningún dato: los logs recuperados (`creds.txt` y `lateral.json`) quedan vacíos, sin contraseñas ni registros de empleados.

El tráfico hacia el backend va cifrado con TLS y, sin certificado de servicio, nginx responde con error 400; tampoco puede leer peticiones en claro como en el escenario perimetral. [FIG: lateral_attempt.log — 400 sin certificado]

---

## 6.4 Comparativa A vs B

Sesiones oficiales: `perimetral_sesion_20260523_175204` (A) y `zerotrust_sesion_20260609_130120` (B). Cuadro consolidado en `tests/00_PLANTILLA_KPI_v2.md` §3.

### 6.4.1 Tabla comparativa final


| Indicador | Escenario A | Escenario B | Mejora observada |
| --------- | ----------- | ----------- | ---------------- |
| Detección (G1) | `(false, ∞)` | `(true, 22 s)` | Capacidad de detección inexistente → Wazuh regla 100100 (nmap) |
| Profundidad del ataque (G2) | 3 nodos | 1 nodo | −67 % alcance lateral (2 nodos menos) |
| Bloqueo de comandos desde reverse shell (G3) | `(false, 0 %)` | `(true, 100 %)` | Contención inexistente → comandos post-explotación bloqueados desde reverse shell |
| Superficie visible (E1) | 3/3 servicios | 1/3 | −67 % superficie visible (`db` no resuelve; `:5000` cerrado) |
| Volumen exfiltrado (E2) | ~766 B / 3 reg. + 1 cred. | 0 B / 0 reg. | Exfiltración anulada |
| Integridad del tráfico interno (E3) | Texto claro (HTTP) | Cifrado + rechazado | mTLS + PEP (400 sin certificado cliente) |


---

#### Texto redactado [HUMANO]

La tabla anterior condensa lo medido en la fase post-explotación, a partir de los mismos cuatro hitos en ambos escenarios (véase §6.1.3). 

Con estos seis indicadores respondemos, con datos reproducibles, en qué medida la arquitectura Zero Trust reduce el impacto frente al modelo perimetral en:

- Detección
- Profundidad del ataque
- Bloqueo de comandos desde reverse shell
- Superficie visible
- Volumen exfiltrado
- Integridad del tráfico interno

En el escenario perimetral el atacante recorre los tres nodos de la red sin que ningún control lo detenga. En cambio, en Zero Trust el compromiso queda acotado a webapp y Wazuh registra actividad. 

El desglose por dimensión y la atribución de cada mecanismo están en §6.4.2; los matices de interpretación, en §6.4.3.

---

### 6.4.2 Análisis cuantitativo de la mejora

---

#### Texto redactado [HUMANO]

En detección, el escenario perimetral no dispone de mecanismo activo: solo quedan logs pasivos de nginx y webapp, sin alertas. Zero Trust introduce Wazuh, que muestrea cada 2 segundos los procesos en webapp; la primera alerta llega asociada al escaneo nmap.

La profundidad del ataque pasa de tres nodos a uno: una reducción del 67 % en alcance lateral. La microsegmentación en tres zonas impide que webapp alcance `db_zone`, Flask escucha solo en `127.0.0.1` dentro del backend y el atacante no consigue operar con utilidad en backend ni en la base de datos, aunque mantenga la reverse shell en webapp.

El bloqueo de comandos desde reverse shell refleja el mismo contraste: en A ningún objetivo post-explotación falla al ejecutarse desde la shell. En B los tres quedan frustrados:

1. Los secretos de base de datos viven solo en backend.
2. El canal hacia la API exige certificado de servicio.
3. La segmentación corta el acceso directo a la base de datos.

La superficie visible interna se reduce de tres servicios accesibles a uno de tres: `db` no resuelve por DNS desde webapp y el puerto 5000 del backend aparece cerrado. El escaneo desde el nodo comprometido solo identifica nginx en el 80 y el backend en el 443, frente a la visibilidad total de la red interna en el escenario perimetral.

En exfiltración, el volumen fugado cae de unos 766 bytes (tres registros de empleados, la contraseña de la base de datos y el JSON de la API) a cero. Sin credenciales en el entorno de webapp y sin respuesta útil del backend, los logs que evidencian el volumen de datos exfiltrados quedan vacíos en la sesión Zero Trust.

En integridad del tráfico, el contraste es cualitativo pero contundente:

1. En el escenario perimetral, el pcap muestra HTTP y JSON en claro.
2. En Zero Trust, el tráfico hacia backend va cifrado con TLS y, sin certificado cliente, nginx devuelve error 400.

El atacante no puede replicar la lectura pasiva del intercambio que sí logró en el escenario perimetral.

En conjunto, estos resultados cuantifican un patrón que la literatura revisada en §2.7 apenas aborda con métricas comparables.

---

### 6.4.3 Matices de la interpretación

---

#### Texto redactado [HUMANO]

En profundidad del ataque, bloqueo de comandos desde reverse shell, superficie visible, exfiltración e integridad del tráfico no observamos ningún empeoramiento respecto al perimetral: Zero Trust reduce o anula el impacto post-explotación en todas ellas. El matiz está solo en detección: en A no hay SIEM por diseño, así que comparar la latencia de la primera alerta en B no es un duelo equitativo, lo que aporta la tabla es que la capacidad de detección activa existe únicamente en Zero Trust.