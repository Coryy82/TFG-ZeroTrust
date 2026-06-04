# Registro de Decisiones de Arquitectura (ADR)

**2026-04-06 | Adopción de Modelo Kanban (Sprints de 7 días)**
- **Decisión:** Abandonar el roadmap de fechas fijas exactas en favor de un tablero TODO/DOING/DONE gestionado semanalmente.
- **Motivo:** El retraso inicial demostró que las fechas fijas generan frustración y deuda técnica.
- **Impacto:** El `ROADMAP.md` guiará los meses, pero el trabajo real se rige estrictamente por lo que haya en la columna TODO del `STATE.md` esa semana.

**2026-05-09 | Vector de entrada del Escenario A: SSTI Jinja2 tras login con credenciales filtradas**
- **Decisión:** Sustituir el endpoint público `/diagnostico` con `os.popen` por una cadena de ataque encadenada estilo HTB Academy (recon → information disclosure → login con credenciales filtradas → SSTI en panel autenticado → RCE → post-explotación lateral).
- **Alternativas descartadas:**
  - WordPress vulnerable (rompe el stack Python+PostgreSQL y la arquitectura de 3 capas).
  - File upload tipo CVE-2015-6967 / Nibbleblog (requiere contenedor PHP nuevo).
  - Webshell PHP (cambia el stack completo).
  - SQLi en login (no produce RCE en `webapp`, no encaja como vector único).
- **Motivo:** SSTI Jinja2 mantiene el stack Flask intacto (cero dependencias nuevas), introduce CWE-class reconocible (CWE-1336/CWE-94 con payload canónico de OWASP), multiplica los CWE materializables en la cadena (CWE-200, CWE-204, CWE-798 además del CWE-78 ya presente) y convierte un *one-shot* en una cadena de 4 pasos previos al RCE — cada paso es un control distinto que Zero Trust podrá contraponer en el Escenario B.
- **Impacto:** Solo afecta a `infra/perimetral/webapp/`. `nginx`, `backend`, `db`, `docker-compose.yaml` y la topología de red se mantienen. La narrativa Zero Trust se refuerza al ampliar la superficie de comparación.
- **Trazabilidad completa:** [docs/04_diario_laboratorio/20260509a_Sesion_Refactor_EscenarioA_HTB.md](../docs/04_diario_laboratorio/20260509a_Sesion_Refactor_EscenarioA_HTB.md).

**2026-05-09 | Convención de organización y nomenclatura de `docs/`**
- **Decisión:** Establecer una convención única de carpetas y nombres de fichero para todo el material textual del TFG.
- **Estructura por carpeta:**
  - `docs/01_investigacion/` → material **atemporal de referencia** (apuntes técnicos y especificaciones de diseño/prototipos).
  - `docs/02_reuniones_tutor/` → directrices y bitácora de tutoría.
  - `docs/03_memoria_tfg/` → borrador final de la memoria.
  - `docs/04_diario_laboratorio/` → material **cronológico de proceso** (diarios rápidos por día y sesiones detalladas con narrativa de decisión).
- **Patrones de nombre:**
  - Apunte técnico atemporal → `01_investigacion/YYYYMMDD_Apuntes_Tema.md`
  - Especificación / prototipo de diseño → `01_investigacion/YYYYMMDD_Prototipo_X.md`
  - Sesión de trabajo (cronológica, narrativa, inmutable) → `04_diario_laboratorio/YYYYMMDD[a-z]_Sesion_Tipo_Tema.md`
  - Diario rápido por días → `04_diario_laboratorio/diario_Tema.md`
- **Reglas de nombrado:**
  - Prefijo `YYYYMMDD` obligatorio en apuntes, prototipos y sesiones para ordenación alfabética = cronológica.
  - Sufijo letra (`a`, `b`, `c`...) cuando varias entradas coinciden el mismo día, en orden de creación.
  - ASCII puro: sin ñ, acentos ni espacios. Underscores como separadores. Garantiza portabilidad de URLs en enlaces markdown.
