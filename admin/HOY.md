# HOY — 2026-06-12 (viernes) · CAP. 5 + RECUPERAR CAP. 3

> **Situación:** Fase 3 — Semana 3. **Hito 09/06 ✅** · **Cap. 6 ✅** (§6.1–§6.4 redactados; commit `57c08d6`).
> **Deuda del 11/06:** Cap. 3 sin empezar (agenda 11/06 lo pospuso tras §6.4). Figuras `[FIG:]` Cap. 6 pendientes.
> **Bloqueo activo:** hito **14/06 en 2 días** — faltan Cap. 3, Cap. 5 y cierre §4.5 para email tutor 60–70%.
> Plan IDs: `redactar_cap_3_4_5` (prioridad) → `setup_overleaf` + `envio_tutor_14_06` (14/06)
> Fase: 3 de 4 · Semana 3 · **Próximo hito duro 14/06:** Caps. 3–6 en borrador + email tutor + Overleaf.

---

## OBJETIVO DEL DÍA

1. **Agenda del 12/06:** redactar `05_desarrollo_implantacion.md` §5.1–§5.4 (IaC, Escenario A, Escenario B, problemas de integración).
2. **Recuperar deuda del 11/06:** `03_analisis_problema.md` §3.1–§3.4 (modelo amenazas ya validado — expandir a prosa).
3. **Cierre menor:** §4.5 limitaciones en `04_diseno.md` (quitar `[TODO]` del esqueleto; texto [IA] ya existe).

---

## SI SOLO HACES UNA COSA

Redacta **§5.3 Escenario B** en `docs/03_memoria_tfg/05_desarrollo_implantacion.md`: sustituir `[TODO POST-IMPL]` por lo ya implementado (3 zonas, mTLS, Wazuh `process-webapp`, reglas 100100–100104). Fuentes: diarios `20260603`–`20260609`, `infra/zero_trust/`, ADR en `admin/DECISIONS_LOG.md`.

---

## CONTEXTO: QUÉ CAMBIÓ DESDE EL 10/06

| Tema | Estado 10/06 | Estado actual (12/06) |
|------|--------------|------------------------|
| Cap. 6 §6.1–§6.3 | ✅ | ✅ Sin cambios |
| Cap. 6 §6.4 | ❌ Pendiente | ✅ Cerrado + revisión autor (G3 → «bloqueo comandos desde reverse shell») |
| EdA §2.7 | ✅ | ✅ |
| Cap. 4 §4.1–4.3 | ✅ prosa [IA/HUMANO] | ✅; §4.5 texto [IA], esqueleto `[TODO]` |
| Cap. 3 | Sin empezar | **Pendiente — deuda 11/06** |
| Cap. 5 | Sin empezar | **Prioridad agenda hoy** |
| Figuras Cap. 6 | — | `[FIG:]` sin resolver (no bloquea borrador texto) |
| Hito 14/06 | 4 días | **2 días — en riesgo alto** |

**Commits recientes (referencia):**

- `57c08d6` (12/06): Cap. 6 comparativa §6.4 + revisiones editoriales
- `4bff085`–`05cb338` (10/06): Caps. 4 y 6 parciales, EdA §2.7, STATE/reporte
- `f6be9c3` (09/06): Wazuh `process-webapp`, KPI sesión `130120`

**Diario de la sesión anterior:** `docs/04_diario_laboratorio/20260611_Sesion_Redaccion_Cap6_Comparativa.md`

**Fuentes de verdad para Cap. 5 (no inventar):**

- `docs/04_diario_laboratorio/` (perimetral, ZT, Wazuh, pruebas A/B)
- `infra/perimetral/` y `infra/zero_trust/`
- `tests/scripts/logcapture_*.sh`
- `admin/DECISIONS_LOG.md` (ADR mTLS, Wazuh Docker, process-webapp)

**Fuentes para Cap. 3:**

- `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md` §3 (modelo amenazas — 5 puntos)
- Skeleton verbatim en `03_analisis_problema.md` §3.2 (validado tutor 09/04/2026)
- Terminología KPI alineada con Cap. 6 (G3 = bloqueo comandos desde reverse shell)

---

## BLOQUES DE TRABAJO

### Bloque 0 — 15 min · Alineación

- Leer `admin/STATE.md` (desactualizado respecto a §6.4 — actualizar al cierre del día)
- Confirmar: sin tareas de laboratorio pendientes
- Crear `admin/reportes/reporte_2026-06-12.md` al cierre

