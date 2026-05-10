# Plantilla de Captura de KPIs

> **Propósito:** Plantilla rellenable durante las sesiones de captura. Contiene la plantilla para cada escenario y el cuadro comparativo final.
>
> **Marco metodológico (por qué estas métricas y no otras, cómo se tratan G1/G3, por qué E3 lleva tcpdump):** ver [`docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md`](../docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md).
>
> **Convenciones de notación:**
> - `(false, ∞)` o `(false, 0%)` → métrica cuyo mecanismo no existe en el modelo evaluado (válido y esperado en perimetral para G1 y G3).
> - `(true, X)` → métrica con mecanismo activo y valor numérico medido.
> - Rutas de evidencia relativas al raíz del repo (ej. `tests/logs/20260510_recon.png`).

---

## 1. PLANTILLA DE CAPTURA — ESCENARIO A (PERIMETRAL)

> Sesión: _______________________ — Fecha: ____-____-____ — Operador: ___________
> Commit del repositorio: `_______________` — Versión `docker compose`: `_______________`
> Log de arranque asociado: `tests/logs/_______________.log`

### 1.1 Métricas oficiales (validadas por tutor)

| Cód. | Métrica | `mecanismo_existe` | Valor / Resultado | Evidencia (ruta de archivo) |
|---|---|---|---|---|
| G1 | Tiempo de Detección | ☐ Sí ☐ No | __________ | `tests/logs/_______________` |
| G2 | Profundidad del ataque | n/a | _____ nodos: ☐ webapp ☐ backend ☐ db | `tests/logs/_______________` |
| G3 | Tasa de bloqueo | ☐ Sí ☐ No | __________ % | `tests/logs/_______________` |
| E1 | Superficie de Ataque Interna Visible | n/a | _____ / _____ servicios visibles desde webapp | `tests/logs/_______________` |
| E2 | Volumen de datos fugados | n/a | _____ registros / _____ bytes / _____ archivos | `tests/logs/_______________` |
| E3 | Integridad del flujo de tráfico | n/a | ☐ texto claro ☐ cifrado ☐ rechazado | `tests/logs/_______________.pcap` |

### 1.2 Evidencia operativa — Timings granulares

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs T0 (segundos) | Captura asociada |
|---|---|---|---|---|
| T0 | Inicio | _________ | 0 | _______________ |
| T_recon_http | Banner `curl -I` | _________ | _____ | _______________ |
| T_recon_rutas | `/robots.txt` | _________ | _____ | _______________ |
| T_disclosure | `/backup.txt` (creds) | _________ | _____ | _______________ |
| T_auth | Login OK | _________ | _____ | _______________ |
| T_ssti_detect | `{{7*7}}` → 49 | _________ | _____ | _______________ |
| T_rce | `popen('id')` → uid=0 | _________ | _____ | _______________ |
| T_exfil_creds | `popen('env')` → DB_PASSWORD | _________ | _____ | _______________ |
| T_lateral | `curl backend` JSON | _________ | _____ | _______________ |
| T_objetivo | `psql -h db` dump | _________ | _____ | _______________ |

### 1.3 KPIs adicionales del refactor HTB

| Métrica | Valor |
|---|---|
| Nº pasos previos al RCE | _____ |
| Nº endpoints públicos que filtran información | _____ |
| Nº CWE distintos materializables | _____ |

### 1.4 Observaciones de la sesión

> _Espacio libre para anotar incidentes, diferencias respecto a lo previsto, decisiones tomadas en caliente, etc._

---

## 2. PLANTILLA DE CAPTURA — ESCENARIO B (ZERO TRUST)

> Sesión: _______________________ — Fecha: ____-____-____ — Operador: ___________
> Commit del repositorio: `_______________` — Versión `docker compose`: `_______________`
> Log de arranque asociado: `tests/logs/_______________.log`

### 2.1 Métricas oficiales

| Cód. | Métrica | `mecanismo_existe` | Valor / Resultado | Evidencia |
|---|---|---|---|---|
| G1 | Tiempo de Detección | ☐ Sí ☐ No | __________ | `tests/logs/_______________` |
| G2 | Profundidad del ataque | n/a | _____ nodos | `tests/logs/_______________` |
| G3 | Tasa de bloqueo | ☐ Sí ☐ No | __________ % | `tests/logs/_______________` |
| E1 | Superficie de Ataque Interna Visible | n/a | _____ / _____ | `tests/logs/_______________` |
| E2 | Volumen de datos fugados | n/a | _____ registros / _____ bytes | `tests/logs/_______________` |
| E3 | Integridad del flujo de tráfico | n/a | ☐ claro ☐ cifrado ☐ rechazado | `tests/logs/_______________.pcap` |

### 2.2 Evidencia operativa — Timings granulares

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs T0 (segundos) | Captura asociada | ¿Bloqueado por control ZT? |
|---|---|---|---|---|---|
| T0 | Inicio | _________ | 0 | _______________ | n/a |
| T_recon_http | Banner `curl -I` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_recon_rutas | `/robots.txt` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_disclosure | `/backup.txt` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_auth | Login | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_ssti_detect | `{{7*7}}` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_rce | `popen('id')` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_exfil_creds | `popen('env')` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_lateral | `curl backend` | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_objetivo | `psql -h db` | _________ | _____ | _______________ | ☐ Sí ☐ No |

### 2.3 KPIs adicionales

| Métrica | Valor |
|---|---|
| Nº pasos previos al RCE | _____ |
| Nº endpoints públicos que filtran información | _____ |
| Nº CWE distintos materializables | _____ |
| Nº de pasos bloqueados por controles ZT | _____ / 9 |

### 2.4 Observaciones de la sesión

> _Espacio libre._

---

## 3. CUADRO COMPARATIVO FINAL

A rellenar tras completar las dos campañas de captura. Es la tabla candidata a ir en el capítulo "Resultados" de la memoria.

| Cód. | Métrica | Escenario A (perimetral) | Escenario B (Zero Trust) | Δ / interpretación |
|---|---|---|---|---|
| G1 | Tiempo de Detección | (false, ∞) | (true, _____ s) | ZT introduce capacidad de detección inexistente en perimetral |
| G2 | Profundidad del ataque | _____ nodos | _____ nodos | Reducción del _____ % en alcance lateral |
| G3 | Tasa de bloqueo | (false, 0%) | (true, _____ %) | ZT introduce contención inexistente en perimetral |
| E1 | Superficie visible | _____ / _____ | _____ / _____ | Reducción del _____ % en visibilidad interna |
| E2 | Volumen fugado | _____ | _____ | Reducción de _____ bytes / _____ registros |
| E3 | Integridad tráfico interno | claro | cifrado / rechazado | mTLS impide MITM y fuerza autenticación de servicio |

---

## 4. Convenciones de archivado de evidencias

Para mantener trazabilidad entre la celda de la plantilla y el archivo de evidencia, los nombres de fichero siguen el patrón:

```
tests/logs/YYYYMMDD_<escenario>_<paso>.<ext>
```

Donde:
- `YYYYMMDD` → fecha de la captura.
- `<escenario>` → `perimetral` o `zerotrust`.
- `<paso>` → identificador del hito (`recon`, `disclosure`, `login`, `ssti`, `rce`, `lateral`, `objetivo`, etc.).
- `<ext>` → `png` para captura de pantalla, `pcap` para tráfico de red, `log` para salida de terminal, `txt` para notas.

Ejemplos:
- `tests/logs/20260510_perimetral_recon_robots.png`
- `tests/logs/20260510_perimetral_lateral.pcap`
- `tests/logs/20260510_docker_compose_up.log`
