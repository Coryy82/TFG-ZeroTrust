# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-05-31

## 0. CAMBIO CRÍTICO DE OBJETIVO (2026-05-24)

> **Nuevo deadline: 21/06/2026** (convocatoria de julio).
> El plan original orientado a septiembre ha quedado archivado en `admin/ROADMAP_v1_archivado.md`.
> El plan activo es `admin/ROADMAP_v2_sprint_final.md`.
> ADR correspondiente registrado en `admin/DECISIONS_LOG.md` (entrada 2026-05-24).

Capacidad efectiva restante:
- 24/05 → 01/06: ~9-12h (1-2h/día)
- 02/06 → 21/06: ~180h (12h/día × 0.75 fatiga)
- **Total: ~190-200h**

## 1. Resumen Semanal
- Commits últimos 7 días: 4 entradas. Se amplió el Estado del Arte (`02_estado_arte.md`), se fusionó `main`, se cambió `autoCreatePr` en el workflow del agente y se actualizó el seguimiento administrativo del sprint.
- Avance técnico principal: no hay commits en `infra/` ni `tests/`; no consta avance técnico nuevo en Escenario B.
- Avance de redacción principal: avance parcial del Estado del Arte con análisis de seguridad perimetral, Zero Trust, microsegmentación y amenazas post-explotación; el fichero aún conserva secciones `[TODO]`, por lo que no se considera EdA v0 cerrado.
- Días hasta próximo hito crítico: 0 días hasta el 31/05, email al tutor con Estado del Arte v0 + índice + propuesta de alcance.

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: FASE 1 — SEMANA 1 (24/05-31/05), objetivo de la semana: borrador "razonablemente decente" para el tutor.
- Delta respecto al plan: retrasado. Hay avance real en redacción, pero no hay evidencia de EdA v0 completo, envío al tutor ni especificación del Escenario B antes del cierre de la Fase 1.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO):
  - ALTO: hito 31/05 en riesgo por ausencia de evidencia de envío al tutor y EdA aún con `[TODO]`.
  - ALTO: especificación del Escenario B sin commit visible; comprime el arranque de implementación del 02/06.
  - MEDIO: Wazuh mantiene alta varianza de integración antes del checkpoint del 04/06.
  - BAJO: posible demora de respuesta del tutor; el ROADMAP ya contempla avanzar sin bloqueo.
- ¿Es necesario activar algún fallback documentado en DECISIONS_LOG? No todavía. Mantener el fallback Wazuh -> Falco preparado para el checkpoint duro del 04/06 20:00.

## 3. Bloqueos
- Bloqueo activo: el hito del 31/05 no tiene evidencia de envío al tutor y el Estado del Arte conserva secciones pendientes; impacto directo sobre la validación temprana del alcance por parte del tutor.
- Bloqueo potencial: Escenario B sigue sin especificación visible; mitigación: cerrar el 01/06 una especificación mínima verificable y no ampliar alcance antes del checkpoint Wazuh.

## 4. Tablero del Sprint Actual
### TODO
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
- [x] **[HUMANO] `redactar_eda_v0`** — Redactar Estado del Arte v0 (25-30/05): NIST 800-207, BeyondCorp, OWASP, microsegmentación, comparativa perimetral vs ZT. Mínimo 5-6 páginas. Usar `docs/01_investigacion/` como insumo.

### DONE (Sprint Final — desde 24/05)
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
| 31/05  | Borrador enviado al tutor (EdA v0 + índice 8 caps)         | ⚠️ En riesgo |
| 04/06  | Checkpoint Wazuh (20:00) — continuar o switch Falco        | ⚠️ En riesgo |
| 09/06  | Escenario B funcional + KPIs §2/§3 cerrados                | ⚠️ En riesgo |
| 14/06  | Caps. 3, 4, 5, 6 en borrador + email tutor                | Pendiente |
| 16/06  | Caps. 1 y 7 redactados                                     | Pendiente |
| 19/06  | PDF compilado en Overleaf + email final al tutor           | Pendiente |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | Pendiente |
