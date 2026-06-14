# Capítulo 4 — Diseño de la Solución



> **Estado:** BORRADOR — §4.1–§4.5 redactados [HUMANO]. Pendiente: figuras `[FIG:]` y cita de Wazuh (§4.3.5). Fuentes: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md`, `docs/01_investigacion/20260603_Prototipo_ZeroTrust.md`.

> Criterio del tutor: el PORQUÉ de las decisiones de arquitectura es igual o más importante que el montaje técnico.

> Configuraciones extensas → Anexos.

> Objetivo de extensión: 10-14 páginas.



---



## 4.1 Visión general del sistema comparativo

[DONE] Diagrama de alto nivel de los dos escenarios. Describir que ambos sirven la misma aplicación web (Flask + PostgreSQL + Nginx), funcionalmente idénticos, con diferente modelo de red.

[FIG: diagrama comparativo Escenario A vs Escenario B — redes Docker, servicios, flujos de tráfico]



---



[REV-ESTILO: §4.1 — (1) "docker" en minúscula aquí y en §4.2.1; debería ser "Docker" (nombre propio). (2) La lista incrustada en mitad de la frase ("Portal Flask / API / Base de datos…") rompe la oración; valora pasarla a prosa o a una lista limpia tras dos puntos. Sin reescribir; decide el autor. Prioridad 3.]

#### Texto redactado [HUMANO]



Hemos diseñado dos implementaciones Docker que sirven la misma aplicación web compuesta por:
- Portal Flask con panel de administración
- API interna de empleados
- Base de datos PostgreSQL detrás de Nginx. 
La aplicación es funcionalmente idéntica en ambos escenarios, lo que cambia es el modelo de red y los controles que aplicamos una vez el atacante ya tiene ejecución remota en webapp.

El Escenario A reproduce el modelo perimetral clásico: protegemos el borde y asumimos confianza dentro de la red interna. 

El Escenario B aplica Zero Trust mediante microsegmentación de la red en tres zonas, identidad de servicio con mTLS entre webapp y backend, y detección activa con Wazuh. 

Así podemos medir de forma comparable qué ocurre tras el mismo punto de entrada en cada arquitectura.



---



## 4.2 Escenario A — Arquitectura Perimetral



### 4.2.1 Topología de red



[DONE] Dos redes Docker (`net_dmz` + `net_interna`). Nginx como único punto de entrada externo (`:80`). `webapp` en ambas redes (pivot). `backend` y `db` solo en `net_interna`. Sin SIEM ni IDS.



[FIG: diagrama topología Escenario A — DMZ + red interna, puertos, flujos]



---



#### Texto redactado [HUMANO]

El Escenario A se organiza en dos redes docker: `net_dmz` y `net_interna`. Nginx es el único servicio con puerto expuesto al host (`:80`) y actúa como punto de entrada desde internet.

La aplicación web vulnerable (`webapp`) está en `net_dmz` y, además, en `net_interna`: actúa como pivot porque puede comunicarse con ambos segmentos sin control adicional entre ellos. 

En `net_interna` residen el backend (API Flask) y PostgreSQL con los datos de prueba.

---



### 4.2.2 Decisiones de diseño



[DONE] DMZ + red interna (práctica estándar, no red única extrema). Segmentación agotada en el borde. Ausencia intencional de detección activa. Credenciales compartidas y HTTP interno a propósito.



---



#### Texto redactado [HUMANO]

Elegimos dos redes (`net_dmz` y `net_interna`) porque reproducen una práctica habitual: cortafuegos exterior, servidores web en una zona expuesta y datos en una red interna "protegida".

La segmentación existe, pero se concentra en el perímetro: dentro de la red interna no hay verificación de identidad entre servicios ni monitorización del movimiento lateral. El argumento del trabajo no es que falte toda segmentación, sino que la confianza es implícita una vez que el tráfico ha cruzado el borde.

Este escenario no pretende ser seguro; es la referencia contra la que medimos la mejora. A propósito dejamos `DB_PASSWORD` en el entorno de `webapp` y el tráfico hacia el backend en HTTP plano por el puerto 5000, de modo que los cuatro hitos post-explotación del protocolo de pruebas sean alcanzables. Tampoco desplegamos mecanismos de detección o respuesta —ni sistema de gestión de eventos de seguridad (SIEM), ni cortafuegos de aplicación web (WAF), ni sistema de detección de intrusiones (IDS)—: la protección se limita al perímetro exterior.


---



### 4.2.3 Superficie inicial de comparación



[DONE] Los 4 hitos post-RCE que definen el denominador de comparación: (1) exfiltración de credenciales, (2) escaneo lateral, (3) acceso a backend/empleados, (4) volcado de base de datos. Ver `tests/00_PLANTILLA_KPI_v2.md §1.2.b`.



---



#### Texto redactado [HUMANO]

Una vez obtenida la reverse shell en `webapp`, el atacante ejecuta siempre la misma secuencia de cuatro hitos post-explotación, definida en §3.2.4: exfiltración de credenciales del entorno del contenedor, escaneo de la red interna, acceso al endpoint `/empleados` del backend y volcado de la tabla de empleados en PostgreSQL.

Esta secuencia es el denominador común entre ambas arquitecturas. En el Escenario A los cuatro hitos son alcanzables por diseño, porque ningún control interno los impide; sirven así de baseline frente al que se mide el Escenario B. La ejecución concreta de cada hito y los valores observados se documentan en el capítulo de pruebas (§6.2).

---





## 4.3 Escenario B — Arquitectura Zero Trust



### 4.3.1 Principios aplicados



[DONE] Cómo se traduce cada principio Zero Trust al diseño Docker concreto:

- "Nunca confíes, siempre verifica" → credenciales no compartidas, variables de entorno por servicio, sin contraseñas en variables de entorno globales.

- "Mínimo privilegio" → 3 redes Docker segregadas; cada contenedor solo accede a la red que necesita.

- "Verificación explícita" → mTLS entre webapp ↔ backend.

- "Asumir brecha" → Wazuh agent en `webapp` con reglas para los 4 hitos post-RCE.



---



#### Texto redactado [HUMANO]

El Escenario B parte del principio rector de Zero Trust: "nunca confíes, siempre verifica", y lo concreta en tres principios operativos, cada uno traducido a una medida sobre los hitos definidos en §4.2.3:

- **Verificación explícita.** Exigimos que cada flujo este-oeste se autentique antes de permitirse: el canal crítico `webapp → backend` usa autenticación mutua con certificados (mTLS), de modo que pertenecer a una red ya no equivale a confianza automática.
- **Mínimo privilegio.** Segmentamos la estructura en tres zonas y solo habilitamos los puertos estrictamente necesarios entre zonas contiguas. Las credenciales de la base de datos residen solo en `backend` y `webapp` no recibe `DB_PASSWORD` en su entorno, lo que corrige el punto débil del escenario perimetral.
- **Asumir brecha.** Diseñamos como si `webapp` ya estuviera comprometida: la segmentación impide el salto directo a `db_zone`, el mTLS rechaza las peticiones sin certificado de servicio y Wazuh observa los comandos que el atacante lanza desde la shell post-RCE, aunque los controles de red ya hayan frustrado parte del ataque.

Estos tres principios son la respuesta de diseño al Requisito-F 3 (§3.3.1): que el Escenario B bloquee o, como mínimo, detecte los cuatro hitos post-RCE alcanzables en el perimetral.


---





### 4.3.2 Topología de red segmentada



[DONE] 3 redes Docker: `web_zone` (nginx + webapp), `backend_zone` (webapp + backend), `db_zone` (backend + db). Ningún contenedor tiene acceso directo a todos los demás. La `webapp` no puede conectar directamente a `db`.



[FIG: diagrama topología Escenario B — 3 zonas, políticas de conectividad, flujos permitidos/bloqueados]



---



#### Texto redactado [HUMANO]

La topología Zero Trust divide los contenedores en 
`web_zone` (nginx y webapp), `backend_zone` (webapp como 
cliente y backend como servidor) y `db_zone` (backend y db). 

Los flujos permitidos entre zonas son los siguientes:
- entrada externa únicamente a nginx (8080→80 en el host)
- nginx → webapp en el puerto 5000
- webapp → backend por HTTPS en el 443, con terminación mTLS en Nginx del contenedor backend
- backend → PostgreSQL en el 5432. 

No existe ruta webapp → db porque ningún servicio tiene interfaz en `web_zone` y `db_zone` a la vez.

Cualquier comunicación no enumerada se considera denegada por defecto.
---





### 4.3.3 mTLS entre webapp y backend



[DONE] Justificación: el tráfico `webapp → backend` es HTTP plano en el Escenario A. En el Escenario B se protege con mTLS: certificados autofirmados generados con OpenSSL, Nginx como proxy TLS en el contenedor `backend`. Solo `webapp` con el certificado cliente correcto puede conectar.



[FIG: diagrama mTLS — flujo de autenticación mutua, certs, CA]



---



#### Texto redactado [HUMANO]

En el Escenario A el tráfico de `webapp` a `backend` viaja en HTTP plano por el puerto 5000. En el Escenario B lo ciframos y autenticamos con mTLS, una variante de TLS en la que no solo el servidor presenta certificado, sino que también el cliente debe acreditar su identidad. Una autoridad de certificación (CA) local, generada con OpenSSL, firma un certificado de servidor para `backend` y un certificado de cliente para `webapp`.

Nginx, desplegado en el contenedor `backend`, actúa como punto de aplicación de políticas (PEP): solo admite la conexión si el cliente presenta un certificado válido firmado por esa CA; en caso contrario, la rechaza. De este modo, el simple hecho de alcanzar la red del backend ya no basta para hablar con la API. Los detalles de configuración de Nginx y del montaje de certificados se documentan en §5.3.3.

---

### 4.3.4 Observabilidad activa — Wazuh



[DONE] Wazuh manager + agente como contenedores Docker. `process-webapp` (2 s) + reglas 100100–100104 para los 4 hitos post-RCE. Detección complementa bloqueo de red.



---



[REV-ESTILO: §4.3.4 — (1) "en 2 contenedores" → "en dos contenedores" (cifras bajas en letra) y evita la redundancia "en 2 contenedores… como contenedores docker". (2) "docker" → "Docker". (3) Comma splice: "…bloquean el impacto, luego Wazuh registra…"; valora punto y seguido o "de modo que Wazuh registra…". Sin reescribir; decide el autor. Prioridad 2.]

#### Texto redactado [HUMANO]



Para la detección activa desplegamos Wazuh en dos contenedores, manager y agente. El agente monta el socket de Docker y observa los procesos que se ejecutan dentro de webapp.

Definimos reglas locales alineadas con los cuatro hitos: escaneo nmap, curl hacia backend, tcpdump, psql y grep de patrones de credenciales. La microsegmentación y el mTLS bloquean el impacto. Luego Wazuh registra el intento y permite medir tiempos. 
---





### 4.3.5 Justificación de tecnología: Wazuh vs Suricata



[DONE] El diseño inicial del TFG (borrador pre-propuesta) contemplaba Suricata como sonda de red. Se eligió Wazuh por los siguientes motivos:

- Wazuh es host-based: detecta comandos y accesos dentro del contenedor comprometido, que es exactamente donde ocurren los 4 hitos post-RCE.

- Suricata es network-based: detecta patrones de tráfico, pero no comandos ejecutados dentro del contenedor.

- Para el modelo de amenazas definido (atacante con RCE en `webapp`), la detección host-based es más relevante que la detección network-based.

- Suricata queda como trabajo futuro para añadir una capa de detección network-level complementaria.



[CITAR: Wazuh documentation — host-based detection capabilities]



---



#### Texto redactado [HUMANO]



El borrador inicial del TFG contemplaba Suricata como sonda de red. Lo descartamos porque nuestro modelo de amenazas fija la ejecución de código remota en webapp y los hitos comparativos ocurren como comandos dentro del contenedor (nmap, curl, psql, grep), no solo como patrones de tráfico observables en la red.

Wazuh aporta detección host-based sobre esos procesos mientras que Suricata es network-based y no sustituye la visibilidad del cmdline en el namespace del contenedor comprometido. Para este alcance del TFG la elección es más relevante que combinar ambas capas. 

Dejamos Suricata como línea futura de detección a nivel de red, actuaría junto a Wazuh, complementándolo y no sustituyéndolo.



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



#### Texto redactado [HUMANO]

A lo largo del diseño del Escenario B evaluamos varias alternativas antes de fijar cada decisión. Las resumimos aquí para dejar constancia del criterio de ingeniería seguido; el detalle de cada deliberación queda registrado en `admin/DECISIONS_LOG.md`.

- **Detección: Wazuh (basado en host) frente a Suricata (basado en red).** Elegimos Wazuh porque se alinea con el vector del modelo de amenazas —comandos ejecutados dentro del contenedor tras el RCE—, como se argumenta en §4.3.5. Suricata queda como línea de trabajo futuro (§7).
- **Aplicación de mTLS: contenedor único `backend` (Nginx + Flask) frente a sidecar.** Optamos por el contenedor único por fidelidad al prototipo documentado en la investigación, evitando introducir un patrón ausente en ella.
- **Despliegue de Wazuh: agente en contenedor frente a agente en el host.** Elegimos el agente en contenedor por reproducibilidad y por las limitaciones de visibilidad de procesos de Docker Desktop sobre WSL2.
- **Plan de contingencia Wazuh → Falco.** Definimos un criterio de sustitución por si Wazuh no resultaba operativo a tiempo; finalmente lo descartamos al quedar Wazuh funcional.

En conjunto, cada elección responde a las restricciones del laboratorio —Docker Compose local y un sprint de desarrollo acotado— y al modelo de amenazas definido en §3.2, no a una preferencia arbitraria.



---



## 4.5 Limitaciones del diseño



[DONE] Honestas, no como excusa. Limitaciones que el tribunal puede preguntar:

- mTLS solo en un canal (webapp ↔ backend), no en todo el stack por coste temporal.

- Wazuh sin dashboard custom ni integraciones externas.

- Sin automatización de respuesta (SOAR): las alertas son pasivas, no bloquean automáticamente.

- Entorno local (no cloud): los resultados son representativos pero no directamente extrapolables a despliegues Kubernetes en producción.



---



#### Texto redactado [HUMANO]

Reconocemos varias limitaciones de este diseño en el entorno de laboratorio, entre ellas:

1. El mTLS solo cubre el canal webapp → backend mientras que los flujos nginx → webapp y backend → db siguen sin cifrado mutuo.
2. Los certificados son autofirmados. Además, mTLS verifica la identidad del servicio, pero no define qué operaciones puede ejecutar cada certificado una vez autenticado.
3. Wazuh se despliega sin Indexer ni dashboard: las alertas se vuelcan a un json manualmente y no disparan respuesta automática (no hay SOAR) y el agente usa muestreo cada 2 s mediante `process-webapp`, no trazado syscall en tiempo real.
4. El entorno de trabajo es Docker local en Windows/WSL2, no un clúster Kubernetes productivo: los resultados son representativos del contraste perimetral vs Zero Trust en contenedores, pero no se extrapolan directamente a despliegues cloud-native a escala.

---


