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
- **Trazabilidad completa:** [docs/01_investigacion/20260509a_Sesion_Refactor_EscenarioA_HTB.md](../docs/01_investigacion/20260509a_Sesion_Refactor_EscenarioA_HTB.md).