- **Filosofía aplicada:** los documentos en `04_diario_laboratorio/` son **fotografías inmutables**. Cada sesión documenta el estado del proyecto en ese momento concreto; nunca se reescribe el pasado para reflejar el presente. Cualquier evolución se registra en una sesión nueva. Esto preserva la trazabilidad cronológica completa, material primario para los capítulos "Diseño de la Solución" y "Análisis de problemas" del TFG.
- **Alternativas descartadas:**
  - Mezclar apuntes y sesiones en `01_investigacion/` (estado anterior — confunde aprendizaje atemporal con proceso cronológico).
  - Renumerar carpetas creando un `02_diseño/` separado (coste alto, beneficio bajo dado el volumen actual).
  - Subdivisión interna `04_diario_laboratorio/sesiones_detalladas/` y `entradas_rapidas/` (paths más profundos, sobrediseñado).
- **Impacto:** afecta a la organización de `docs/` y a las referencias en `admin/STATE.md` y `admin/DECISIONS_LOG.md`. Las carpetas `02_reuniones_tutor/` y `03_memoria_tfg/` no cambian.

**2026-05-10 | Esquema de doble dimensión para G1 (Tiempo de Detección) y G3 (Tasa de Bloqueo)**
- **Decisión:** Medir G1 y G3 como una tupla `(mecanismo_existe: bool, valor: número o convención)` en lugar de un único número. En el Escenario A perimetral los valores resultan `(false, ∞)` para G1 y `(false, 0%)` para G3, por construcción del modelo. En el Escenario B Zero Trust se espera `(true, X)` para ambas.
- **Alternativas descartadas:**
  - **Proxy pasivo en perimetral** (definir T_detección como "tiempo hasta que el evento queda en logs nativos de nginx/Flask"). Da un G1 finito pero introduce asimetría conceptual: en perimetral mide trazabilidad pasiva, en ZT mide alertado activo. No son comparables sin un párrafo dedicado a justificar la diferencia.
  - **Documentar ∞/0% sin más contexto.** Funciona pero es frágil ante la pregunta "¿por qué no implementaste un mínimo de detección en el A?" — no aporta marco defensivo.
- **Motivo:** El Escenario A no implementa SIEM, IDS, WAF activo ni respuesta automatizada por diseño (es lo que el modelo Zero Trust del Escenario B viene a corregir). Reportar G1 y G3 como celdas vacías leería como omisión metodológica; reportarlas como `(false, ∞)` y `(false, 0%)` las convierte en **ausencia documentada**: la falta de mecanismo es en sí misma evidencia cuantitativa de la deficiencia estructural del modelo perimetral. La técnica está alineada con NIST CSF, donde `MTTD = ∞ por diseño` es notación habitual cuando la organización carece de la capacidad evaluada.
- **Impacto:** Las plantillas de captura (`tests/00_PLANTILLA_KPI.md` §1.1, §2.1, §3) reflejan el esquema con casillas `mecanismo_existe ☐ Sí ☐ No`. La memoria deberá incluir un párrafo explicativo del esquema (redacción sugerida en [docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md §5.4](../docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md)). Las restantes 4 métricas (G2, E1, E2, E3) no se ven afectadas.
- **Trazabilidad completa:** [docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md §5](../docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md).

**2026-05-10 | Cobertura de E3 (Integridad del flujo de tráfico) mediante captura tcpdump añadida a la cadena**
- **Decisión:** Añadir un paso operativo de captura `tcpdump -i any -w /tmp/lateral.pcap -c 50 host backend` dentro del contenedor `webapp` durante la ejecución del payload SSTI que invoca `curl http://backend:5000/empleados`, y conservar el `.pcap` resultante en `tests/logs/` como evidencia de E3.
- **Alternativas descartadas:**
  - **Eliminar E3 del set y notificar al tutor.** Reduce el alcance prometido en el correo del 2026-03-17 validado el 2026-04-09. Coste de comunicación bajo pero sacrifica una de las 6 métricas oficiales.
  - **Reinterpretar E3 como "ausencia de cifrado interno verificada" estática** (sin captura dinámica). Más rápido (~10 min) pero pierde la fuerza visual del `.pcap` con JSON legible que en el Escenario B se contrasta directamente contra un blob TLS o una conexión rechazada por mTLS.
