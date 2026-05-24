# Capítulo 6 — Pruebas y Resultados

> **Estado:** ESQUELETO — redactar en semana 3 (10-11/06). CORAZÓN DEL TFG. Máxima nota.
> Fuentes: `tests/00_PLANTILLA_KPI_v2.md §1 (A, ya completo) + §2 (B, pendiente) + §3 (comparativa, pendiente)`.
> Criterio del tutor (§4): métricas estrictamente comparables entre escenarios. Pruebas de post-explotación.
> Objetivo de extensión: 12-16 páginas.

---

## 6.1 Metodología de pruebas

### 6.1.1 Entorno de pruebas

[TODO] Descripción del entorno: hardware, SO host (Windows 11 + WSL2), Docker Compose v2. Reproducibilidad garantizada mediante `logcapture_perimetral.sh` y equivalente para Escenario B.

### 6.1.2 Protocolo de ejecución

[TODO] Los ensayos siguen el mismo protocolo en ambos escenarios:
1. `docker compose up --build -d` — entorno limpio.
2. Ejecución de la cadena de ataque pre-RCE (recon → info disclosure → login → SSTI → RCE).
3. Registro de `T0_efectivo` (instante de shell post-RCE operativa).
4. Ejecución de los 4 hitos post-RCE: (1) exfiltración creds, (2) escaneo interno, (3) acceso backend, (4) volcado DB.
5. Captura de evidencias y logs mediante script.
6. `docker compose down`.

[INSUMO: `tests/00_PLANTILLA_KPI_v2.md` — protocolo completo]

### 6.1.3 Definición de T0_efectivo y ventana de medición

[TODO] Explicar la separación pre-RCE / post-RCE y por qué las métricas comparativas se miden desde T0_efectivo. Referencia al ADR 2026-05-12.

## 6.2 Resultados — Escenario A (Perimetral)

### 6.2.1 Cronología de la sesión oficial

Sesión: `perimetral_sesion_20260523_175204`.

| Hito pre-RCE                       | Hora CEST | Descripción                                    |
|------------------------------------|-----------|------------------------------------------------|
| Compose up — 4 servicios healthy   | 17:52:16  | —                                              |
| Banner grabbing (`curl -I`)        | 17:52:55  | `Server: nginx/1.25`, cabeceras expuestas      |
| Gobuster scan                      | 17:53:10  | Descubrimiento de rutas                        |
| `GET /robots.txt`                  | 17:53:22  | Rutas `/admin/login`, `/backup.txt` expuestas  |
| `GET /backup.txt` → creds          | 17:53:29  | `admin:Empresa2026!` en texto claro            |
| Login → 302 OK                     | 17:53:50  | Acceso al panel de administración              |
| SSTI confirmado (`{{7*7}}` → 49)   | 17:54:27  | RCE confirmado                                 |
| **T0_efectivo** (shell post-RCE)   | **17:57:56** | **Reverse shell operativa en `webapp`**     |

| Hito post-RCE                      | Δ desde T0 | Resultado                                      |
|------------------------------------|------------|------------------------------------------------|
| `env | grep DB_` → creds.txt       | ~24s       | `DB_PASSWORD=supersecret`, `DB_HOST=db`        |
| Nmap interno (E1)                  | ~244s      | `backend:5000`, `db:5432`, `nginx:80` visibles |
| `curl backend:5000/empleados` (E3) | ~244s      | HTTP/JSON texto claro, 3 empleados             |
| `psql -h db` → dump.txt (E2)       | ~274s      | 3 filas completas de tabla `empleados`         |

### 6.2.2 Métricas KPI — Escenario A

| Código | Valor                                        | Evidencia                                              |
|--------|----------------------------------------------|--------------------------------------------------------|
| G1     | `(false, ∞)` — sin SIEM, sin alerta          | `nginx.log` + `webapp.log`: solo access logs pasivos  |
| G2     | 3 nodos (webapp → backend → db)              | `e1_scan.log`, `lateral.json`, `dump.txt`              |
| G3     | `(false, 0%)` — ningún hito bloqueado        | Todos los hitos completados exitosamente               |
| E1     | 3/3 servicios visibles desde webapp          | `e1_scan.log`                                          |
| E2     | 3 reg. empleados + 1 cred. DB / ~766B        | `lateral.json` (304B) + `dump.txt` (427B) + `creds.txt` (35B) |
| E3     | Texto claro (HTTP/JSON sin TLS)              | `lateral.pcap` — tshark confirma HTTP/1.1 sin TLS      |

[FIG: captura tshark de lateral.pcap mostrando HTTP/JSON legible]

## 6.3 Resultados — Escenario B (Zero Trust)

> **Nota:** completar tras ejecutar las pruebas del Escenario B (06-08/06).

### 6.3.1 Cronología de la sesión oficial

[TODO POST-PRUEBAS] Misma tabla que §6.2.1 pero para `zerotrust_sesion_YYYYMMDD_HHMMSS`.

### 6.3.2 Métricas KPI — Escenario B

[TODO POST-PRUEBAS]

| Código | Valor esperado                    | Valor real | Evidencia |
|--------|-----------------------------------|------------|-----------|
| G1     | `(true, X s)` — Wazuh alerta     | [TODO]     | [TODO]    |
| G2     | ≤1 nodo accesible desde webapp   | [TODO]     | [TODO]    |
| G3     | `(true, Y%)` — hitos bloqueados  | [TODO]     | [TODO]    |
| E1     | ≤1 servicio visible              | [TODO]     | [TODO]    |
| E2     | 0 registros / 0 bytes exfiltrados | [TODO]     | [TODO]    |
| E3     | TLS cifrado o conexión rechazada  | [TODO]     | [TODO]    |

## 6.4 Comparativa A vs B

> **Nota:** completar con los valores reales de §6.3.2.

### 6.4.1 Tabla comparativa final

[TODO POST-PRUEBAS] Ver `tests/00_PLANTILLA_KPI_v2.md §3` — columnas A y B.

| Código | Escenario A            | Escenario B           | Mejora observada                              |
|--------|------------------------|-----------------------|-----------------------------------------------|
| G1     | `(false, ∞)`           | [TODO]                | [TODO]                                        |
| G2     | 3 nodos                | [TODO]                | [TODO]                                        |
| G3     | `(false, 0%)`          | [TODO]                | [TODO]                                        |
| E1     | 3/3 servicios          | [TODO]                | [TODO]                                        |
| E2     | ~766B / 3 reg + 1 cred | [TODO]                | [TODO]                                        |
| E3     | Texto claro            | [TODO]                | [TODO]                                        |

### 6.4.2 Análisis cuantitativo de la mejora

[TODO POST-PRUEBAS] Párrafo por métrica: qué mejoró, cuánto mejoró, qué mecanismo Zero Trust lo explica. Este análisis es la tesis central del TFG y el párrafo más importante de todo el documento.

### 6.4.3 Casos donde Zero Trust no mejoró o degradó el resultado

[TODO POST-PRUEBAS] Honestidad intelectual: si alguna métrica no resultó como se esperaba, documentarlo y razonarlo. El tribunal valora más la reflexión crítica honesta que los resultados perfectos.
