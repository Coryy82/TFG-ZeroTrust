# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-06-20

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
- **05/06 → 21/06: ~144h restantes** (12h/día × 0.75 fatiga × 16 días) — en uso; **1 día hasta depósito**

## 1. Resumen Semanal
- Commits últimos 7 días: **13 entradas** (13/06–20/06). Redacción caps. 1 y 7, transferencia Overleaf (`Borrador1.2.tex`), referencias internas LaTeX, envío PDF al tutor (19/06) y sincronización bitácora/timeline (20/06).
- Avance técnico principal: **sin cambios.** Comparativa KPI A↔B cerrada (09/06). Stack ZT + Wazuh operativo; laboratorio estable. Commit `7928aa0` (18/06) solo actualiza artefactos de sesión.
- Avance de redacción/Overleaf (19–20/06):
  - **Caps. 1–7 en Overleaf** (`Borrador1.2.tex` versionado en repo, commit `fa452ff`). ✅
  - **Referencias internas** (`\label` / `\cref`): marcadores sustituidos en `Borrador1.2.tex`. ✅
  - **Estado redaccional por capítulo:**
    - **Pulidos:** caps. 1–3 y 6–7 (enviados al tutor el 19/06).
    - **Pendiente repaso redaccional (hoy 20/06):** caps. 4–5 (Diseño, Desarrollo e implantación).
    - **Pendiente global:** tablas (`FALTA TABLA`), figuras (`[FIG:]`), bibliografía (`[CITAR:]`).
- Comunicación con tutor:
  - **19/06:** PDF `Borrador1.2.tex` enviado a Héctor. Bitácora y timeline §20 actualizados (commit `6f2a252`).
  - **16/06:** email caps. 2–6 — **sin respuesta a 16/06 ni 19/06.**
- Días hasta próximo hito crítico: **1** — 21/06 depósito en plataforma.

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: **FASE 4 — SEMANA 4** (15/06–21/06), día **20/06**. Objetivo del día: repaso caps. 4–5, tablas KPI, figuras/bibliografía mínimas viables.
- Delta respecto al plan: **en tiempo** en hitos mayores (PDF tutor 19/06 ✅, Overleaf operativo ✅). Retraso acotado en maquetación (tablas, figuras, BibTeX) y repaso caps. 4–5, planificado para hoy según agenda.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO):
  - **ALTO:** depósito en plataforma el **21/06** con tablas KPI del cap. 6 y figuras mínimas viables (placeholders aceptables).
  - **MEDIO:** caps. 4–5 menos pulidos que el resto; repaso de hoy debe condensar narrativa (seguridad, no manual Docker — directriz tutor §1–§2).
  - **MEDIO:** sin feedback del tutor (emails 16/06 y 19/06). Avanzar hacia depósito sin bloquearse.
  - **BAJO:** labels de anexos (`anexo:protocolo_ejecucion`, `anexo:scripts_captura`) referenciados pero anexos aún placeholder en LaTeX.
- ¿Es necesario activar algún fallback? **No.** Laboratorio estable, Wazuh operativo.

## 3. Bloqueos
- **Sin bloqueo técnico.** Caps. 1–7 en Overleaf; referencias internas cerradas en `Borrador1.2.tex`.
- **Gestión:** respuesta del tutor pendiente (16/06 y 19/06). No bloquea depósito; feedback se incorporará como ajuste puntual si llega antes del 21/06.
- Sin bloqueo de infraestructura ni laboratorio.

## 4. Tablero del Sprint Actual
### TODO
- [ ] **[HUMANO] `overleaf_figuras`** — Insertar figuras en marcadores `[FIG:]` (o placeholders) en Caps. 4–6.
- [ ] **[HUMANO] `overleaf_bibliografia`** — Convertir marcadores `[CITAR:]` a `\cite{}` y añadir entradas BibTeX.
- [ ] **[HUMANO] `revision_final_entrega`** — PDF final + depósito en plataforma el **21/06**.

### DOING
- [ ] **[HUMANO] `repaso_caps_4_5`** — Repaso redaccional caps. 4–5 (20/06): justificar decisiones, condensar detalle de montaje.

### DONE (Sprint Final — desde 24/05)
- [x] **`transferir_a_overleaf`** — Caps. 1–7 transferidos a `Borrador1.2.tex` / Overleaf; referencias internas (`\label` / `\cref`) cerradas. Figuras y BibTeX delegados a tareas específicas. (2026-06-19)
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
| 20/06  | Repaso redaccional caps. 4–5                               | 🔄 En progreso |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | ⚠️ En riesgo — 1 día; tablas KPI y maquetación pendientes |

## 6. Decisión editorial registrada (19/06)
Priorizar repaso de caps. 4–5 **después** del envío al tutor: coherente con hito 19/06, directrices del tutor (presentar primero pregunta/evidencia/conclusiones) y calendario. Evaluación completa en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` (entrada 2026-06-19).