- **Motivo:** La cadena HTB-style implementada el 2026-05-09 abandonó MITM como vector activo (la sección 7.5 del prototipo original lo dejaba como demostración opcional). Sin esta decisión, E3 quedaría sin evidencia operativa en el Escenario A y sin material comparable en el Escenario B. La captura `tcpdump` añade ~30 min al protocolo de la sesión y produce el contraste visual perimetral (HTTP claro, JSON legible) ↔ Zero Trust (TLS cifrado o conexión rechazada) que la memoria necesita para defender la introducción de mTLS.
- **Impacto:** El protocolo operativo de la sesión de captura incorpora 5 pasos adicionales (apertura de tcpdump, lanzamiento del payload, parada, copia del `.pcap` al host, verificación con Wireshark). Las plantillas (`tests/00_PLANTILLA_KPI.md` §1.1, §2.1) reservan celda específica para la ruta del `.pcap`. Sin impacto en la arquitectura de los contenedores ni en `infra/perimetral/`.
- **Trazabilidad completa:** [docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md §6](../docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md).

**2026-05-12 | Separación metodológica pre-RCE vs post-RCE en la plantilla de KPIs (v2)**
- **Decisión:** Publicar [`tests/00_PLANTILLA_KPI_v2.md`](../tests/00_PLANTILLA_KPI_v2.md) manteniendo [`tests/00_PLANTILLA_KPI.md`](../tests/00_PLANTILLA_KPI.md) como referencia histórica (v1). En v2, los timings se dividen en **§1.2.a / §2.2.a** (caracterización del punto de entrada, pre-RCE) y **§1.2.b / §2.2.b** (cronometraje de la **comparativa A↔B**, post-RCE). Se define explícitamente **`T0_efectivo`** como el instante en que el atacante dispone de **shell post-RCE** en `webapp` (p. ej. reverse shell establecida o primer comando arbitrario equivalente al proceso vulnerable); todos los Δ comparativos se miden desde ese instante. Las métricas oficiales G1–G3 y E1–E3 se interpretan en coherencia con esa fase post-explotación.
- **Fundamento normativo:** El modelo de amenazas enviado al tutor el 2026-03-17 y validado el 2026-04-09 asume un atacante externo no privilegiado que **ya obtiene RCE** en el servicio web y delimita las amenazas en estudio al movimiento lateral, interceptación de tráfico interno y exfiltración (véase [docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md](../docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md) §11–§12). Cronometrar reconocimiento, login o SSTI como si fueran KPIs comparables entre arquitecturas A y B introduce **asimetría no atribuible a la microsegmentación** (el entry point está fijado por diseño en ambos escenarios).
- **Alternativas descartadas:**
  - **Unificar todo en una sola tabla de timings** (v1). Sencillo operativamente pero mezcla narrativa de laboratorio con evidencia cuantitativa del núcleo del TFG y dificulta defender ante tribunal por qué fases pre-RCE entran o no en el cuadro comparativo.
  - **Eliminar por completo la caracterización pre-RCE.** Pierde material útil para el capítulo de diseño del escenario y para la tabla §1.3 / §2.3 (pasos previos al RCE, CWEs encadenados).
- **Impacto:** Las nuevas sesiones de captura deben usar v2. Las entradas ADR previas que citan `tests/00_PLANTILLA_KPI.md` siguen siendo válidas como contexto histórico; donde proceda, enlazar también v2. El denominador de "pasos bloqueados por ZT" en §2.3 de v2 pasa a referirse a los **cuatro hitos post-RCE** de §2.2.b (sustituye al conteo sobre nueve hitos de la v1).
- **Trazabilidad:** correos tutor §10–§12 en [`docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md`](../docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md); plantilla operativa [`tests/00_PLANTILLA_KPI_v2.md`](../tests/00_PLANTILLA_KPI_v2.md).

---

**2026-05-24 | Cambio de deadline a 21/06/2026 y activación del Sprint Final**

- **Decisión:** Pivotar la convocatoria objetivo de septiembre a **julio**. El nuevo deadline de entrega es el **21/06/2026**. El ROADMAP v1 queda archivado en `admin/ROADMAP_v1_archivado.md`. El plan activo es `admin/ROADMAP_v2_sprint_final.md`.
- **Motivo:** El contrato a tiempo completo de Pau finaliza, liberando disponibilidad de 12h/día a partir del 02/06. El tutor (correo 24/05/2026) abre la puerta explícitamente ("Lo podemos intentar sí") condicionado a un borrador "razonablemente decente" previo. Entregar en julio permite optar al máster sin perder prioridad por falta de TFG.
- **Capacidad efectiva:** ~190-200h totales (9-12h hasta 01/06; ~180h del 02 al 21/06 a 12h/día × 0.75).
- **Impacto en gestión:** el agente semanal debe leer `ROADMAP_v2_sprint_final.md` como fuente de verdad. `ROADMAP.md` redirige a v2. `STATE.md` reescrito con nueva estructura de tareas y hitos del Sprint Final.

