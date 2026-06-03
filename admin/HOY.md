# HOY — 2026-06-03 (miércoles) · DÍA DE RECUPERACIÓN

> **Situación:** 2 días de retraso técnico. El docker-compose del Escenario B y el mTLS estaban previstos para 02/06 y 03/06 respectivamente. El checkpoint Wazuh es **mañana 04/06 a las 20:00**.
> Plan ID: `implementar_escenario_b`
> Fase: 2 de 4 · Semana 2

---

## OBJETIVO DEL DÍA

Tener `infra/zero_trust/` levantando con las 3 redes aisladas y los servicios corriendo healthy.
Ese es el prerequisito bloqueante para todo lo demás, incluido Wazuh mañana.

---

## SI SOLO HACES UNA COSA

Escribe `infra/zero_trust/docker-compose.yaml` con las 3 redes (`web_zone`, `backend_zone`, `db_zone`) y verifica que `webapp` NO puede hacer ping a `db`. Con eso el camino crítico de mañana sigue abierto.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 3h · docker-compose base
- [ ] Crea `infra/zero_trust/docker-compose.yaml` con los 4 servicios (nginx, webapp, backend, db) y las 3 redes separadas
  - `web_zone`: nginx + webapp
  - `backend_zone`: webapp + backend
  - `db_zone`: backend + db
- [ ] Copia y adapta los Dockerfiles y configs de `infra/perimetral/` al nuevo directorio
- **Hecho cuando:** `docker compose up --build -d` levanta sin errores y los 4 servicios están healthy

### Bloque 2 — 2h · verificación de segmentación
- [ ] Desde dentro del contenedor `webapp`, intenta `ping db` o `curl db:5432` → debe fallar
- [ ] Verifica que `webapp → backend → db` funciona correctamente (la app sigue sirviendo datos)
- [ ] Documenta el resultado en `docs/04_diario_laboratorio/20260603_Sesion_ZT_DockerCompose.md` (breve, 15 min)
- **Hecho cuando:** la segmentación bloquea el acceso directo `webapp → db` y la app funciona

### Bloque 3 — 3h · mTLS webapp↔backend (lo que dé de sí)
- [ ] Genera CA + certificados con OpenSSL:
  ```
  openssl req -x509 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 365 -nodes
  openssl req -newkey rsa:4096 -keyout server.key -out server.csr -nodes
  openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365
  ```
- [ ] Configura Nginx o Caddy en `backend` para exigir certificado cliente
- [ ] Si terminas: configura `webapp` para presentar el cert en sus llamadas al backend
- **Hecho cuando:** `curl` con cert cliente a `backend` devuelve 200; sin cert devuelve error TLS

### Bloque 4 — 1h · commit + preparar mañana
- [ ] `git add infra/zero_trust/ docs/04_diario_laboratorio/ && git commit -m "Escenario B: docker-compose 3 redes + segmentación verificada"`
- [ ] Anota en papel o en un `.txt` los comandos exactos que has usado hoy (los necesitarás para el diario y para el Cap. 5)
- [ ] Lee el bloque del 04/06 en `admin/AGENDA_SPRINT_DIARIA.md` para saber qué necesitas tener listo antes del checkpoint de las 20:00

---

## NO HACER HOY

- No toques Wazuh hoy (es para mañana; si lo intentas antes de tener el compose estable, perderás tiempo doble)
- No redactes memoria ni EdA (eso es semana 3)
- No perfecciones los certs TLS si el Bloque 3 se atasca más de 2h: deja un placeholder y avanza. El mTLS puede completarse mañana mañana antes del checkpoint
- No abras más de 2 terminales a la vez

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

El día es exitoso si al terminar puedes marcar esto:

- [ ] `docker compose up` en `infra/zero_trust/` levanta los 4 servicios healthy
- [ ] `webapp` no alcanza `db` directamente (segmentación verificada)
- [ ] Hay un commit con el progreso en `main`

Cualquier avance en mTLS es bonus, no obligatorio.

---

## CIERRE

Al terminar:
1. Commit con lo avanzado aunque esté incompleto.
2. Copia el bloque `### 2026-06-04` de `admin/AGENDA_SPRINT_DIARIA.md` en este archivo para mañana.
3. Recuerda: **mañana a las 20:00 es el checkpoint Wazuh**. Si a esa hora no tienes agent enrollado y ≥1 alerta → activar Falco (ver ADR en `admin/DECISIONS_LOG.md`).
