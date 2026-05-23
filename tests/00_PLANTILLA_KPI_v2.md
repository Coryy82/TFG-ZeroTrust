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

> Sesión: `perimetral_sesion_20260523_175204` — Fecha: 2026-05-23 — Operador: Cory
> Commit del repositorio: `c72d80b` — Versión `docker compose`: v2 (Docker Desktop)
> Log de arranque asociado: `tests/logs/perimetral_sesion_20260523_175204/compose_up.log`

### 1.1 Métricas oficiales (validadas por tutor)

> **Nota v2:** Los valores de esta tabla describen el resultado **tras** el compromiso de `webapp` (post-RCE). La evidencia suele recogerse desde la shell en `webapp` o desde logs/pcaps generados en esa fase.

| Cód. | Métrica | `mecanismo_existe` | Valor / Resultado | Evidencia (ruta de archivo) |
|---|---|---|---|---|
| G1 | Tiempo de Detección | ☒ No | `(false, ∞)` — ningún mecanismo de alerta activo; accesos no generan evento alguno | `tests/logs/perimetral_sesion_20260523_175204/nginx.log` + `webapp.log` (solo access logs, sin SIEM) |
| G2 | Profundidad del ataque | n/a | **3 nodos**: ☒ webapp ☒ backend ☒ db | `tests/logs/perimetral_sesion_20260523_175204/e1_scan.log` + `lateral.json` + `dump.txt` |
| G3 | Tasa de bloqueo | ☒ No | `(false, 0 %)` — todas las conexiones post-RCE tuvieron éxito; ningún control cortó el flujo | `tests/logs/perimetral_sesion_20260523_175204/lateral.json` (curl 200 OK) + `dump.txt` (psql 3 rows) |
| E1 | Superficie de Ataque Interna Visible | n/a | **3 / 3** servicios visibles desde webapp (backend:5000, db:5432, nginx:80) | `tests/logs/perimetral_sesion_20260523_175204/e1_scan.log` |
| E2 | Volumen de datos fugados | n/a | **3 reg. empleados + 1 cred. DB** / ~766 B / 3 archivos | `tests/logs/perimetral_sesion_20260523_175204/lateral.json` (304 B) + `dump.txt` (427 B) + `creds.txt` (35 B) |
| E3 | Integridad del flujo de tráfico | n/a | ☒ texto claro — HTTP sin TLS; JSON con nombres, emails y salarios legible en tránsito | `tests/logs/perimetral_sesion_20260523_175204/lateral.pcap` (verificado con tshark: pkts 4, 8, 20, 24 = GET + 200 OK JSON en claro) |

### 1.2.a Caracterización del punto de entrada (pre-RCE) — no comparativa A↔B

> **Uso:** Relato del escenario, capturas para la memoria (diseño del laboratorio), tabla §1.3. **No** alimenta el cuadro §3. Los tiempos aquí no deben interpretarse como KPIs frente al Escenario B (el entry point está fijado por diseño en ambos escenarios).
>
> **Canal sugerido:** navegador y/o DevTools; `curl` solo si se desea evidencia adicional en log.

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs T0_entrada (s) | Evidencia (ruta) |
|---|---|---|---|---|
| T0_entrada | Primera petición HTTP al portal (`HEAD /` via `curl -I`) | 17:52:55 | 0 | `tests/logs/perimetral_sesion_20260523_175204/nginx.log` línea 1 |
| T_recon_http | Cabeceras HTTP — `curl -I` → `X-Powered-By: Flask`, `Server: nginx` | 17:52:55 | 0 | `tests/logs/perimetral_sesion_20260523_175204/nginx.log` |
| T_recon_rutas | `GET /robots.txt` manual (tras gobuster) → rutas `/admin`, `/backup.txt` | 17:53:22 | 27 | `tests/logs/perimetral_sesion_20260523_175204/webapp.log` línea 4761 |
| T_disclosure | `GET /backup.txt` → credenciales `admin:Empresa2026!` en texto claro | 17:53:29 | 34 | `tests/logs/perimetral_sesion_20260523_175204/webapp.log` línea 4762 |
| T_auth | `POST /admin/login` → 302 redirect (login OK, sesión establecida) | 17:53:50 | 55 | `tests/logs/perimetral_sesion_20260523_175204/webapp.log` línea 4765 |
| T_ssti_detect | `GET /admin/diagnostico?host={{7*7}}` → respuesta con `49` confirmada | 17:54:27 | 92 | `tests/logs/perimetral_sesion_20260523_175204/webapp.log` línea 4769 + `tests/img/20260520/` |
| T_rce | Reverse shell recibida en listener `ncat -lvnp 4444` (`Connection received on 127.0.0.1:53792`) | 17:57:56 | 301 | `tests/RCE comandos y notas.txt` (PS1: `[17:57:56] root@webapp`) |

### 1.2.b Evidencia operativa — Timings de la comparativa (post-RCE)

> **`T0_efectivo`:** igual a `T_rce` de la tabla anterior **o** al timestamp acordado en §1.4 si se simula el estado inicial (solo documentado, no recomendado en A). Todos los Δ son **segundos desde `T0_efectivo`**.