---

**2026-05-24 | Reducción de alcance técnico del Escenario B para Sprint Final**

- **Decisión:** El Escenario B se implementa con el siguiente alcance reducido (mínimo viable defendible):
  1. Microsegmentación con 3 redes Docker aisladas: `web_zone`, `backend_zone`, `db_zone`.
  2. Identidad de servicio mínima: `.env` por servicio, sin credenciales compartidas entre contenedores.
  3. mTLS en un único canal: `webapp ↔ backend`. Certs autofirmados con OpenSSL. Caddy o Nginx como proxy TLS.
  4. Wazuh manager + 1 agent en `webapp`, con 3-5 reglas custom para los 4 hitos post-RCE (§1.2.b de la plantilla KPI v2).
- **Alternativas descartadas:**
  - **Wazuh completo con dashboard + integraciones:** tiempo de setup 30-50h con varianza alta. No aporta valor diferencial a los KPIs G1/G3, que solo necesitan que exista un mecanismo y que dispare una alerta.
  - **mTLS en todo el stack (incluido backend ↔ db):** añade ~8-12h de configuración por un canal secundario que no es el objetivo principal de comparación. Se documenta como trabajo futuro.
  - **Suricata como sonda de red:** el diseño inicial (borrador pre-propuesta) lo incluía. La detección host-based de Wazuh es más relevante para el modelo de amenazas definido (RCE dentro del contenedor). Suricata queda como trabajo futuro documentado en Cap. 7.
- **NO se implementa en este sprint:** automatización avanzada de scripts de ataque, ataques de spoofing adicionales, dashboard Wazuh custom, escalado multi-agente, despliegue Kubernetes.
- **Impacto:** la tesis comparativa sigue siendo completamente defendible con este alcance. Los 6 KPIs son medibles y comparables. El tribunal puede preguntar por Suricata → justificación en `docs/03_memoria_tfg/04_diseno.md §4.3.5`.

---

**2026-05-24 | Criterio de fallback Wazuh → Falco (checkpoint duro 04/06 20:00)**

- **Decisión:** Si a las **20:00 del 04/06/2026** Wazuh no tiene (a) el agent enrollado en `webapp` Y (b) al menos 1 alerta activa funcionando, se abandona Wazuh y se despliega Falco como sustituto.
- **Motivo:** Wazuh tiene varianza de instalación alta (10-40h documentadas en la comunidad para entornos Docker). La tesis de "observabilidad activa = G1 `(true, X s)` y G3 `(true, Y%)`" es igualmente defendible con Falco (runtime security, reglas YAML). El cambio de herramienta no invalida la comparativa A/B.
- **Protocolo de activación del fallback:**
  1. `git checkout` de la rama o directorio de configuración Wazuh.
  2. Crear `infra/zero_trust/falco/` con configuración base.
  3. Definir reglas Falco equivalentes a las 3-5 reglas Wazuh previstas.
  4. Tiempo estimado de reconversión: 3-4h.
- **Alternativas descartadas:** Logs centralizados con script Python (solución casera). Se descarta porque no produce alertas con timestamp preciso para G1 y no es nominalmente comparable con las herramientas de observabilidad citadas en el Estado del Arte.
- **Impacto:** este ADR debe citarse en `docs/03_memoria_tfg/04_diseno.md §4.3.4` como decisión de diseño explícita, no como improvisación.
- **Trazabilidad:** `admin/ROADMAP_v2_sprint_final.md` §Fase 2, día 04/06.

---

**2026-06-03 | Arquitectura mTLS: Opción B — único contenedor `backend` (Nginx + Flask)**

