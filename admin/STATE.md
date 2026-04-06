# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-04-06

## 1) Resumen de actividad de esta semana (últimos commits)

Commits detectados en los últimos 7 días:

1. `6394dd0` - refactor del workflow de agente admin en GitHub Actions  
   - Archivo: `.github/workflows/admin_agent.yml`
2. `29ddeab` - revert de cambio previo en workflow  
   - Archivo: `.github/workflows/admin_agent.yml`
3. `e123e97` - cambio intermedio en workflow (`f`)  
   - Archivo: `.github/workflows/admin_agent.yml`
4. `e1527b3` - creación de estructura base de carpetas (docs/infra/tests)  
   - Archivos placeholder en `docs/`, `infra/`, `tests/`

Lectura PM: la semana se ha centrado en automatización/flujo de trabajo y estructuración del repositorio, con poca evidencia de avance funcional documentado del contenido técnico del TFG.

## 2) Comparativa con la semana pasada

- **Semana pasada (referencia Git del archivo `admin/STATE.md`)**: sin contenido registrado.
- **Estado actual**: se incorpora por primera vez un estado formal con seguimiento y acciones.
- **Delta principal**: existe actividad técnica en workflows y estructura, pero falta trazabilidad de decisiones y métricas de progreso del TFG.

## 3) Bloqueos detectados

1. **Registro de decisiones vacío** (`admin/DECISION_LOG.md` sin entradas).
2. **Estado histórico inexistente** (no hay baseline previo en `admin/STATE.md`).
3. **Desalineación de nomenclatura** solicitada vs repositorio (`DECISIONS_LOG.md` vs `DECISION_LOG.md`), lo que puede romper hábitos o automatizaciones de seguimiento.
4. **Escasa trazabilidad funcional**: commits recientes no reflejan claramente hitos técnicos de ciberseguridad (modelo de amenazas, controles, validaciones, resultados de pruebas, etc.).

## 4) Nuevas tareas de desbloqueo (añadidas)

- [ ] T1. Definir y fijar un único nombre para el log de decisiones (`DECISION_LOG.md` o `DECISIONS_LOG.md`) y mantener consistencia.
- [ ] T2. Completar al menos 3 entradas iniciales en el log de decisiones con formato: fecha, decisión, alternativas, impacto.
- [ ] T3. Establecer KPIs de avance semanal (ejemplo: entregables cerrados, controles implementados, evidencias de prueba).
- [ ] T4. Registrar en cada commit una referencia explícita al objetivo del TFG que impacta.
- [ ] T5. Crear checklist de evidencia mínima por hito (arquitectura, riesgo, validación, resultados).

## 5) Próximo corte de seguimiento

En la siguiente revisión se validará:
- si el log de decisiones ya contiene entradas accionables;
- si los nuevos commits muestran avance funcional del TFG, no solo cambios de infraestructura del repo;
- y si existe trazabilidad entre decisiones, tareas y resultados.