| Cód. | Hito | Hora absoluta (`HH:MM:SS`) | Δ vs `T0_efectivo` (s) | Captura / log asociado |
|---|---|---|---|---|
| T0_efectivo | Shell post-RCE operativa en `webapp` — reverse shell recibida, PTY mejorada con `pty.spawn` | 17:57:56 | 0 | `tests/RCE comandos y notas.txt` (PS1 `[17:57:56]`) |
| T_exfil_creds | `env \| grep DB_` → `DB_PASSWORD=supersecret`, `DB_HOST=db` visibles y guardados en `/tmp/creds.txt` | ~17:58:20 | ~24 | `tests/logs/perimetral_sesion_20260523_175204/creds.txt` |
| T_lateral | `curl -s http://backend:5000/empleados` → JSON 3 empleados (200 OK, sin auth) | ~18:02:00 | ~244 | `tests/logs/perimetral_sesion_20260523_175204/lateral.json` |
| T_e3_pcap | `tcpdump -i any -w /tmp/lateral.pcap -c 50 host backend &` lanzado antes del curl | ~18:02:00 | ~244 | `tests/logs/perimetral_sesion_20260523_175204/lateral.pcap` (tshark: 32 pkts, 3 tx HTTP en claro) |
| T_objetivo | `psql -h db -U postgres -d empresa_db` → `count=3` + dump completo de `empleados` | ~18:02:30 | ~274 | `tests/logs/perimetral_sesion_20260523_175204/dump.txt` |

### 1.3 KPIs adicionales del refactor HTB

| Métrica | Valor |
|---|---|
| Nº pasos previos al RCE | **5** (recon HTTP → robots.txt → backup.txt → login → SSTI confirm) |
| Nº endpoints públicos que filtran información | **2** (`/robots.txt` → rutas internas; `/backup.txt` → credenciales admin en texto claro) |
| Nº CWE distintos materializables | **4** (CWE-1336 SSTI, CWE-200 Information Disclosure, CWE-306 Missing Auth en API interna, CWE-522 Insufficiently Protected Credentials) |

### 1.4 Observaciones de la sesión

**Sesión oficial** (la `perimetral_sesion_20260512_155313_prueba` queda marcada como ensayo: `dump.txt` y `lateral.pcap` eran 0 bytes en esa sesión).

**T0_efectivo:** fijado en `17:57:56 CEST` según primera línea de PS1 con timestamp visible en `tests/RCE comandos y notas.txt` (`[17:57:56] root@webapp:/app#`). Criterio: instante en que el listener `ncat -lvnp 4444` recibió la conexión y quedó shell operativa.

**Canal post-RCE:** reverse shell via SSTI + `pty.spawn("/bin/bash")`. No se realizó `stty raw -echo` completo (PTY parcial); se aplicó `stty rows 40 cols 120`. Terminal funcional para todos los comandos KPI sin pérdida de salida.

**Timestamps post-RCE:** solo parcialmente precisos. `T_exfil_creds` aproximado por PS1 `[17:58:19]`. `T_lateral`, `T_e3_pcap` y `T_objetivo` aproximados por el timestamp de `nmap` en `e1_scan.log` (`2026-05-23 18:02 CEST`). Los Δ en §1.2.b son orientativos al minuto, no al segundo exacto.

**lateral.pcap:** 32 paquetes capturados + corte durante 3ª transacción (aviso `cut short` de tshark — cosmético, causado por `kill` de tcpdump). Dos transacciones HTTP completas evidencian E3: `GET /empleados HTTP/1.1` y `HTTP/1.1 200 OK, JSON (application/json)` en texto claro. Se realizaron 3 llamadas curl al endpoint (re-ejecución manual), todas capturadas o iniciadas en el pcap.

**Gobuster en pre-RCE:** se ejecutó un scan automático con `gobuster` (User-Agent `gobuster/3.8.2` visible en nginx.log). Este paso no forma parte del flujo HTB canónico de la plantilla; la secuencia manual comienza con `curl -I` y continúa con `robots.txt` / `backup.txt` consultados directamente. Los tiempos de §1.2.a reflejan solo los hitos manuales relevantes.

**Nota reproducibilidad:** todos los artefactos son reproducibles con `./tests/scripts/logcapture_perimetral.sh` sobre el commit `c72d80b`.

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
| G1 | Tiempo de Detección | `(false, ∞)` — ningún SIEM ni alerta configurada | `(true, _____ s)` | ZT introduce capacidad de detección inexistente en perimetral |
| G2 | Profundidad del ataque | **3 nodos** (webapp → backend → db) | _____ nodos | Reducción del _____ % en alcance lateral |
| G3 | Tasa de bloqueo | `(false, 0 %)` — ningún control detuvo movimiento lateral ni acceso a DB | `(true, _____ %)` | ZT introduce contención inexistente en perimetral |
| E1 | Superficie visible | **3 / 3** servicios accesibles desde webapp | _____ / 3 | Reducción del _____ % en visibilidad interna |
| E2 | Volumen fugado | **~766 B / 3 reg. empleados + 1 cred. DB** | _____ | Reducción de _____ bytes / _____ registros |
| E3 | Integridad tráfico interno | **texto claro** (HTTP sin TLS, JSON legible en pcap) | cifrado / rechazado | mTLS impide MITM y fuerza autenticación de servicio |

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
