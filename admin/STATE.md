# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-06-21

## 0. CAMBIO CRÍTICO DE OBJETIVO (2026-05-24)

> **Nuevo deadline: 21/06/2026** (convocatoria de julio).
> El plan original orientado a septiembre ha quedado archivado en `admin/ROADMAP_v1_archivado.md`.
> El plan activo es `admin/ROADMAP_v2_sprint_final.md`.
> ADR correspondiente registrado en `admin/DECISIONS_LOG.md` (entrada 2026-05-24).

> **Referencia estructural de la memoria:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/EstucturayContenidodeunTFG.md` es la fuente principal para cualquier decisión sobre la estructura de la memoria (ADR 2026-06-12 en `admin/DECISIONS_LOG.md`).

> **Política editorial de la memoria:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/Recomendaciones-Escritura-TFG.md` tiene prioridad máxima en cualquier decisión de redacción; el perfil de estilo del autor está en `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/perfil_escritura_autor.md` (ADR 2026-06-13 en `admin/DECISIONS_LOG.md`).

Capacidad efectiva restante:
- 24/05 → 01/06: ~9-12h (1-2h/día) — consumido
- 02/06 → 04/06: ~36h (12h/día × 3 días) — consumido
- **05/06 → 21/06: ~144h restantes** (12h/día × 0.75 fatiga × 16 días) — en uso; **0 días hasta depósito (hoy)**

## 1. Resumen Semanal
- Commits últimos 7 días: **12 entradas.** Redacción final (caps. 1 y 7, refinamiento cap. 6), plantilla y borrador Overleaf (`Borrador1.2.tex`), envío PDF al tutor (19/06), actualización bitácora/timeline (20/06). Sin commits el 21/06 aún.
- Avance técnico principal: **sin cambios.** Commit `7928aa0` (18/06) actualiza claves cliente y logs sesión ZT; comparativa KPI A↔B cerrada (09/06). Stack ZT + Wazuh operativo.
- Avance de redacción principal:
  - **Caps. 1–7 en Overleaf** (`Borrador1.2.tex`) — versionado en repo el 20/06 (`fa452ff`). ✅
  - **Referencias internas** (`\label` / `\cref`) cerradas en borrador principal. ✅
  - **PDF enviado al tutor** el 19/06 (hito cumplido). ✅
  - **Pendiente al cierre del 20/06 (sin evidencia en commits):** repaso caps. 4–5; **8× `FALTA TABLA`**, **5× `[FIG:]`**, **4× `[CITAR:]`** aún en `Borrador1.2.tex`.
- Días hasta próximo hito crítico: **0** — **21/06 depósito en plataforma ETSINF (hoy).**

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: **FASE 4 — SEMANA 4** (15/06–21/06), **día 21/06 — entrega final.**
- Delta respecto al plan: hitos 19/06 (PDF tutor) ✅; día 20/06 (repaso 4–5 + pasada 2) **no evidenciado en commits**; día 21/06 (depósito) **pendiente a primera hora del día**.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO):
  - **ALTO:** depósito **hoy 21/06** con tablas KPI, figuras y citas aún abiertas en `Borrador1.2.tex`. Estrategia: placeholders mínimos viables + tablas cap. 6 desde `tests/00_PLANTILLA_KPI_v2.md`.
  - **ALTO:** repaso caps. 4–5 planificado 20/06 **no cerrado** según commits ni estado del `.tex`. Impacto: menor homogeneidad narrativa en diseño/implementación.
  - **MEDIO:** sin respuesta del tutor (emails 16/06 y 19/06). No bloquea depósito.
  - **BAJO:** labels de anexos (`anexo:protocolo_ejecucion`, `anexo:scripts_captura`) referenciados pero anexos placeholder.
- ¿Es necesario activar algún fallback? **No.** Laboratorio estable; riesgo es exclusivamente editorial/maquetación.

## 3. Bloqueos
- **Sin bloqueo técnico.** Laboratorio y stack ZT operativos.
- **Bloqueo potencial — maquetación LaTeX:** 8 tablas, 5 figuras y 4 citas sin resolver en `Borrador1.2.tex`. Mitigación: tablas KPI prioritarias + placeholders `\fbox` para figuras + `\cite{}` mínimo en caps. 2 y 6 (plan HOY 20/06).
- **Gestión:** respuesta del tutor pendiente. No bloquea depósito.

## 4. Tablero del Sprint Actual
### TODO
- [ ] **[HUMANO] `repaso_caps_4_5`** — Repaso redaccional caps. 4–5 (20/06): justificar decisiones, condensar detalle de montaje.
- [ ] **[HUMANO] `overleaf_figuras`** — Insertar figuras en marcadores `[FIG:]` (o placeholders) en Caps. 4–6.
- [ ] **[HUMANO] `overleaf_bibliografia`** — Convertir marcadores `[CITAR:]` a `\cite{}` y añadir entradas BibTeX.
- [ ] **[HUMANO] `revision_final_entrega`** — PDF final + depósito en plataforma el **21/06**.

