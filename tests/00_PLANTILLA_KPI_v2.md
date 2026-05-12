# Plantilla de Captura de KPIs (v2)

> **Versión:** v2 (2026-05-12). Respecto a la v1, deja de unificar todos los timings en una sola tabla: aquí hay una separación explícita entre **caracterización del punto de entrada** (pre-RCE) y **medición comparativa A↔B** (post-RCE). La v1 sigue disponible en [`00_PLANTILLA_KPI.md`](00_PLANTILLA_KPI.md) como referencia histórica.
>
> **Propósito:** Plantilla rellenable durante las sesiones de captura. Contiene la plantilla para cada escenario y el cuadro comparativo final.
>
> **Marco metodológico (por qué estas métricas y no otras, cómo se tratan G1/G3, por qué E3 lleva tcpdump):** ver [`docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md`](../docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md).
>
> **Alineación con el modelo de amenazas (tutor):** el alcance validado asume un atacante externo no privilegiado que **ya obtiene RCE** en el servicio web; las amenazas en estudio son post-explotación (movimiento lateral, MITM interno, exfiltración). Por tanto, **G1–G3 y E1–E3 se interpretan y cronometran a partir del estado post-RCE** (shell interactiva en `webapp` o equivalente). Los hitos previos al RCE sirven para **narrativa y caracterización del laboratorio**, no para el cuadro comparativo final.
>
> **Convenciones de notación:**
> - `(false, ∞)` o `(false, 0%)` → métrica cuyo mecanismo no existe en el modelo evaluado (válido y esperado en perimetral para G1 y G3).
> - `(true, X)` → métrica con mecanismo activo y valor numérico medido.
> - Rutas de evidencia relativas al raíz del repo (ej. `tests/logs/20260510_recon.png`).
> - **`T0_efectivo`:** instante en que queda establecido el **control post-RCE** en `webapp` (p. ej. reverse shell conectada al listener del host, o primer comando arbitrario ejecutado con el mismo UID que el proceso Flask). Todos los Δ de la §1.2.b / §2.2.b se miden respecto a `T0_efectivo`.

---

## 1. PLANTILLA DE CAPTURA — ESCENARIO A (PERIMETRAL)

> Sesión: _______________________ — Fecha: ____-____-____ — Operador: ___________
> Commit del repositorio: `_______________` — Versión `docker compose`: `_______________`
> Log de arranque asociado: `tests/logs/_______________.log`

### 1.1 Métricas oficiales (validadas por tutor)

> **Nota v2:** Los valores de esta tabla describen el resultado **tras** el compromiso de `webapp` (post-RCE). La evidencia suele recogerse desde la shell en `webapp` o desde logs/pcaps generados en esa fase.

| Cód. | Métrica | `mecanismo_existe` | Valor / Resultado | Evidencia (ruta de archivo) |
|---|---|---|---|---|
| G1 | Tiempo de Detección | ☐ Sí ☐ No | __________ | `tests/logs/_______________` |
| G2 | Profundidad del ataque | n/a | _____ nodos: ☐ webapp ☐ backend ☐ db | `tests/logs/_______________` |
| G3 | Tasa de bloqueo | ☐ Sí ☐ No | __________ % | `tests/logs/_______________` |
| E1 | Superficie de Ataque Interna Visible | n/a | _____ / _____ servicios visibles desde webapp | `tests/logs/_______________` |
| E2 | Volumen de datos fugados | n/a | _____ registros / _____ bytes / _____ archivos | `tests/logs/_______________` |
| E3 | Integridad del flujo de tráfico | n/a | ☐ texto claro ☐ cifrado ☐ rechazado | `tests/logs/_______________.pcap` |

### 1.2.a Caracterización del punto de entrada (pre-RCE) — no comparativa A↔B

> **Uso:** Relato del escenario, capturas para la memoria (diseño del laboratorio), tabla §1.3. **No** alimenta el cuadro §3. Los tiempos aquí no deben interpretarse como KPIs frente al Escenario B (el entry point está fijado por diseño en ambos escenarios).
>
> **Canal sugerido:** navegador y/o DevTools; `curl` solo si se desea evidencia adicional en log.

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs T0_entrada (s) | Evidencia (ruta) |
|---|---|---|---|---|
| T0_entrada | Inicio de la sesión de caracterización (p. ej. primera petición HTTP al portal) | _________ | 0 | _______________ |
| T_recon_http | Cabeceras HTTP / fingerprint (`X-Powered-By`, etc.) | _________ | _____ | _______________ |
| T_recon_rutas | `/robots.txt` | _________ | _____ | _______________ |
| T_disclosure | `/backup.txt` (creds) | _________ | _____ | _______________ |
| T_auth | Login OK en `/admin` | _________ | _____ | _______________ |
| T_ssti_detect | `{{7*7}}` → 49 en `/admin/diagnostico` | _________ | _____ | _______________ |
| T_rce | RCE confirmado (p. ej. `id` vía SSTI **o** instante en que la reverse shell recibe conexión) | _________ | _____ | _______________ |