---

### Bloque 1 — 4h · Cap. 5 Desarrollo e Implantación (`redactar_cap_3_4_5`) — PRIORIDAD AGENDA

**§5.1 Infraestructura como código (45 min)**

- Docker Compose v2, Git, `docker compose up --build -d`
- Scripts `logcapture_perimetral.sh` / `logcapture_zerotrust.sh`

**§5.2 Escenario A (1h)**

- 4 servicios, vulnerabilidades intencionales (CWEs de la cadena HTB)
- Sesión oficial `perimetral_sesion_20260523_175204`

**§5.3 Escenario B (2h)** — corazón del bloque

- 3 zonas Docker, secretos por servicio, mTLS OpenSSL + Nginx PEP
- Wazuh manager + agente, `process-webapp`, reglas post-RCE
- Referencias a anexos para YAML/nginx largos — no pegar configs completas en cuerpo

**§5.4 Problemas de integración (45 min)**

- 3–5 casos reales desde diarios: CRLF scripts, Flask `127.0.0.1`, Wazuh poll 2 s, docker-desktop/WSL2, orden ZT→Wazuh en `logcapture_zerotrust.sh`

**Hecho cuando:** Cap. 5 sin `[TODO]` / `[TODO POST-IMPL]` en §5.1–5.4.

---

### Bloque 2 — 3h · Cap. 3 Análisis del Problema — RECUPERACIÓN 11/06

**Insumos:** directrices tutor §3; skeleton §3.2 ya validado.

- §3.1 Descripción del problema (2 párrafos [HUMANO]): red plana post-RCE, pregunta de investigación (ADR 06/06)
- §3.2 Modelo de amenazas: expandir skeleton a prosa (atacante, activos, superficie, alcance/fuera alcance)
- §3.3 Requisitos: traducir amenazas en criterios verificables (diseño + pruebas)
- §3.4 KPIs: **definición** de los 6 indicadores (aquí G/E; en Cap. 6 van los **resultados**)

**Hecho cuando:** Cap. 3 sin `[TODO]` en §3.1–3.4.

---

### Bloque 3 — 1h · Cierre Cap. 4 §4.5 + figuras Cap. 6 (mínimo)

- §4.5: eliminar `[TODO]` del esqueleto; conservar texto [IA] (3 párrafos limitaciones)
- Figuras Cap. 6: insertar **2–3 capturas clave** mínimas para PDF tutor (nmap ZT, lateral 400, opcional tshark A) — el resto puede quedar `[FIG:]` para Overleaf

---

### Bloque 4 (opcional, 1h) · Preparar hito 14/06

- Borrador `01_intro.md` §1.2 con pregunta de investigación (sustituir «demostrar cuantitativamente»)
- Lista de capítulos listos para adjuntar al email tutor
- Esbozo proyecto Overleaf (cuenta + plantilla ETSINF — no transferir aún)

---

## NO HACER HOY

- **No** repetir sesión de laboratorio (KPI y evidencias cerradas).
- **No** redactar Cap. 7 Conclusiones (agenda 15–16/06).
- **No** transferencia masiva a Overleaf (hito 14/06; hoy solo esbozo si hay tiempo).
- **No** reabrir §6.4 salvo typo crítico.
- **No** perfeccionar todas las figuras del Cap. 6 (priorizar texto Caps. 3 y 5).

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

- `05_desarrollo_implantacion.md` §5.1–5.4 en borrador [HUMANO/IA]
- `03_analisis_problema.md` §3.1–3.2 al menos (§3.3–3.4 si hay tiempo)

**Mínimo absoluto (si el día se acorta):** solo §5.3 Escenario B + §3.1–3.2.

**Stretch (día completo 8h+):** Cap. 3 completo + §4.5 + 3 figuras Cap. 6 + borrador §1.2.

---

## CIERRE

Al terminar:

1. Actualizar `admin/STATE.md`: Cap. 6 §6.4 → DONE; avance Cap. 3 y 5; hito 14/06 con días restantes.
2. Ampliar o crear entrada en `docs/04_diario_laboratorio/` si hubo decisiones de redacción relevantes.
3. **Mañana 13/06 (agenda):** buffer — repaso `[TODO]` en caps. 3–6, `[CITAR:]`, lista figuras Overleaf.
4. Recordatorio: **14/06 en 2 días** — email tutor 60–70% + `setup_overleaf` + PDF borrador caps. 3–6.
