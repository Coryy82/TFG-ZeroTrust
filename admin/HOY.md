# HOY — 2026-06-10 (miércoles) · REDACCIÓN CAP. 6 + CAP. 4 (laboratorio cerrado)

> **Situación:** Fase 3 — Semana 3. **Hito 09/06 ✅** — KPIs §2/§3 cerrados; sesión oficial B `zerotrust_sesion_20260609_130120`; plantilla en `tests/00_PLANTILLA_KPI_v2.md`; diario §12.
> **Bloqueo resuelto:** `ejecutar_pruebas_ab` → DONE. **Bloqueo activo ahora:** memoria sin redactar (Cap. 6 esqueleto con `[TODO]`; Cap. 4 sin empezar).
> Plan IDs: `redactar_cap_3_4_5` (prioridad) → `redactar_eda_v0` (§2.7) → `preparar_reunion_tutor` (opcional)
> Fase: 3 de 4 · Semana 3 · **Próximo hito duro 14/06:** Caps. 3–6 en borrador + email tutor 60–70%.

---

## OBJETIVO DEL DÍA

1. **Convertir datos KPI en prosa:** redactar `06_pruebas.md` §6.1–§6.3 usando la plantilla cerrada y la sesión `130120` (sin volver al laboratorio).
2. **Recuperar agenda del 09/06:** arrancar `04_diseno.md` §4.1–§4.3 (al menos borrador de Escenario B).
3. **Cerrar deuda EdA:** §2.7 Trabajos relacionados (30–45 min).

---

## SI SOLO HACES UNA COSA

Redacta **§6.3 Resultados Escenario B** en `docs/03_memoria_tfg/06_pruebas.md` copiando valores verificados de `tests/00_PLANTILLA_KPI_v2.md` §2 y la tabla comparativa §3. Sin eso no hay corazón del TFG ni reunión con el tutor.

---

## CONTEXTO: QUÉ CAMBIÓ DESDE EL 08/06


| Tema                      | Estado anterior (reporte 08/06)  | Estado actual                                                    |
| ------------------------- | -------------------------------- | ---------------------------------------------------------------- |
| KPIs §2/§3                | En riesgo                        | ✅ Cerrados en plantilla                                          |
| Sesión ZT                 | Sin `zerotrust_sesion_`* oficial | ✅ `20260609_130120` (limpia, 2.º intento)                        |
| G1 Wazuh                  | Pendiente validar                | ✅ `(true, 22 s)` — regla 100100                                  |
| Cap. 6                    | No iniciado                      | Sigue en esqueleto — **tarea de hoy**                            |
| `logcapture_zerotrust.sh` | —                                | Fix CRLF + `.gitattributes` (no repetir pruebas salvo regresión) |


**Fuentes de verdad para redacción (no inventar):**

- `tests/00_PLANTILLA_KPI_v2.md` (§1 A, §2 B, §3 comparativa)
- `tests/logs/zerotrust_sesion_20260609_130120/` (evidencias)
- `docs/04_diario_laboratorio/20260609_Sesion_PruebasAB_Wazuh_Deteccion.md` §12

---

## BLOQUES DE TRABAJO

### Bloque 0 — 15 min · Alineación y cierre administrativo

- Leer `admin/STATE.md` y confirmar que no hay tareas de laboratorio pendientes
- Actualizar cabecera de `docs/03_memoria_tfg/06_pruebas.md`: §2/§3 ya no están "pendiente" — citar sesión `130120`
- (Opcional) Borrador de `admin/reportes/reporte_2026-06-10.md` con hito 09/06 cerrado — 10 min

---

### Bloque 1 — 4h · Cap. 6 Pruebas §6.1–§6.3 (`redactar_cap_3_4_5`) — PRIORIDAD MÁXIMA

Recupera tareas vencidas del **08/06** (agenda). No abrir §6.4 hoy salvo que §6.1–6.3 queden cerrados antes.

**§6.1 Metodología (1h)**

- §6.1.1 Entorno: Windows + WSL2, Docker Compose v2, scripts `logcapture_*.sh`
- §6.1.2 Protocolo: cadena pre-RCE + T0 + 4 hitos post-RCE + captura (igual en A y B)
- §6.1.3 T0_efectivo y ventana post-RCE — citar ADR 2026-05-12 y plantilla KPI v2

**§6.2 Escenario A (1h)** — la tabla ya está; convertir a prosa breve

- Completar narrativa alrededor de tablas existentes (sesión `perimetral_sesion_20260523_175204`)
- Párrafo por métrica G1–G3, E1–E3 con mecanismo perimetral (o ausencia)