### DOING
- [ ] **[HUMANO] `transferir_a_overleaf`** — Caps. 1–7 transferidos ✅; referencias internas en `Borrador1.2.tex` ✅; versionado repo 20/06 ✅. Pendiente: tablas, figuras, BibTeX, repaso 4–5.

### DONE (Sprint Final — desde 24/05)
- [x] **`envio_tutor_19_06`** — PDF compilado (`Borrador1.2.tex`) enviado al tutor el 19/06. Alcance declarado: caps. 1–3 y 6–7 pulidos; 4–5 y tablas/figuras pendientes. Timeline §20, bitácora 19/06. (2026-06-19)
- [x] **`overleaf_referencias_internas`** — `\label` y `\cref{}` en `Borrador1.2.tex`: marcadores `[SUSTITUIR REFERENCIA LATEX]` y `[SUSTITUIR POR REFERENCIAS LATEX]` sustituidos; labels solo en secciones referenciadas. (2026-06-19)
- [x] **`setup_overleaf`** — Caps. 1–7 en `Borrador1.2.tex` / Overleaf. (2026-06-19)
- [x] **`envio_tutor_16_06`** — Email al tutor el 16/06 con caps. 2–6 en plantilla ETSINF (sin Intro/Conclusiones en adjunto). Reorientación pregunta de investigación; duda §5.4; solicitud cita presencial. Registrado en timeline §19 y bitácora 16/06. (2026-06-16)
- [x] **`redactar_intro_conclusiones`** — Caps. 1 y 7 en borrador [HUMANO]: §1.1–§1.5 (pregunta de investigación, hipótesis, metodología, estructura) y §7.1–§7.4 (conclusiones, limitaciones, trabajo futuro, ODS). Commits `3d65bc0`, `684a809`. (2026-06-17)
- [x] **`redactar_cap_4_completo`** — `04_diseno.md` §4.1–§4.5 redactados [HUMANO]. Commit `3ff326b`. (2026-06-14)
- [x] **`redactar_cap_3`** — `03_analisis_problema.md` §3.1–§3.4 redactados [HUMANO]. Commit `381658a`. (2026-06-12)
- [x] **`redactar_cap_5`** — `05_desarrollo_implantacion.md` §5.1–§5.5 redactados [HUMANO]. Commit `d7c30db`. (2026-06-12)
- [x] **`redactar_cap_6`** — `06_pruebas.md` §6.1–§6.4 redactados [HUMANO] con sesión `130120`. (2026-06-12)
- [x] **`redactar_eda_v0`** — Estado del Arte v0 cerrado. (2026-06-10)
- [x] **`ejecutar_pruebas_ab`** — Comparativa A↔B cerrada. Sesión oficial B `zerotrust_sesion_20260609_130120`. (2026-06-09)
- [x] **`email_tutor_31_05`** — Índice anotado enviado al tutor el 06/06/2026. (2026-06-06)
- [x] **`wazuh_fase5_escenario_b`** — Fase 5 Wazuh completada. (2026-06-04)
- [x] **`implementar_escenario_b`** — `infra/zero_trust/` completado. (2026-06-04)

*(Hitos anteriores del sprint: ver commits y `admin/ROADMAP_v2_sprint_final.md`.)*

## 5. Hitos críticos del Sprint Final
| Fecha  | Hito                                                       | Estado   |
|--------|------------------------------------------------------------|----------|
| 06/06  | Borrador índice anotado enviado al tutor (recuperación 31/05) | ✅ Completado — validación general positiva; matizar objetivos |
| 04/06  | Checkpoint Wazuh (20:00)                                   | ✅ Completado — Wazuh operativo |
| 09/06  | Escenario B funcional + KPIs §2/§3 cerrados                | ✅ Completado — sesión `130120` |
| 14/06  | Caps. 3, 4, 5, 6 en borrador + email tutor                 | ⚠️ Parcial — texto ✅; email tutor **16/06** |
| 16/06  | Caps. 1 y 7 redactados                                     | ✅ Completado — 17/06 |
| 19/06  | PDF compilado en Overleaf + email final al tutor           | ✅ Completado — PDF `Borrador1.2.tex` enviado; caps. 4–5 y figuras/tablas pendientes |
| 20/06  | Repaso redaccional caps. 4–5                               | ⚠️ En riesgo — sin evidencia en commits; marcadores abiertos en `.tex` |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | ⚠️ En riesgo — día de entrega; depósito pendiente |

## 6. Decisión editorial registrada (19/06)
Priorizar repaso de caps. 4–5 **después** del envío al tutor: coherente con hito 19/06, directrices del tutor (presentar primero pregunta/evidencia/conclusiones) y calendario. Evaluación completa en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` (entrada 2026-06-19).
