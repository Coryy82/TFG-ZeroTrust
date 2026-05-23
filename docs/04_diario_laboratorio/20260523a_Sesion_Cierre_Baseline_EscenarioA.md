# Sesión de cierre — Baseline cuantitativa del Escenario A (perimetral)

> **Fecha:** 23 de mayo de 2026
> **Propósito de este documento:** Registro cronológico e inmutable de la sesión en la que se cerró la baseline medible del Escenario A: se analizaron los artefactos de la sesión operativa `perimetral_sesion_20260523_175204`, se verificó el pcap con `tshark`, se integró el cierre de artefactos en el script `logcapture_perimetral.sh` y se rellenó completamente la sección §1 de [`tests/00_PLANTILLA_KPI_v2.md`](../../tests/00_PLANTILLA_KPI_v2.md).
>
> **Salidas operativas:** plantilla §1 completa + columna A de §3, script `logcapture_perimetral.sh` actualizado, este documento.

---

## Índice

1. [Punto de partida](#1-punto-de-partida)
2. [Análisis de la sesión operativa 20260523_175204](#2-análisis-de-la-sesión-operativa-20260523_175204)
3. [Verificación E3 — tshark sobre lateral.pcap](#3-verificación-e3--tshark-sobre-lateralpcap)
4. [Mejora del script logcapture_perimetral.sh](#4-mejora-del-script-logcapture_perimetralth)
5. [KPIs y cronología reconstruida](#5-kpis-y-cronología-reconstruida)
6. [Relleno de la plantilla KPI v2 §1](#6-relleno-de-la-plantilla-kpi-v2-1)
7. [Decisiones tomadas en esta sesión](#7-decisiones-tomadas-en-esta-sesión)
8. [Estado al cerrar la sesión](#8-estado-al-cerrar-la-sesión)

---

## 1. Punto de partida

Al abrir la sesión, el handoff [`20260512b_Handoff_Continuacion_Captura_EscenarioA.md`](20260512b_Handoff_Continuacion_Captura_EscenarioA.md) indicaba como tarea pendiente:

- **D5** — Cerrar la baseline cuantitativa del Escenario A antes de modificar la arquitectura comparativa.
- **T12** — Consolidar valores G1–G3, E1–E3 en `tests/00_PLANTILLA_KPI_v2.md`.

La sesión de ensayo anterior (`perimetral_sesion_20260512_155313_prueba`) había dejado `dump.txt` y `lateral.pcap` a 0 bytes, por lo que los KPIs post-RCE no estaban acreditados. El `reporte_2026-05-17.md` y `admin/STATE.md` señalaban el inicio del Escenario B como riesgo creciente por este bloqueo.

En la sesión de hoy el usuario ya había ejecutado la sesión operativa completa (`perimetral_sesion_20260523_175204`) antes de abrir el chat; la tarea de trabajo de esta sesión fue **auditar, verificar y documentar** esa sesión operativa.

---

## 2. Análisis de la sesión operativa 20260523_175204

### 2.1 Artefactos presentes y tamaños

| Fichero | Tamaño | Veredicto |
|---------|--------|-----------|
| `compose_up.log` | 4334 B | 4 servicios arrancados y healthy ✅ |
| `creds.txt` | 35 B | `DB_PASSWORD=supersecret` + `DB_HOST=db` ✅ |
| `e1_scan.log` | 814 B | backend:5000, db:5432, nginx:80 visibles ✅ |
| `lateral.json` | 304 B | 3 empleados en JSON ✅ |
| `dump.txt` | 427 B | `count=3` + 3 filas completas de `empleados` ✅ |
| `lateral.pcap` | 4096 B | Magic bytes `D4 C3 B2 A1` — pcap válido (verificado con tshark) ✅ |
| `nginx.log` | 673 KB | Traza completa del ataque ✅ |
| `webapp.log` | 572 KB | Access logs con todos los hitos pre-RCE y post-RCE ✅ |
| `backend.log` | 35 KB | Requests al backend ✅ |
| `db.log` | 6 KB | Actividad de Postgres ✅ |

Diferencia clave respecto a la sesión ensayo: **`dump.txt` y `lateral.pcap` tienen contenido real**.

### 2.2 Cronología pre-RCE reconstruida desde logs

Todos los timestamps en CEST (TZ=Europe/Madrid, confirmado por PS1 y Dockerfile). Fuentes: `webapp.log` y `nginx.log`.

| Hito | Hora CEST | Línea de log |
|------|-----------|--------------|
| Compose up — 4 servicios healthy | 17:52:16 | `compose_up.log` |
| `HEAD /` — banner grabbing (`curl -I`) | 17:52:55 | `nginx.log` línea 1 |
| Gobuster scan automático | 17:53:10–17:53:15 | `webapp.log` (User-Agent `gobuster/3.8.2`) |
| `GET /robots.txt` manual | 17:53:22 | `webapp.log` línea 4761 |
| `GET /backup.txt` → `admin:Empresa2026!` | 17:53:29 | `webapp.log` línea 4762 |
| `GET /admin/login` | 17:53:44 | `webapp.log` línea 4764 |
| `POST /admin/login` → 302 (login OK) | 17:53:50 | `webapp.log` línea 4765 |
| `GET /admin/diagnostico` (primera visita) | 17:53:53 | `webapp.log` línea 4767 |
| `?host={{7*7}}` → SSTI confirmado (49) | 17:54:27 | `webapp.log` línea 4769 |
| Reverse shell recibida (T0_efectivo) | 17:57:56 | `tests/RCE comandos y notas.txt` (PS1 `[17:57:56]`) |

### 2.3 Cronología post-RCE

| Hito | Hora aproximada CEST | Δ desde T0_efectivo |
|------|----------------------|---------------------|
| `env \| grep DB_` → creds.txt | ~17:58:20 | ~24 s (PS1 `[17:58:19]`) |
| `nmap` hacia backend/db/nginx | ~18:02:00 | ~244 s (timestamp en e1_scan.log) |
| `tcpdump ... host backend &` + `curl /empleados` | ~18:02:00 | ~244 s |
| `psql -h db -U postgres -d empresa_db` | ~18:02:30 | ~274 s |

**Limitación documentada:** los Δ post-RCE son orientativos al minuto. El único timestamp preciso es T0_efectivo (PS1 del listener) y el de nmap (encabezado del fichero de salida). Se anota en §1.4 de la plantilla.

---

## 3. Verificación E3 — tshark sobre lateral.pcap

Se ejecutó `tshark -r tests/logs/perimetral_sesion_20260523_175204/lateral.pcap` en WSL.

### Resultado

```
 1   0.000000  172.19.0.4 → 172.19.0.3  TCP   SYN → 5000
 4   0.000235  172.19.0.4 → 172.19.0.3  HTTP  GET /empleados HTTP/1.1
 8   0.012951  172.19.0.3 → 172.19.0.4  HTTP/JSON  HTTP/1.1 200 OK, JSON (application/json)
...
20  36.362699  172.19.0.4 → 172.19.0.3  HTTP  GET /empleados HTTP/1.1
24  36.373564  172.19.0.3 → 172.19.0.4  HTTP/JSON  HTTP/1.1 200 OK, JSON (application/json)
...
tshark: The file appears to have been cut short in the middle of a packet.
```

**32 paquetes** capturados. Tres transacciones TCP al backend (el usuario ejecutó `curl` varias veces). El aviso `cut short` es cosmético: ocurre porque `tcpdump` fue terminado durante la tercera transacción. Las dos primeras están completas y son suficientes como evidencia.

### Conclusión E3

- **Protocolo:** HTTP/1.1 sin TLS en ninguno de los 32 paquetes.
- **Visibilidad:** `GET /empleados HTTP/1.1` y el cuerpo de respuesta `JSON (application/json)` con nombres, emails, roles y salarios son completamente legibles por cualquier nodo en `perimetral_net_interna` sin necesidad de descifrado.
- **Valor E3 para Escenario A:** `texto claro` — confirmado empíricamente.
- **Implicación para memoria:** un atacante con acceso a la red interna (o cualquier contenedor en ella) puede realizar MITM pasivo y leer todos los datos en tránsito. El Escenario B deberá presentar mTLS o rechazo de conexión para contrastar.

---

## 4. Mejora del script logcapture_perimetral.sh

Se integró el paso §4.4 del handoff (copia de artefactos desde `webapp:/tmp/`) directamente en [`tests/scripts/logcapture_perimetral.sh`](../../tests/scripts/logcapture_perimetral.sh).

### Flujo anterior (5 pasos)

1. `compose up --build -d`
2. Pausa para ataque manual
3. Volcado logs por servicio
4. Volcado log combinado
5. Pregunta `compose down`

El paso de `docker compose cp` requería un **segundo terminal** o hacerse manualmente antes de pulsar ENTER.

### Flujo nuevo (5 pasos renumerados)

1. `compose up --build -d`
2. Pausa para ataque — lista los 5 artefactos esperados en `webapp:/tmp/`
3. **`docker compose cp` de los 5 artefactos** (`lateral.pcap`, `lateral.json`, `creds.txt`, `dump.txt`, `e1_scan.log`) con informe de bytes y aviso si quedan vacíos
4. Volcado logs por servicio + combinado
5. Pregunta `compose down`

**Garantía de orden:** la copia ocurre siempre antes de `compose down`, eliminando el riesgo de perder `/tmp/` por bajar el compose prematuramente.

El script fue reescrito con finales de línea LF (el original tenía CRLF que causaba el error `env: $'bash\r': No such file or directory` en WSL).

---

## 5. KPIs y cronología reconstruida

### Métricas oficiales — Escenario A

| Cód. | Valor | Fuente |
|------|-------|--------|
| G1 | `(false, ∞)` | nginx.log + webapp.log: solo access logs, ninguna alerta ni SIEM |
| G2 | 3 nodos (webapp → backend → db) | e1_scan.log + lateral.json + dump.txt |
| G3 | `(false, 0 %)` | curl 200 OK (lateral.json) + psql 3 rows (dump.txt) — ningún bloqueo |
| E1 | 3/3 servicios visibles desde webapp | e1_scan.log (backend:5000, db:5432, nginx:80) |
| E2 | 3 reg. empleados + 1 cred. DB / ~766 B / 3 archivos | lateral.json (304 B) + dump.txt (427 B) + creds.txt (35 B) |
| E3 | texto claro | lateral.pcap (tshark: HTTP/JSON sin TLS, pkts 4, 8, 20, 24) |

### KPIs adicionales HTB

| Métrica | Valor |
|---------|-------|
| Nº pasos previos al RCE | 5 (recon HTTP → robots.txt → backup.txt → login → SSTI confirm) |
| Nº endpoints con filtrado de información | 2 (`/robots.txt` → rutas; `/backup.txt` → credenciales) |
| Nº CWE distintos materializables | 4 (CWE-1336, CWE-200, CWE-306, CWE-522) |

---

## 6. Relleno de la plantilla KPI v2 §1

Se completaron íntegramente las secciones siguientes de [`tests/00_PLANTILLA_KPI_v2.md`](../../tests/00_PLANTILLA_KPI_v2.md):

- **§1 encabezado:** sesión `perimetral_sesion_20260523_175204`, commit `c72d80b`, compose v2.
- **§1.1** Métricas oficiales G1–G3, E1–E3 con valores y rutas de evidencia.
- **§1.2.a** Cronología pre-RCE con horas absolutas y Δ reconstruidos desde los logs.
- **§1.2.b** Cronología post-RCE con T0_efectivo=17:57:56 y Δ aproximados al minuto.
- **§1.3** KPIs HTB: pasos, endpoints, CWE.
- **§1.4** Observaciones: sesión marcada oficial, PTY parcial, limitación de precisión en Δ post-RCE, nota sobre cut-short del pcap, nota sobre gobuster extra.
- **§3** Columna Escenario A del cuadro comparativo final (columna B pendiente de Escenario B).

Las secciones §2 y §3 columna B permanecen en blanco para la sesión de Zero Trust.

---

## 7. Decisiones tomadas en esta sesión

### D-20260523-1 — Sesión 20260523_175204 como oficial; 20260512 como ensayo

La sesión `perimetral_sesion_20260512_155313_prueba` queda etiquetada como ensayo. La sesión `perimetral_sesion_20260523_175204` es la **sesión oficial** del Escenario A, que respalda todos los valores KPI de la plantilla.

**Razón:** la sesión prueba tenía `dump.txt` y `lateral.pcap` a 0 bytes; la sesión de hoy tiene todos los artefactos con contenido verificado.

### D-20260523-2 — T0_efectivo fijado en 17:57:56 CEST

Criterio: primera línea de PS1 con timestamp visible en el listener (`[17:57:56] root@webapp:/app#` en `tests/RCE comandos y notas.txt`). Este es el instante en que la shell inversa quedó operativa y bajo control del atacante.

### D-20260523-3 — Δ post-RCE orientativos al minuto (documentado, no penalización)

Los comandos dentro de la shell no dejan timestamps en `webapp.log`. Solo `e1_scan.log` aporta un timestamp de `nmap` (`18:02 CEST`). Se anota en §1.4 como limitación metodológica. En el Escenario B se puede mejorar esto con un `script -t` o similar si se desea precisión al segundo.

### D-20260523-4 — Gobuster no cuenta como paso HTB canónico

El scan de gobuster aparece en los logs (`UA: gobuster/3.8.2`), pero no forma parte de la cadena narrativa de la plantilla. La tabla §1.2.a refleja únicamente los hitos manuales definidos en la plantilla. Se anota en §1.4.

---

## 8. Estado al cerrar la sesión

### COMPLETADO hoy

- [x] Auditoría completa de artefactos de `perimetral_sesion_20260523_175204`.
- [x] Verificación de `lateral.pcap` con `tshark` — E3 confirmado como texto claro.
- [x] Integración de `docker compose cp` en `logcapture_perimetral.sh` (nuevo paso [2/5]).
- [x] Corrección de CRLF en `logcapture_perimetral.sh` (error `bash\r` en WSL).
- [x] Relleno de `tests/00_PLANTILLA_KPI_v2.md` §1 completo + §3 columna A.
- [x] **T12 cerrado** — baseline cuantitativa del Escenario A consolidada y defendible.
- [x] **D5 cerrado** — evidencias curadas y vinculadas a cada KPI.

### PENDIENTE (próxima sesión)

Según `admin/STATE.md` y `admin/ROADMAP.md`, el siguiente bloque de trabajo es el Escenario B (Zero Trust). El roadmap de mayo ya está en riesgo; conviene arrancar sin más demora:

| Tarea | Referencia |
|-------|-----------|
| T13 — Especificación mínima del Escenario B: controles ZT contra cada hito post-RCE de A | `admin/STATE.md` §4 TODO |
| T14 — Iniciar prototipo `infra/zerotrust/`: separación Web/BBDD, políticas de red, criterio de bloqueo verificable | `admin/STATE.md` §4 TODO |
| T15 — Estudiar despliegue mínimo de Wazuh/SIEM en Docker Compose; decidir eventos obligatorios para G1/G3 | `admin/STATE.md` §4 TODO |
| T16 — Esqueletos de "Estado del Arte" y "Diseño de la Solución" en memoria | `admin/STATE.md` §4 TODO |
| T17 — Protocolo de pruebas A/B post-RCE: comandos, tiempos, evidencias esperadas | `admin/STATE.md` §4 TODO |

**Primer paso concreto recomendado para la próxima sesión:** T13 — mapear los cuatro hitos post-RCE de §1.2.b (`T_exfil_creds`, `T_lateral`, `T_e3_pcap`, `T_objetivo`) contra los controles Zero Trust que los deberían bloquear o detectar, y plasmarlos como requisitos de diseño de `infra/zerotrust/`.

---

## Referencias

| Recurso | Ruta |
|---------|------|
| Sesión operativa oficial | `tests/logs/perimetral_sesion_20260523_175204/` |
| Plantilla KPI v2 (§1 completo) | [`tests/00_PLANTILLA_KPI_v2.md`](../../tests/00_PLANTILLA_KPI_v2.md) |
| Script logcapture actualizado | [`tests/scripts/logcapture_perimetral.sh`](../../tests/scripts/logcapture_perimetral.sh) |
| Handoff anterior (referencia) | [`20260512b_Handoff_Continuacion_Captura_EscenarioA.md`](20260512b_Handoff_Continuacion_Captura_EscenarioA.md) |
| Notas RCE operativas | `tests/RCE comandos y notas.txt` |
| Notas POST-RCE operativas | `tests/POST-RCE comandos y notas.txt` |
| STATE.md actualizado | [`admin/STATE.md`](../../admin/STATE.md) |
| Commit de cierre | `c72d80b` |