**§6.3 Escenario B (2h)** — **corazón del día**

- §6.3.1 Cronología: T0 `13:14:08`, hitos de `session_chrono.txt` (7 líneas, 2.º intento)
- §6.3.2 Tabla KPI desde plantilla §2.1 — rutas `tests/logs/zerotrust_sesion_20260609_130120/`
- Párrafos honestos: G1 22 s; sin 100101/100104; reinicio mid-sesión documentado en §2.4 plantilla
- Mencionar controles: microsegmentación, mTLS 400, Flask `127.0.0.1`, Wazuh `process-webapp`
- Listar 2–3 rutas de evidencia clave para el tutor (`e1_scan.log`, `lateral.pcap`, `wazuh_alerts.json` L1)

**Hecho cuando:** §6.1–§6.3 sin `[TODO POST-PRUEBAS]`; figuras marcadas `[FIG:]` donde falten capturas.

---

### Bloque 2 — 3h · Cap. 4 Diseño §4.1–§4.3 (`redactar_cap_3_4_5`) — RECUPERACIÓN 09/06

Solo si Bloque 1 avanza bien; si no, dejar para mañana 11/06.

**Insumos:** `docs/01_investigacion/20260603_Prototipo_ZeroTrust.md`, diarios 03–09/06, `infra/zero_trust/docker-compose.yaml`

- §4.1 Visión general comparativa A vs B (misma app, distinto modelo de red) — 45 min
- §4.2 Escenario A: topología red plana + decisiones + 4 hitos — 1h (*insumo: prototipo perimetral*)
- §4.3 Escenario B: principios ZT → 3 zonas + mTLS + Wazuh `process-webapp` — 1h 15 min
- Marcar `[FIG:]` para diagramas (Mermaid o draw.io después)

**Hecho cuando:** §4.1–§4.3 con prosa continua (aunque §4.4–4.5 sigan en `[TODO]`).

---

### Bloque 3 — 45 min · EdA §2.7 (`redactar_eda_v0`)

- Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.7 "Trabajos relacionados" — 2–3 párrafos
- Posicionar este TFG: comparativa A/B **cuantitativa** + cadena HTB + laboratorio reproducible
- Fuentes locales: TFGs en `docs/01_investigacion/TFG_Otros/` (Jiménez, Vico, Torregrosa, G6508)
- Añadir 1–2 referencias a `99_bibliografia.md` si faltan

**Hecho cuando:** desaparece el único `[TODO]` de `02_estado_arte.md`.

---

### Bloque 4 (opcional, 1h) · Preparar reunión tutor

El tutor pidió cita cuando haya contenido redactado (`00_TIMELINE_CORREOS.md` §18).

- Actualizar §1.2 objetivos en `01_intro.md` o índice anotado con pregunta de investigación (ADR 2026-06-06)
- Dossier 1–2 páginas: pregunta + tabla KPI §3 + extracto §6.3 borrador
- Borrador email solicitud cita en despacho (no enviar hasta §6.3 legible)

---

## NO HACER HOY

- **No** repetir sesión de laboratorio ZT (KPI cerrado; evidencias limpias en `130120`).
- **No** abrir Overleaf (hito 14/06).
- **No** redactar Cap. 7 Conclusiones antes de tener §6.4 comparativa (agenda 10/06).
- **No** perfeccionar infra salvo regresión bloqueante (>2h → documentar y seguir redactando).
- **No** reabrir debate Wazuh vs Falco (cerrado 04/06).

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

- `06_pruebas.md` §6.3 Escenario B redactado con datos reales de plantilla §2
- `06_pruebas.md` §6.1 metodología redactada
- §2.7 EdA cerrado

**Mínimo absoluto (si el día se acorta):** solo §6.3 + §6.1.1–6.1.2.

**Stretch (día completo 8h+):** §6.2 prosa + §4.1–4.3 borrador + dossier tutor.

---

## CIERRE

Al terminar:

1. Actualizar `admin/STATE.md`: mover progreso en `redactar_cap_3_4_5`; marcar §2.7 si cerrado.
2. Si redactaste §6.3: anotar en `docs/04_diario_laboratorio/` un párrafo de cierre (o ampliar §12 con “redacción Cap. 6 iniciada”).
3. **Mañana 11/06 (agenda):** §6.4 comparativa A vs B (tabla §3 → prosa) + figuras Cap. 6.
4. Recordatorio: **14/06 en 4 días** — email tutor con memoria 60–70%.

