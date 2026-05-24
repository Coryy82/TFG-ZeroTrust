# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-05-24

## 0. CAMBIO CRÍTICO DE OBJETIVO (2026-05-24)

> **Nuevo deadline: 21/06/2026** (convocatoria de julio).
> El plan original orientado a septiembre ha quedado archivado en `admin/ROADMAP_v1_archivado.md`.
> El plan activo es `admin/ROADMAP_v2_sprint_final.md`.
> ADR correspondiente registrado en `admin/DECISIONS_LOG.md` (entrada 2026-05-24).

Capacidad efectiva restante:
- 24/05 → 01/06: ~9-12h (1-2h/día)
- 02/06 → 21/06: ~180h (12h/día × 0.75 fatiga)
- **Total: ~190-200h**

---

## 1. Resumen Semanal
- Commits últimos 7 días: 7 entradas. Se cerró la baseline cuantitativa del Escenario A, se importaron borradores iniciales, se archivó el ROADMAP v1, se activó ROADMAP v2, se registraron ADRs del Sprint Final y se creó la agenda diaria del sprint.
- Avance técnico principal: Escenario A perimetral cerrado con evidencias en `tests/logs/perimetral_sesion_20260523_175204/`, plantilla KPI v2 §1 actualizada y script `tests/scripts/logcapture_perimetral.sh` mejorado.
- Avance de redacción principal: esqueleto ETSINF de 9 ficheros en `docs/03_memoria_tfg/`, borradores iniciales incorporados y material obsoleto marcado para no contaminar la memoria final.
- Días hasta próximo hito crítico: 7 días hasta el 31/05 — email al tutor con Estado del Arte v0, índice y propuesta de alcance del Escenario B.

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: FASE 1 — SEMANA 1 (24/05-31/05), con objetivo único de producir un borrador "razonablemente decente" para el tutor.
- Delta respecto al plan: en tiempo para el arranque del sprint; el trabajo del 24/05 previsto en el roadmap está cubierto, pero el Estado del Arte v0 aún no tiene evidencia de redacción final en commits.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO): MEDIO — Estado del Arte v0 concentra el primer hito con baja disponibilidad diaria; MEDIO — Escenario B sigue sin especificación técnica cerrada; ALTO — Wazuh mantiene alta varianza de integración para el checkpoint del 04/06; MEDIO — la respuesta del tutor puede llegar tarde y no debe bloquear el avance.
- ¿Es necesario activar algún fallback documentado en DECISIONS_LOG? No todavía. El fallback Wazuh → Falco queda preparado para el 04/06 20:00, pero no debe activarse antes del checkpoint salvo bloqueo técnico explícito.

## 3. Bloqueos
- Bloqueo activo: Escenario B no iniciado a nivel técnico; impacto directo en KPIs §2/§3 si la especificación no queda cerrada antes de entrar en la fase de implementación.
- Bloqueo potencial: Wazuh puede consumir más presupuesto del permitido; mitigación: aplicar el checkpoint duro del 04/06 20:00 y cambiar a Falco si no hay agent enrollado y al menos 1 alerta activa.
- Bloqueo potencial: falta evidencia commiteada del Estado del Arte v0; mitigación: priorizar `redactar_eda_v0` del 25 al 27/05 antes de ampliar diseño técnico.

