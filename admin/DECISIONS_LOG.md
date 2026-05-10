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