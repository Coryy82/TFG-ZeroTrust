# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-06-17

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
- **05/06 → 21/06: ~144h restantes** (12h/día × 0.75 fatiga × 16 días)

## 1. Resumen Semanal
- Commits últimos 7 días: **16 entradas** (10/06–17/06). Sin commits en `infra/` o `tests/`; foco en redacción final (Caps. 1 y 7), plantilla Overleaf local y refinamiento Cap. 6.
- Avance técnico principal: **sin cambios.** Comparativa KPI A↔B cerrada (09/06). Stack ZT + Wazuh operativo; laboratorio estable.
- Avance de redacción principal (10–17/06):
  - **Cap. 1** `01_intro.md`: §1.1–§1.5 redactados [HUMANO] con pregunta de investigación, hipótesis, metodología y estructura. Commits `3d65bc0`, `684a809` (17/06).
  - **Cap. 7** `07_conclusiones.md`: §7.1–§7.4 redactados con análisis cuantitativo, limitaciones, trabajo futuro y ODS. Commit `3d65bc0` (17/06). Pendiente: revisión estilo [IA→HUMANO] y nombres reales de asignaturas en §7.4.1.
  - **Overleaf:** borrador local `borradorplantillatfgoverleaf.tex` (plantilla ETSINF, ~780 líneas). Commit `aa1d73c` (17/06). Sin evidencia de proyecto Overleaf online ni compilación verificada.
  - **Cap. 6** `06_pruebas.md`: refinamiento §6 (11 líneas adicionales). Commit `735133a` (17/06).
- Días hasta próximo hito crítico: **2 días** — 19/06 email tutor con PDF compilado completo.

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: **FASE 4 — SEMANA 4** (15/06–21/06), día 17/06. Objetivo de la semana: memoria compilada, revisada y entregada. Agenda del día: transferir EdA + Caps. 3 y 4 a Overleaf.
- Delta respecto al plan: redacción **adelantada/recuperada** (Caps. 1 y 7 cerrados en borrador el 17/06). Comunicación con tutor **retrasada** (hito 14/06 sin email enviado; `BITACORA_REUNIONES.md` sin entrada posterior al 06/06). Overleaf **parcial** (plantilla .tex local, no proyecto online). Figuras `[FIG:]` (~32 marcadores en Caps. 4–6) sin resolver.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO):
  - **ALTO:** hito 14/06 incumplido — email tutor con memoria 60–70% no enviado (3 días vencido). Sin feedback del tutor sobre núcleo cuantitativo antes del PDF final.
  - **ALTO:** hito 19/06 en riesgo — faltan 2 días; no hay PDF compilado ni proyecto Overleaf operativo; solo borrador .tex local.
  - **MEDIO:** ~32 marcadores `[FIG:]` en Caps. 4–6 sin insertar; degradan calidad del PDF pero no bloquean compilación con placeholders.
  - **BAJO:** bloques `[IA - REVISAR]` en Cap. 7 y citas `[CITAR:]` pendientes; revisión de estilo pendiente según ADR editorial 13/06.
- ¿Es necesario activar algún fallback documentado en DECISIONS_LOG? **No.** Wazuh operativo; fallback Wazuh→Falco descartado definitivamente.

## 3. Bloqueos
- **Bloqueo activo (gestión):** `envio_tutor_14_06` sin ejecutar. Impacto: sin feedback del tutor sobre Caps. 3–6 antes del envío final del 19/06; ventana de correcciones reducida a 48h.
- **Bloqueo potencial:** compilación Overleaf no iniciada online. Mitigación: crear proyecto hoy con plantilla ETSINF, cargar `borradorplantillatfgoverleaf.tex`, verificar compilación con texto dummy; priorizar Caps. 3–6 en transferencia.
- Sin bloqueo técnico de infraestructura ni de laboratorio.

## 4. Tablero del Sprint Actual
### TODO
- [ ] **[HUMANO] `envio_tutor_14_06`** — Email al tutor el 14/06 con memoria al 60-70%.
- [ ] **[HUMANO] `setup_overleaf`** — Crear proyecto Overleaf con plantilla ETSINF UPV (14/06).
- [ ] **[HUMANO] `envio_tutor_19_06`** — PDF compilado al tutor el 19/06.
- [ ] **[HUMANO] `revision_final_entrega`** — Correcciones + depósito en plataforma el 21/06.

### DOING
- [ ] **[HUMANO] `cerrar_cap_4_5_figuras`** — Cierre §4.5 limitaciones en `04_diseno.md`; figuras `[FIG:]` Caps. 5–6; repaso transversal Caps. 3–6 antes del email tutor (13–14/06).
- [ ] **[HUMANO] `transferir_a_overleaf`** — Transferir MD a Overleaf, maquetar, BibTeX (17-18/06).