## 4. Tablero del Sprint Actual
### TODO
- [ ] **[HUMANO] `redactar_eda_v0`** — Redactar Estado del Arte v0 (25-30/05): NIST 800-207, BeyondCorp, OWASP, microsegmentación, comparativa perimetral vs ZT. Mínimo 5-6 páginas. Usar `docs/01_investigacion/` como insumo.
- [ ] **[HUMANO] `spec_escenario_b`** — Redactar especificación Escenario B en `docs/01_investigacion/20260528_Prototipo_ZeroTrust.md` (28-29/05): 3 redes Docker, mTLS webapp↔backend, Wazuh mínimo + criterio fallback.
- [ ] **[HUMANO] `email_tutor_31_05`** — Enviar email al tutor el 31/05 con índice, EdA v0 y propuesta de alcance. Preguntar si es "razonablemente decente".
- [ ] **[HUMANO] `implementar_escenario_b`** — Implementar `infra/zero_trust/` (02-05/06). Checkpoint Wazuh 04/06 20:00.
- [ ] **[HUMANO] `ejecutar_pruebas_ab`** — Pruebas A/B post-RCE, captura logs, cierre KPIs §2 y §3 (06-08/06).
- [ ] **[HUMANO] `redactar_cap_3_4_5`** — Caps. 3 Análisis del Problema, 4 Diseño, 5 Desarrollo e Implantación, 6 Pruebas (09-13/06).
- [ ] **[HUMANO] `envio_tutor_14_06`** — Email al tutor el 14/06 con memoria al 60-70%.
- [ ] **[HUMANO] `redactar_intro_conclusiones`** — Caps. 1 Introducción y 7 Conclusiones (15-16/06).
- [ ] **[HUMANO] `setup_overleaf`** — Crear proyecto Overleaf con plantilla ETSINF UPV (14/06).
- [ ] **[HUMANO] `transferir_a_overleaf`** — Transferir MD a Overleaf, maquetar, BibTeX (17-18/06).
- [ ] **[HUMANO] `envio_tutor_19_06`** — PDF compilado al tutor el 19/06.
- [ ] **[HUMANO] `revision_final_entrega`** — Correcciones + depósito en plataforma el 21/06.

### DOING
*(vacío — no hay tarea parcialmente evidenciada por commits posteriores al arranque del Sprint Final.)*

### DONE (Sprint Final — desde 24/05)
- [x] **`archive_roadmap_v1`** — `ROADMAP_v1_archivado.md` creado, `ROADMAP_v2_sprint_final.md` activo, `ROADMAP.md` redirigido. (2026-05-24)
- [x] **`actualizar_state`** — STATE.md reescrito con nuevo objetivo (21/06), nueva estructura de tareas. (2026-05-24)
- [x] **`crear_esqueleto_memoria`** — 9 archivos MD creados en `docs/03_memoria_tfg/` siguiendo ETSINF clásica. Resumen y semilla reutilizados. (2026-05-24)
- [x] **`marcar_obsoletos`** — README de borradores creado; `Metricas_iniciales.md` marcado OBSOLETO explícitamente. (2026-05-24)
- [x] **`registrar_adr_alcance`** — ADR de cambio de deadline, reducción de alcance y fallback Wazuh→Falco registrado en DECISIONS_LOG.md. (2026-05-24)
- [x] **`crear_agenda_sprint_diaria`** — `admin/AGENDA_SPRINT_DIARIA.md` creado como agenda diaria del Sprint Final y workflow de agente actualizado. (2026-05-24)
- [x] **`actualizar_comunicacion_tutor`** — Directrices, timeline y bitácora de tutoría actualizados tras el cambio de convocatoria. (2026-05-24)
- [x] **`incorporar_borradores_iniciales`** — Borradores iniciales importados como material de apoyo en `docs/01_investigacion/` y `docs/03_memoria_tfg/Borradores y pretrabajos/`. (2026-05-24)

Referencia preservada de sprints anteriores:
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
| Fecha  | Hito                                                       | Estado |
|--------|------------------------------------------------------------|--------|
| 31/05  | Borrador enviado al tutor (EdA v0 + índice 8 caps)         | En progreso |
| 04/06  | Checkpoint Wazuh (20:00) — continuar o switch Falco        | Pendiente |
| 09/06  | Escenario B funcional + KPIs §2/§3 cerrados                | Pendiente |
| 14/06  | Caps. 3, 4, 5, 6 en borrador + email tutor                 | Pendiente |
| 16/06  | Caps. 1 y 7 redactados                                     | Pendiente |
| 19/06  | PDF compilado en Overleaf + email final al tutor           | Pendiente |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | Pendiente |