### 1.2.b Evidencia operativa — Timings de la comparativa (post-RCE)

> **`T0_efectivo`:** igual a `T_rce` de la tabla anterior **o** al timestamp acordado en §1.4 si se simula el estado inicial (solo documentado, no recomendado en A). Todos los Δ son **segundos desde `T0_efectivo`**.

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs `T0_efectivo` (s) | Captura / log asociado |
|---|---|---|---|---|
| T0_efectivo | Shell post-RCE operativa en `webapp` (reverse shell o equivalente) | _________ | 0 | _______________ |
| T_exfil_creds | Credenciales sensibles visibles (p. ej. `env` → `DB_PASSWORD`) | _________ | _____ | _______________ |
| T_lateral | Acceso a API interna (p. ej. `curl http://backend:5000/empleados`) | _________ | _____ | _______________ |
| T_e3_pcap | Captura `tcpdump` hacia `backend` asociada a E3 (si aplica en el protocolo) | _________ | _____ | _______________ |
| T_objetivo | Acceso a BBDD (p. ej. `psql -h db` …) | _________ | _____ | _______________ |

### 1.3 KPIs adicionales del refactor HTB

| Métrica | Valor |
|---|---|
| Nº pasos previos al RCE | _____ |
| Nº endpoints públicos que filtran información | _____ |
| Nº CWE distintos materializables | _____ |

### 1.4 Observaciones de la sesión

> _Espacio libre para anotar incidentes, diferencias respecto a lo previsto, decisiones tomadas en caliente, criterio exacto usado para fijar `T0_efectivo`, etc._

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

### 2.2.a Caracterización del punto de entrada (pre-RCE) — opcional en B

> **Uso:** Solo si se repite el mismo flujo HTB que en A para demostrar que el vector sigue siendo explotable y que la diferencia está en **post-RCE**. Si el entry point es idéntico por diseño, puede **omitirse** y referenciarse la sesión A; indícalo en §2.4.

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs T0_entrada (s) | Evidencia | Notas |
|---|---|---|---|---|---|
| T0_entrada | (opcional) | _________ | 0 | _______________ | ☐ omitido — ver sesión A |
| T_recon_http | | _________ | _____ | _______________ | |
| T_recon_rutas | | _________ | _____ | _______________ | |
| T_disclosure | | _________ | _____ | _______________ | |
| T_auth | | _________ | _____ | _______________ | |
| T_ssti_detect | | _________ | _____ | _______________ | |
| T_rce | | _________ | _____ | _______________ | |

### 2.2.b Evidencia operativa — Timings de la comparativa (post-RCE)

> Misma convención que §1.2.b. **`T0_efectivo`** debe ser **comparable** en definición con la sesión del Escenario A.

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs `T0_efectivo` (s) | Captura / log asociado | ¿Bloqueado por control ZT? |
|---|---|---|---|---|---|
| T0_efectivo | Shell post-RCE operativa en `webapp` | _________ | 0 | _______________ | n/a |
| T_exfil_creds | | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_lateral | | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_e3_pcap | | _________ | _____ | _______________ | ☐ Sí ☐ No |
| T_objetivo | | _________ | _____ | _______________ | ☐ Sí ☐ No |

### 2.3 KPIs adicionales

| Métrica | Valor |
|---|---|
| Nº pasos previos al RCE | _____ (o `n/a` si §2.2.a omitida) |
| Nº endpoints públicos que filtran información | _____ |
| Nº CWE distintos materializables | _____ |
| Nº de hitos post-RCE bloqueados por controles ZT | _____ / 4 |

> **Denominador 4:** corresponde a los cuatro hitos de §2.2.b (`T_exfil_creds`, `T_lateral`, `T_e3_pcap`, `T_objetivo`). Si un hito no aplica en B, anótalo en §2.4 y ajusta el denominador con justificación.

### 2.4 Observaciones de la sesión

> _Espacio libre._

---

## 3. CUADRO COMPARATIVO FINAL

A rellenar tras completar las dos campañas de captura. Es la tabla candidata a ir en el capítulo "Resultados" de la memoria.

> **v2:** Las celdas deben basarse en la **fase post-RCE** (§1.2.b / §2.2.b y §1.1 / §2.1). La caracterización pre-RCE no sustenta afirmaciones del tipo "Zero Trust reduce el tiempo hasta el login".

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
- `<paso>` → identificador del hito (`recon`, `disclosure`, `login`, `ssti`, `rce`, `post_exfil`, `lateral`, `e3_pcap`, `objetivo`, etc.).
- `<ext>` → `png` para captura de pantalla, `pcap` para tráfico de red, `log` para salida de terminal, `txt` para notas.

Ejemplos:
- `tests/logs/20260510_perimetral_recon_robots.png`
- `tests/logs/20260510_perimetral_lateral.pcap`
- `tests/logs/20260510_docker_compose_up.log`