### DONE (Sprint Final — desde 24/05)
- [x] **`redactar_intro_conclusiones`** — Caps. 1 y 7 en borrador [HUMANO]: §1.1–§1.5 (pregunta de investigación, hipótesis, metodología, estructura) y §7.1–§7.4 (conclusiones, limitaciones, trabajo futuro, ODS). Pendiente: revisión estilo §7 [IA→HUMANO], nombres asignaturas §7.4.1, citas `[CITAR:]`. Commits `3d65bc0`, `684a809`. (2026-06-17)
- [x] **`redactar_cap_4_completo`** — `04_diseno.md` §4.1–§4.5 redactados [HUMANO]: §4.4.1 alternativas evaluadas, §4.5 limitaciones; `[TODO]` skeleton eliminados; prosa [IA] migrada a [HUMANO]. Pendiente: 4 `[FIG:]` y cita Wazuh §4.3.5. Commit `3ff326b`. (2026-06-14)
- [x] **`redactar_cap_3`** — `03_analisis_problema.md` §3.1–§3.4 redactados [HUMANO]: problema, modelo amenazas (5 puntos), RF/RNF, tabla KPIs con operacionalización y `T0_efectivo`. Revisión humana 12/06 (4 hitos, tupla SIEM, estilo). Commit `381658a`. (2026-06-12)
- [x] **`redactar_cap_5`** — `05_desarrollo_implantacion.md` §5.1–§5.5 redactados [HUMANO]: IaC, Escenario A, Escenario B (3 zonas, mTLS, Wazuh), casos de integración. Pendiente figuras/anexos (no bloquea borrador texto). Commit `d7c30db`. (2026-06-12)
- [x] **`redactar_cap_6`** — `06_pruebas.md` §6.1–§6.4 redactados [HUMANO] con sesión `130120`, plantilla KPI v2 §2/§3 y comparativa A↔B. Revisión editorial G3 y §6.4.3 (11–12/06). Diario: `docs/04_diario_laboratorio/20260611_Sesion_Redaccion_Cap6_Comparativa.md`. (2026-06-12)
- [x] **`redactar_eda_v0`** — Estado del Arte v0 cerrado: §2.2–§2.6 [HUMANO] + §2.7 Trabajos relacionados (4 TFG locales, posicionamiento pregunta de investigación). Typos §2.2–§2.6 corregidos. Refs en `99_bibliografia.md`. (2026-06-10)
- [x] **`redactar_cap_4_parcial`** — `04_diseno.md` §4.1–§4.3 redactados (visión A/B, Escenario A, Escenario B core). (2026-06-10)
- [x] **`ejecutar_pruebas_ab`** — Comparativa A↔B cerrada. Sesión oficial B `zerotrust_sesion_20260609_130120`; plantilla KPI v2 §2/§3; diario §12. (2026-06-09)
- [x] **`registrar_adr_feedback_tutor`** — ADR 2026-06-06: objetivos reformulados como pregunta de investigación tras feedback tutor del 06/06. Registrado en `admin/DECISIONS_LOG.md`. (2026-06-08)
- [x] **`email_tutor_31_05`** — Índice anotado enviado al tutor el 06/06/2026. Validación general positiva; feedback: objetivos como pregunta de investigación. Registrado en `docs/02_reuniones_tutor/` (timeline §17–§18). (2026-06-06)
- [x] **`wazuh_fase5_escenario_b`** — Fase 5 Wazuh completada (04/06/2026): manager + agente Docker, FIM realtime sobre `/monitored/certs`, docker-listener, reglas MITRE T1046/T1552.004 verificadas. Examen final de integración con red ZT superado (microsegmentación + mTLS + detección end-to-end). Sesión documentada en `docs/04_diario_laboratorio/20260604_Sesion_Wazuh.md`. (2026-06-04)
- [x] **`implementar_escenario_b`** — `infra/zero_trust/` completado: 3 zonas de red, secretos separados, mTLS webapp↔backend, Wazuh manager+agente. Checkpoint 04/06 20:00 SUPERADO. (2026-06-04)
- [x] **`zt_base_mtls_fases_1_4`** — Escenario B inicializado en `infra/zero_trust/`: compose con 3 zonas, servicios base, certificados OpenSSL y mTLS `webapp` -> `backend` configurado. (2026-06-03)
- [x] **`documentar_sesion_zt_2026_06_03`** — Sesión técnica Zero Trust documentada en `docs/04_diario_laboratorio/20260603_Sesion_ZT_DockerCompose.md`, con KPIs parciales observables y próximos pasos para Wazuh. (2026-06-03)
- [x] **`spec_escenario_b`** — Especificación Escenario B completada: `docs/01_investigacion/Investigacion_ZeroTrust.md` (investigación consolidada) + `docs/01_investigacion/20260603_Prototipo_ZeroTrust.md` (prototipo 12 secciones, microsegmentación, mTLS, Wazuh, KPIs). (2026-06-03)
- [x] **`actualizar_seguimiento_2026_05_30`** — `admin/STATE.md` y `admin/reportes/reporte_2026-05-27.md` actualizados con estado de sprint final. (2026-05-30)
- [x] **`archive_roadmap_v1`** — `ROADMAP_v1_archivado.md` creado, `ROADMAP_v2_sprint_final.md` activo, `ROADMAP.md` redirigido. (2026-05-24)
- [x] **`actualizar_state`** — STATE.md reescrito con nuevo objetivo (21/06), nueva estructura de tareas. (2026-05-24)
- [x] **`crear_esqueleto_memoria`** — 9 archivos MD creados en `docs/03_memoria_tfg/` siguiendo ETSINF clásica. Resumen y semilla reutilizados. (2026-05-24)
- [x] **`marcar_obsoletos`** — README de borradores creado; `Metricas_iniciales.md` marcado OBSOLETO explícitamente. (2026-05-24)
- [x] **`registrar_adr_alcance`** — ADR de cambio de deadline, reducción de alcance y fallback Wazuh→Falco registrado en DECISIONS_LOG.md. (2026-05-24)
- [x] **`crear_agenda_sprint_diaria`** — `admin/AGENDA_SPRINT_DIARIA.md` creado con agenda diaria, hitos y reglas de uso. (2026-05-24)
- [x] **`actualizar_comunicaciones_tutor`** — Directrices, timeline y bitácora de tutoría actualizadas para el Sprint Final. (2026-05-24)
- [x] **`crear_plan_operativo_sprint_final`** — Plan operativo del Sprint Final añadido en `.cursor/plans/`. (2026-05-24)
- [x] T12. Consolidar baseline A en `tests/00_PLANTILLA_KPI_v2.md` §1: valores G1-G3, E1-E3 con rutas verificadas. (2026-05-23)
- [x] D5. Cerrar baseline cuantitativa del Escenario A. (2026-05-23)
- [x] Integrar `docker compose cp` en `logcapture_perimetral.sh`. (2026-05-23)
- [x] Capturar evidencias brutas del Escenario A: RCE, screenshots, logs, `creds.txt`, `lateral.json`, `lateral.pcap`. (2026-05-23)
- [x] Publicar `tests/00_PLANTILLA_KPI_v2.md` con separación pre-RCE/post-RCE. (2026-05-12)
- [x] Registrar ADR del 2026-05-12 sobre comparabilidad metodológica KPIs post-RCE.
- [x] D2. Refactorizar Escenario A a formato HTB Academy. (2026-05-09)
- [x] D1. Completar código fuente de `infra/perimetral/`. (anterior)
- [x] Reorganizar documentación a convención `docs/01_investigacion/`, `docs/02_reuniones_tutor/`, `docs/03_memoria_tfg/`, `docs/04_diario_laboratorio/`.

## 5. Hitos críticos del Sprint Final
| Fecha  | Hito                                                       | Estado   |
|--------|------------------------------------------------------------|----------|
| 06/06  | Borrador índice anotado enviado al tutor (recuperación 31/05) | ✅ Completado — validación general positiva; matizar objetivos |
| 04/06  | Checkpoint Wazuh (20:00) — continuar o switch Falco        | ✅ Completado — Wazuh operativo, fallback descartado |
| 09/06  | Escenario B funcional + KPIs §2/§3 cerrados                | ✅ Completado — sesión `130120`, plantilla KPI v2, cuadro §3 |
| 14/06  | Caps. 3, 4, 5, 6 en borrador + email tutor                | ⚠️ En riesgo — texto Caps. 3–6 ✅; email tutor y Overleaf online no evidenciados (3 días vencido) |
| 16/06  | Caps. 1 y 7 redactados                                     | ✅ Completado — borrador redactado 17/06 (1 día de retraso; commits `3d65bc0`, `684a809`) |
| 19/06  | PDF compilado en Overleaf + email final al tutor           | ⚠️ En riesgo — 2 días restantes; solo plantilla .tex local, sin PDF compilado |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | Pendiente |
