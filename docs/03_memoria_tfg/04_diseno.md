# Capítulo 4 — Diseño de la Solución



> **Estado:** ESQUELETO — redactar en semana 3 (09/06). Fuentes: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md`, diarios de laboratorio `docs\01_investigacion\20260603_Prototipo_ZeroTrust.md`.

> Criterio del tutor: el PORQUÉ de las decisiones de arquitectura es igual o más importante que el montaje técnico.

> Configuraciones extensas → Anexos.

> Objetivo de extensión: 10-14 páginas.



---



## 4.1 Visión general del sistema comparativo

[TODO] Diagrama de alto nivel de los dos escenarios. Describir que ambos sirven la misma aplicación web (Flask + PostgreSQL + Nginx), funcionalmente idénticos, con diferente modelo de red.

[FIG: diagrama comparativo Escenario A vs Escenario B — redes Docker, servicios, flujos de tráfico]



---



#### Texto redactado [IA]



Hemos diseñado dos implementaciones docker que sirven la misma aplicación web: portal Flask con panel de administración, API interna de empleados y base de datos PostgreSQL detrás de Nginx. La aplicación es funcionalmente idéntica en ambos escenarios; lo que cambia es el modelo de red y los controles que aplicamos una vez el atacante ya tiene ejecución remota en webapp.

El Escenario A reproduce el modelo perimetral clásico: protegemos el borde y asumimos confianza dentro de la red interna. 

El Escenario B aplica Zero Trust mediante microsegmentación en tres zonas, identidad de servicio con mTLS entre webapp y backend, y detección activa con Wazuh. Así podemos medir de forma comparable qué ocurre tras el mismo punto de entrada (RCE en webapp) en cada arquitectura.



---



## 4.2 Escenario A — Arquitectura Perimetral



### 4.2.1 Topología de red



[TODO] Dos redes Docker (`net_dmz` + `net_interna`). Nginx como único punto de entrada externo (`:80`). `webapp` en ambas redes (pivot). `backend` y `db` solo en `net_interna`. Sin SIEM ni IDS.



[FIG: diagrama topología Escenario A — DMZ + red interna, puertos, flujos]



---



#### Texto redactado [IA]

El Escenario A se organiza en dos redes docker: `net_dmz` y `net_interna`. Nginx es el único servicio con puerto expuesto al host (`:80`) y actúa como punto de entrada desde internet.

La aplicación web vulnerable (`webapp`) está en `net_dmz` y, además, en `net_interna`: actúa como pivot porque puede comunicarse con ambos segmentos sin control adicional entre ellos. En `net_interna` residen el backend (API Flask) y PostgreSQL con los datos de prueba.

---



### 4.2.2 Decisiones de diseño



[TODO] DMZ + red interna (práctica estándar, no red única extrema). Segmentación agotada en el borde. Ausencia intencional de detección activa. Credenciales compartidas y HTTP interno a propósito.



---



#### Texto redactado [IA]

Elegimos DMZ más red interna porque reproduce una práctica habitual: firewall exterior, servidores web en zona expuesta y datos en una red interna "protegida". El argumento del TFG no es que falte toda segmentación, sino que esta se agota en el borde: dentro del perímetro no hay verificación de identidad entre servicios ni monitorización del movimiento lateral.

Este escenario no pretende ser seguro; es la referencia contra la que medimos la mejora. A propósito dejamos `DB_PASSWORD` en el entorno de webapp y el tráfico hacia el backend en HTTP plano por el puerto 5000, de modo que los cuatro hitos post-explotación del protocolo de pruebas sean alcanzables. No desplegamos SIEM, WAF ni IDS: la protección se limita al perímetro exterior.



---



### 4.2.3 Superficie inicial de comparación



[TODO] Los 4 hitos post-RCE que definen el denominador de comparación: (1) exfiltración de credenciales, (2) escaneo lateral, (3) acceso a backend/empleados, (4) volcado de base de datos. Ver `tests/00_PLANTILLA_KPI_v2.md §1.2.b`.



---



#### Texto redactado [IA]

Una vez obtenida la reverse shell en webapp, el atacante ejecuta siempre la misma secuencia de cuatro hitos, denominador común entre escenarios A y B: 
1. Exfiltración de credenciales del entorno del contenedor
2. Escaneo de la red interna
3. Acceso al endpoint `/empleados` del backend
4. Volcado de la tabla de empleados en PostgreSQL.

En el Escenario A todos estos pasos pueden completarse: 
1. `env | grep DB_` expone la contraseña
2. nmap revela backend y db
3. curl a `backend:5000` devuelve JSON en claro
4. psql alcanza la base de datos.


---





## 4.3 Escenario B — Arquitectura Zero Trust



### 4.3.1 Principios aplicados



[TODO] Cómo se traduce cada principio Zero Trust al diseño Docker concreto:

- "Nunca confíes, siempre verifica" → credenciales no compartidas, variables de entorno por servicio, sin contraseñas en variables de entorno globales.

- "Mínimo privilegio" → 3 redes Docker segregadas; cada contenedor solo accede a la red que necesita.

- "Verificación explícita" → mTLS entre webapp ↔ backend.

- "Asumir brecha" → Wazuh agent en `webapp` con reglas para los 4 hitos post-RCE.



---



#### Texto redactado [IA]



El Escenario B aplica controles sobre cada uno de los hitos definidos en §4.2.3. Traducimos los tres principios operativos de la investigación a medidas implantadas.

- Con verificación explícita exigimos que cada flujo este-oeste se autentique antes de permitirse: el canal crítico webapp → backend usa mTLS en Nginx, de modo que el hecho de pertenecer a una red ya no equivale a confianza automática.

- Con mínimo privilegio segmentamos la estructura en tres zonas y solo habilitamos los puertos estrictamente necesarios entre zonas contiguas. Las credenciales de la base de datos viven solo en backend; webapp no recibe `DB_PASSWORD` en su entorno, corrigiendo el punto débil del escenario perimetral.

- Con asumir brecha diseñamos como si webapp ya estuviera comprometida: la segmentación impide el salto directo a db_zone, mTLS bloquea peticiones sin certificado de servicio y Wazuh observa los comandos que el atacante lanza desde la shell post-RCE para generar alertas, aunque los controles de red ya hayan frustrado parte del ataque.



---





### 4.3.2 Topología de red segmentada



[TODO] 3 redes Docker: `web_zone` (nginx + webapp), `backend_zone` (webapp + backend), `db_zone` (backend + db). Ningún contenedor tiene acceso directo a todos los demás. La `webapp` no puede conectar directamente a `db`.



[FIG: diagrama topología Escenario B — 3 zonas, políticas de conectividad, flujos permitidos/bloqueados]



---



#### Texto redactado [IA]

La topología Zero Trust divide los contenedores en 
`web_zone` (nginx y webapp), `backend_zone` (webapp como 
cliente y backend como servidor) y `db_zone` (backend y db). 

Los flujos permitidos entre zonas son los siguientes:
- entrada externa únicamente a nginx (8080→80 en el host)
- nginx → webapp en el puerto 5000; webapp → backend por HTTPS en el 443, con terminación mTLS en Nginx del contenedor backend
- backend → PostgreSQL en el 5432. 

No existe ruta webapp → db porque ningún servicio tiene interfaz en `web_zone` y `db_zone` a la vez.

Cualquier comunicación no enumerada se considera denegada por defecto.
---





### 4.3.3 mTLS entre webapp y backend



[TODO] Justificación: el tráfico `webapp → backend` es HTTP plano en el Escenario A. En el Escenario B se protege con mTLS: certificados autofirmados generados con OpenSSL, Nginx como proxy TLS en el contenedor `backend`. Solo `webapp` con el certificado cliente correcto puede conectar.



[FIG: diagrama mTLS — flujo de autenticación mutua, certs, CA]



---



#### Texto redactado [IA]



Como en el Escenario A el tráfico de webapp a backend va en HTTP plano por el puerto 5000, en B lo ciframos y autenticamos con mTLS. Una CA local generada con OpenSSL firma certificados de servidor (backend, serverAuth) y de cliente (webapp, clientAuth), montados en runtime y no incrustados en las imágenes.

Nginx en el contenedor backend actúa como punto de aplicación de políticas: `ssl_verify_client on` exige certificado de cliente válido en el handshake. Sin él, la conexión se rechaza.

---

### 4.3.4 Observabilidad activa — Wazuh



[TODO] Wazuh manager + agente como contenedores Docker. `process-webapp` (2 s) + reglas 100100–100104 para los 4 hitos post-RCE. Detección complementa bloqueo de red.



---



#### Texto redactado [IA]



Para la detección activa desplegamos Wazuh en 2 contenedores, manager y agente, como contenedores docker en el laboratorio. El agente monta el socket de Docker y observa los procesos que se ejecutan dentro de webapp.

Definimos reglas locales alineadas con los cuatro hitos: escaneo nmap, curl hacia backend, tcpdump, psql y grep de patrones de credenciales. La microsegmentación y el mTLS bloquean el impacto; Wazuh registra el intento y permite medir el tiempo hasta la primera alerta. 
---





### 4.3.5 Justificación de tecnología: Wazuh vs Suricata



[TODO] El diseño inicial del TFG (borrador pre-propuesta) contemplaba Suricata como sonda de red. Se eligió Wazuh por los siguientes motivos:

- Wazuh es host-based: detecta comandos y accesos dentro del contenedor comprometido, que es exactamente donde ocurren los 4 hitos post-RCE.

- Suricata es network-based: detecta patrones de tráfico, pero no comandos ejecutados dentro del contenedor.

- Para el modelo de amenazas definido (atacante con RCE en `webapp`), la detección host-based es más relevante que la detección network-based.

- Suricata queda como trabajo futuro para añadir una capa de detección network-level complementaria.



[CITAR: Wazuh documentation — host-based detection capabilities]



---



#### Texto redactado [IA]



El borrador inicial del TFG contemplaba Suricata como sonda de red. Lo descartamos porque nuestro modelo de amenazas fija la ejecución de código remota en webapp y los hitos comparativos ocurren como comandos dentro del contenedor (nmap, curl, psql, grep), no solo como patrones de tráfico observables en la red.

Wazuh aporta detección host-based sobre esos procesos; Suricata es network-based y no sustituye la visibilidad del cmdline en el namespace del contenedor comprometido. Para este alcance del TFG la elección es más relevante que combinar ambas capas. Dejamos Suricata como línea futura de detección a nivel de red, actuaría junto a Wazuh, complementándolo y no sustituyéndolo.



---





## 4.4 Tecnología utilizada



| Componente    | Tecnología            | Versión       | Justificación                                        |
|---------------|-----------------------|---------------|------------------------------------------------------|
| Infraestructura | Docker Compose      | v2            | Despliegue reproducible con un solo comando           |
| Aplicación web | Flask (Python)       | 3.x           | Stack ligero, SSTI Jinja2 como vector de ataque       |
| Base de datos  | PostgreSQL           | 15            | BBDD relacional estándar                             |
| Proxy web      | Nginx                | 1.25          | Reverse proxy, único punto de entrada externo         |
| mTLS           | OpenSSL + Nginx       | —            | Certificados autofirmados, sin dependencia de PKI     |
| SIEM/IDS       | Wazuh                | 4.x           | Host-based, agent Docker, reglas custom en YAML      |



### 4.4.1 Alternativas evaluadas y criterio de selección



> **Estado:** ESQUELETO — apartado **Muy recomendable** ("Identificación y análisis de soluciones posibles", referencia línea 224). Transmite que se ha trabajado como ingeniero: se evaluaron alternativas y se eligió la solución justificada. No reabrir las decisiones; consolidar las ya tomadas remitiendo a los ADR.

[TODO] Presentar de forma consolidada las alternativas evaluadas, sus pros/contras y el criterio que llevó a la opción elegida. No duplicar el detalle: remitir a las entradas de `admin/DECISIONS_LOG.md`.

- **Detección: Wazuh (host-based) vs Suricata (network-based).** Elegido Wazuh por alinearse con el vector del modelo de amenazas (comandos dentro del contenedor tras RCE). Detalle en §4.3.5 y ADR 2026-05-24 ("Reducción de alcance técnico del Escenario B"). Suricata → trabajo futuro (§7.3).
- **PEP mTLS: contenedor único `backend` (Nginx+Flask) vs sidecar.** Elegida la opción de contenedor único por fidelidad al prototipo documentado. ADR 2026-06-03 ("Arquitectura mTLS: Opción B").
- **Despliegue Wazuh: agente en contenedor vs agente en host.** Elegido agente en contenedor por reproducibilidad y por las limitaciones de Docker Desktop + WSL2. ADR 2026-06-04.
- **Plan de contingencia Wazuh → Falco.** Criterio de fallback definido y finalmente descartado (Wazuh operativo). ADR 2026-05-24 ("Criterio de fallback Wazuh → Falco").

[TODO] Cerrar con una frase: el conjunto de decisiones responde a las restricciones del laboratorio (Docker Compose local, sprint acotado) y al modelo de amenazas, no a una elección arbitraria.



---



## 4.5 Limitaciones del diseño



[TODO] Honestas, no como excusa. Limitaciones que el tribunal puede preguntar:

- mTLS solo en un canal (webapp ↔ backend), no en todo el stack por coste temporal.

- Wazuh sin dashboard custom ni integraciones externas.

- Sin automatización de respuesta (SOAR): las alertas son pasivas, no bloquean automáticamente.

- Entorno local (no cloud): los resultados son representativos pero no directamente extrapolables a despliegues Kubernetes en producción.



---



#### Texto redactado [IA]

Reconocemos varias limitaciones de este diseño en el entorno de laboratorio.

El mTLS solo cubre el canal webapp → backend; nginx → webapp y backend → db siguen sin cifrado mutuo. Los certificados son autofirmados, sin PKI corporativa. Además, mTLS verifica la identidad del servicio, pero no define qué operaciones puede ejecutar cada certificado una vez autenticado.

Wazuh se despliega sin Indexer ni dashboard: las alertas se vuelcan a `alerts.json` y no disparan respuesta automática (no hay SOAR). El agente usa muestreo cada 2 s mediante `process-webapp`, no trazado syscall en tiempo real.

El entorno es Docker Compose local en Windows/WSL2, no un clúster Kubernetes productivo: los resultados son representativos del contraste perimetral vs Zero Trust en contenedores, pero no se extrapolan directamente a despliegues cloud-native a escala.



---


