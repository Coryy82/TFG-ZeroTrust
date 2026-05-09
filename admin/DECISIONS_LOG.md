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