- **Decisión:** El servicio `backend` ejecuta Nginx (PEP mTLS, puerto 443) y Flask (API interna, puerto 5000) en el **mismo contenedor**. Nginx hace `proxy_pass` a `http://localhost:5000`. El `nginx.conf` mTLS se monta como volumen de solo lectura.
- **Alternativa descartada — Opción A (sidecar):** Separar `backend` (Nginx) y `backend-api` (Flask) en dos servicios distintos con una red `backend_internal` adicional entre ellos.
- **Motivo del descarte de Opción A:** El patrón sidecar no está documentado en `Investigacion_ZeroTrust.md` ni en `20260603_Prototipo_ZeroTrust.md`. Introducirlo violaría la regla de trazabilidad del prototipo §Prototipo: *"no se introducen tecnologías, patrones ni controles ausentes en la investigación"*. El único contenedor `backend` es fiel al diagrama de zonas funcionales documentado.
- **Implementación:** `CMD ["sh", "-c", "python app.py & nginx -g 'daemon off;'"]` en `infra/zero_trust/backend/Dockerfile`. Nginx instalado vía `apt-get` en la imagen.
- **Impacto:** Sin redes adicionales. El compose mantiene exactamente `web_zone`, `backend_zone`, `db_zone` sin ninguna red `backend_internal`.
- **Verificación:** `curl` con cert → HTTP 200; `curl` sin cert → HTTP 400 "No required SSL certificate was sent". Sesión 03/06.
- **Trazabilidad:** [`docs/04_diario_laboratorio/20260603_Sesion_ZT_DockerCompose.md §4`](../docs/04_diario_laboratorio/20260603_Sesion_ZT_DockerCompose.md).

---

**2026-06-04 | Despliegue de Wazuh: Opción B — manager + agent como contenedores Docker**

- **Decisión:** Wazuh se despliega enteramente en Docker. El agente corre como contenedor con `/var/run/docker.sock` montado y `--pid=host`, en lugar de instalarse como servicio nativo en la distro WSL2 del usuario.
- **Postura original supersedida — Opción A (agente en host):** `Investigacion_ZeroTrust.md` §Monitoreo y `20260603_Prototipo_ZeroTrust.md` §8 establecían *"agente en el host Docker"* como arquitectura de referencia, argumentando mayor visibilidad sobre syscalls de todos los contenedores.
- **Por qué se descarta Opción A en este entorno:** Docker Desktop en Windows + WSL2 crea namespaces separados: la distro Ubuntu del usuario y la distro interna `docker-desktop` (donde corren realmente los contenedores). El agente Wazuh instalado en Ubuntu WSL2 **no tiene visibilidad sobre los namespaces de proceso de `docker-desktop`**. Adicionalmente, el kernel personalizado de WSL2 tiene soporte parcial o nulo de `auditd`, impidiendo la monitorización de syscalls documentada en el prototipo. La mayor complejidad de instalación (activar `systemd` en WSL2, subsistema `audit`) no se traduce en mayor cobertura real de detección respecto a la Opción B.
- **Por qué se elige Opción B:** un contenedor del agente con socket Docker montado y `--pid=host` proporciona la misma cobertura operativa (`docker-listener` + FIM) con plena reproducibilidad. Todo el stack levanta con un único `docker compose up` sin instalar nada en el host.
- **Cobertura real en Docker Desktop + WSL2 (igual para Opción A y B):** `docker-listener` (eventos exec/start/stop), FIM sobre rutas montadas de secretos y certs, command monitoring parcial vía `/proc` con `--pid=host`.
- **Limitación documentada (ninguna opción la resuelve en este entorno):** `auditd` completo con captura de syscalls de procesos en otros contenedores requiere el kernel `audit` activo. No disponible en Docker Desktop + WSL2. Se documenta en Cap. 5 del TFG como limitación de laboratorio. En un servidor Linux real o nodo Kubernetes (DaemonSet privilegiado), la Opción A funciona sin restricciones y es el patrón corporativo correcto.
- **Criterio de fallback vigente:** ADR 2026-05-24 sigue activo — si a las 20:00 del 04/06/2026 no hay agent enrollado y ≥1 alerta → activar Falco.
- **Trazabilidad:** [`docs/04_diario_laboratorio/20260604_Sesion_Wazuh_Docker.md`](../docs/04_diario_laboratorio/20260604_Sesion_Wazuh_Docker.md) (sesión en curso).