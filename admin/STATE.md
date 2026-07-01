# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-07-01

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
- **05/06 → 21/06: ~144h restantes** (12h/día × 0.75 fatiga × 16 días) — en uso; **2 días hasta depósito**

## 1. Resumen Semanal
- Commits últimos 7 días: **0 entradas** (24/06–01/07). Última actividad git: **20/06** (`085b983`, `6f2a252`, `fa452ff`).
- Avance técnico principal: **sin cambios.** Laboratorio ZT + Wazuh estable; sin commits en `infra/` ni `tests/` desde el 18/06.
- Avance de redacción/Overleaf: `Borrador1.2.tex` sin actualizaciones desde el 20/06. Marcadores abiertos verificados: **8× `FALTA TABLA`**, **4× `[FIG:]`**, **3× `[CITAR:]`**.
- Comunicación con tutor: PDF enviado 19/06 ✅. Sin respuesta a emails 16/06 ni 19/06. Sin entrada en bitácora posterior al 19/06.
- Días hasta próximo hito crítico: **deadline 21/06 vencido hace 10 días** — hito `revision_final_entrega` (depósito plataforma) **sin evidencia en repositorio**.

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: **FASE 4 — SEMANA 4** (15/06–21/06), **cerrada en calendario** (01/07). Objetivo de fase: memoria depositada — **no confirmado en repositorio**.
- Delta respecto al plan: hito 19/06 (PDF tutor) ✅; hitos 20/06 (repaso caps. 4–5) y 21/06 (depósito) **sin evidencia en commits ni bitácora** — **retrasado ≥10 días** respecto al plan.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO):
  - **ALTO:** convocatoria julio en riesgo — depósito del 21/06 sin trazabilidad en repo ni bitácora.
  - **ALTO:** inactividad git **11 días** (20/06→01/07); imposible inferir trabajo offline o depósito fuera del repositorio.
  - **MEDIO:** maquetación LaTeX incompleta en `Borrador1.2.tex` (tablas KPI cap. 6, figuras, BibTeX).
  - **MEDIO:** caps. 4–5 sin repaso documentado; tutor sin feedback (16/06, 19/06).
  - **BAJO:** labels de anexos placeholder (`anexo:protocolo_ejecucion`, `anexo:scripts_captura`).
- ¿Es necesario activar algún fallback? **No** (fallbacks técnicos Wazuh→Falco no aplican). Valorar **Plan C** (convocatoria septiembre, ADR 2026-05-24 / ROADMAP §Plan C) si el depósito no se realizó y no hay margen administrativo.

## 3. Bloqueos
- **Bloqueo activo:** ausencia de trazabilidad del depósito final y del trabajo post-20/06. Si el PDF se depositó el 21/06 fuera del repo, no consta en bitácora ni STATE — impide cerrar el sprint con confianza.
- **Bloqueo potencial:** maquetación incompleta en `Borrador1.2.tex` (tablas KPI, figuras, BibTeX) pudo impedir o retrasar el depósito. Mitigación: placeholders mínimos viables + depósito inmediato si aún pendiente.
- **Gestión:** respuesta del tutor pendiente; no bloquea depósito según directriz §6 del ROADMAP.

## 4. Tablero del Sprint Actual
### TODO
- [ ] **[HUMANO] `repaso_caps_4_5`** — Repaso redaccional caps. 4–5 (20/06): justificar decisiones, condensar detalle de montaje.
- [ ] **[HUMANO] `overleaf_figuras`** — Insertar figuras en marcadores `[FIG:]` (o placeholders) en Caps. 4–6.
- [ ] **[HUMANO] `overleaf_bibliografia`** — Convertir marcadores `[CITAR:]` a `\cite{}` y añadir entradas BibTeX.
- [ ] **[HUMANO] `revision_final_entrega`** — PDF final + depósito en plataforma el **21/06**.

### DOING
- *(vacío — sin actividad en curso evidenciada por commits desde 20/06)*

### DONE (Sprint Final — desde 24/05)
- [x] **`transferir_a_overleaf`** — Caps. 1–7 en `Borrador1.2.tex`; referencias internas (`\label`/`\cref`) cerradas. Commit `fa452ff`. Figuras/BibTeX/repaso 4–5 quedan en tareas TODO separadas. (2026-06-20)
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
| 20/06  | Repaso redaccional caps. 4–5                               | ⚠️ En riesgo — sin evidencia en commits; `Borrador1.2.tex` sin actualización posterior |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | ⚠️ En riesgo — deadline vencido hace 10 días; sin registro en bitácora ni commits post-20/06 |
