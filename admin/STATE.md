# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-05-24

---

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

## 1. Resumen Semanal (semana del 24/05/2026)

- Sprint arrancado: **Sprint Final 21/06**.
- Commits previos (semana anterior, 8 entradas): cierre baseline Escenario A, plantilla KPI v2 §1 completa, script `logcapture_perimetral.sh` actualizado, informe técnico sesión oficial `perimetral_sesion_20260523_175204`.
- Trabajo completado esta sesión: archivado ROADMAP v1, creado ROADMAP v2 sprint final, actualización de STATE, esqueleto 9 capítulos ETSINF, ADR de cambio de deadline y alcance.
- Avance técnico principal: **Escenario A completamente cerrado**. Baseline cuantitativa defendible: G1–G3, E1–E3 con evidencias verificadas en `tests/00_PLANTILLA_KPI_v2.md §1`.
- Avance pendiente más urgente: Estado del Arte v0 (25-30/05) + envío al tutor el 31/05.

---

## 2. Estado por Escenario

### Escenario A (Perimetral) — CERRADO
- Sesión oficial: `perimetral_sesion_20260523_175204`
- Todos los KPIs medidos y defendibles: G1 `(false, ∞)`, G2 `3 nodos`, G3 `(false, 0%)`, E1 `3/3`, E2 `~766B/3 archivos`, E3 `texto claro`.
- Evidencias: `creds.txt`, `lateral.json`, `dump.txt`, `lateral.pcap` (verificado tshark), `e1_scan.log`, logs de servicios.
- Plantilla KPI v2 §1 completa. §3 columna A completa.
- **No se abre más para captura.** La sesión del 23/05 es la oficial.

### Escenario B (Zero Trust) — NO INICIADO
- `infra/zero_trust/` contiene únicamente `.gitkeep`.
- Especificación pendiente (target: 28-29/05 o 01/06).
- Implementación planificada: 02-05/06.
- Checkpoint Wazuh: 04/06 a las 20:00 → si falla, switch a Falco.

---

## 3. Bloqueos

- **Bloqueo activo:** Escenario B no iniciado. Sin red Zero Trust ni observabilidad no hay comparativa A/B ni KPIs §2/§3.
- **Bloqueo potencial (R1):** Wazuh. Mitigación: fallback a Falco con timestamp duro el 04/06.
- **Bloqueo potencial (R3):** Tutor puede tardar 1-3 semanas en responder. Mitigación: no bloquear el sprint; avanzar en paralelo.
- **Memoria:** `docs/03_memoria_tfg/` estructurada hoy (esqueleto 9 caps). Redacción de fondo arranca el 25/05.

---

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

*(vacío — sprint recién iniciado)*

### DONE (Sprint Final — desde 24/05)

- [x] **`archive_roadmap_v1`** — `ROADMAP_v1_archivado.md` creado, `ROADMAP_v2_sprint_final.md` activo, `ROADMAP.md` redirigido. (2026-05-24)
- [x] **`actualizar_state`** — STATE.md reescrito con nuevo objetivo (21/06), nueva estructura de tareas. (2026-05-24)
- [x] **`crear_esqueleto_memoria`** — 9 archivos MD creados en `docs/03_memoria_tfg/` siguiendo ETSINF clásica. Resumen y semilla reutilizados. (2026-05-24)
- [x] **`marcar_obsoletos`** — README de borradores creado; `Metricas_iniciales.md` marcado OBSOLETO explícitamente. (2026-05-24)
- [x] **`registrar_adr_alcance`** — ADR de cambio de deadline, reducción de alcance y fallback Wazuh→Falco registrado en DECISIONS_LOG.md. (2026-05-24)

### DONE (Sprints anteriores — referencia)

- [x] T12. Consolidar baseline A en `tests/00_PLANTILLA_KPI_v2.md` §1: valores G1-G3, E1-E3 con rutas verificadas. (2026-05-23)
- [x] D5. Cerrar baseline cuantitativa del Escenario A. (2026-05-23)
- [x] Integrar `docker compose cp` en `logcapture_perimetral.sh`. (2026-05-23)
- [x] Capturar evidencias brutas del Escenario A: RCE, screenshots, logs, `creds.txt`, `lateral.json`, `lateral.pcap`. (2026-05-23)
- [x] Publicar `tests/00_PLANTILLA_KPI_v2.md` con separación pre-RCE/post-RCE. (2026-05-12)
- [x] Registrar ADR del 2026-05-12 sobre comparabilidad metodológica KPIs post-RCE.
- [x] D2. Refactorizar Escenario A a formato HTB Academy. (2026-05-09)
- [x] D1. Completar código fuente de `infra/perimetral/`. (anterior)
- [x] Reorganizar documentación a convención `docs/01_investigacion/`, `docs/02_reuniones_tutor/`, `docs/03_memoria_tfg/`, `docs/04_diario_laboratorio/`.

---

## 5. Hitos críticos del Sprint Final

| Fecha  | Hito                                                       | Estado   |
|--------|------------------------------------------------------------|----------|
| 31/05  | Borrador enviado al tutor (EdA v0 + índice 8 caps)         | Pendiente |
| 04/06  | Checkpoint Wazuh (20:00) — continuar o switch Falco        | Pendiente |
| 09/06  | Escenario B funcional + KPIs §2/§3 cerrados                | Pendiente |
| 14/06  | Caps. 3, 4, 5, 6 en borrador + email tutor                | Pendiente |
| 16/06  | Caps. 1 y 7 redactados                                     | Pendiente |
| 19/06  | PDF compilado en Overleaf + email final al tutor           | Pendiente |
| 21/06  | **ENTREGA** — PDF depositado en plataforma                 | Pendiente |
