# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-06-04

## 0. CAMBIO CRÍTICO DE OBJETIVO (2026-05-24)

> **Nuevo deadline: 21/06/2026** (convocatoria de julio).
> El plan original orientado a septiembre ha quedado archivado en `admin/ROADMAP_v1_archivado.md`.
> El plan activo es `admin/ROADMAP_v2_sprint_final.md`.
> ADR correspondiente registrado en `admin/DECISIONS_LOG.md` (entrada 2026-05-24).

Capacidad efectiva restante:
- 24/05 → 01/06: ~9-12h (1-2h/día) — consumido
- 02/06 → 04/06: ~36h (12h/día × 3 días) — consumido
- **05/06 → 21/06: ~144h restantes** (12h/día × 0.75 fatiga × 16 días)

## 1. Resumen Semanal
- Commits recientes: incluyen Escenario B Fases 1–5 completas + diarios de laboratorio + ADRs de arquitectura.
- Avance técnico principal: **Escenario B 100% implementado y verificado.** Stack Wazuh operativo (manager + agente Docker, enrollment estable, FIM realtime, docker-listener activo). Examen final de integración con la red ZT superado: microsegmentación, mTLS y reglas MITRE personalizadas (T1046, T1552.004) verificadas end-to-end.
- Avance de redacción principal: `docs/03_memoria_tfg/02_estado_arte.md` avanzó en perimetral, Zero Trust, microsegmentación, SIEM/IDS y amenazas post-explotación; aún queda `[TODO]` en §2.7 "Trabajos relacionados". Los diarios de laboratorio (`20260603_Sesion_ZT_DockerCompose.md`, `20260604_Sesion_Wazuh.md`) ya son fuente directa para los Caps. 5 y 6.
- Días hasta próximo hito crítico: 5 días hasta el 09/06 (KPIs §2/§3 cerrados).

## 2. Alineación con ROADMAP v2 y Riesgos
- Fase actual del ROADMAP_v2: FASE 2 — SEMANA 2 (02/06-07/06), objetivo de la semana: Escenario B funcional con segmentación, identidad, mTLS y observabilidad. **OBJETIVO TÉCNICO DE LA SEMANA COMPLETADO EL 04/06** con un día de margen.
- Delta respecto al plan: la agenda del 05/06 (reglas para 4 hitos post-RCE) está parcialmente avanzada — nmap (T1046) y modificación de certs (T1552.004) ya detectados. Faltan las reglas de lectura de variables de entorno y conexión directa a db:5432. La línea técnica va **por delante** de la agenda.
- Riesgos activos con nivel (ALTO/MEDIO/BAJO):
  - ~~ALTO: Wazuh no tiene commit visible~~ → **RESUELTO**. Fallback Wazuh→Falco descartado.
  - ALTO: `email_tutor_31_05` VENCIDO sin evidencia de envío; se puede recuperar hoy con un email de actualización de estado.
  - MEDIO: `redactar_eda_v0` tiene `[TODO]` en §2.7 Trabajos relacionados; bloquea el paquete académico al tutor.
  - BAJO: las pruebas A/B formales (06-07/06) están en plazo; el entorno ya está levantado y los escenarios de ataque validados.
- ¿Es necesario activar algún fallback? No. Wazuh operativo. Fallback Wazuh→Falco cerrado definitivamente.

## 3. Bloqueos
- Bloqueo activo: `email_tutor_31_05` sin evidencia de envío. Acción: componer y enviar hoy un email de actualización al tutor con el estado real (Escenario B completo, Wazuh operativo, pruebas A/B en curso el 06-07/06).
- Bloqueo menor: `redactar_eda_v0` con secciones `[TODO]` sin cerrar en §2.7. No bloquea la línea técnica pero sí el paquete académico hacia el tutor.
- Sin bloqueo técnico activo: el stack ZT + Wazuh está operativo y documentado.

## 4. Tablero del Sprint Actual
### TODO
- [ ] **[HUMANO] `email_tutor_31_05`** — Enviar email al tutor (vencido 31/05). Recuperar hoy con email de actualización: Escenario B completo, Wazuh verificado, pruebas A/B el 06-07/06. ⚠️ VENCIDO — RECUPERAR HOY
- [ ] **[HUMANO] `redactar_cap_3_4_5`** — Caps. 3 Análisis del Problema, 4 Diseño, 5 Desarrollo e Implantación, 6 Pruebas (09-13/06).
- [ ] **[HUMANO] `envio_tutor_14_06`** — Email al tutor el 14/06 con memoria al 60-70%.
- [ ] **[HUMANO] `redactar_intro_conclusiones`** — Caps. 1 Introducción y 7 Conclusiones (15-16/06).
- [ ] **[HUMANO] `setup_overleaf`** — Crear proyecto Overleaf con plantilla ETSINF UPV (14/06).
- [ ] **[HUMANO] `transferir_a_overleaf`** — Transferir MD a Overleaf, maquetar, BibTeX (17-18/06).
- [ ] **[HUMANO] `envio_tutor_19_06`** — PDF compilado al tutor el 19/06.
- [ ] **[HUMANO] `revision_final_entrega`** — Correcciones + depósito en plataforma el 21/06.

### DOING
- [ ] **[HUMANO] `redactar_eda_v0`** — Redactar Estado del Arte v0: NIST 800-207, BeyondCorp, OWASP, microsegmentación, comparativa perimetral vs ZT. ⚠️ VENCIDO. Pendiente solo §2.7 "Trabajos relacionados" (resto completado).
- [ ] **[HUMANO] `ejecutar_pruebas_ab`** — Pruebas A/B post-RCE, captura logs, cierre KPIs §2 y §3 (06-08/06). Infraestructura lista: Escenario A y B levantados, escenarios de ataque validados informalmente el 04/06. Pendiente: ejecución formal con captura de evidencias y relleno de `tests/00_PLANTILLA_KPI_v2.md`.

### DONE (Sprint Final — desde 24/05)
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
| 31/05  | Borrador enviado al tutor (EdA v0 + índice 8 caps)         | ⚠️ VENCIDO SIN EVIDENCIA — recuperar hoy |
| 04/06  | Checkpoint Wazuh (20:00) — continuar o switch Falco        | ✅ SUPERADO — Wazuh operativo, fallback descartado |
| 09/06  | Escenario B funcional + KPIs §2/§3 cerrados                | 🟡 En progreso — infra lista, pruebas formales el 06-07/06 |
| 14/06  | Caps. 3, 4, 5, 6 en borrador + email tutor                | Pendiente |
| 16/06  | Caps. 1 y 7 redactados                                     | Pendiente |
| 19/06  | PDF compilado en Overleaf + email final al tutor           | Pendiente |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | Pendiente |
