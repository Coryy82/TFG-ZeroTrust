# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-04-06

## 1. Resumen Semanal
- Commits últimos 7 días: **6** (`e1527b3`, `e123e97`, `29ddeab`, `6394dd0`, `1d360b9`, `7b48170`).
- Trabajo completado: refactor y estabilización del workflow administrativo (`.github/workflows/admin_agent.yml`), actualización de artefactos de gestión en `/admin/` y creación de estructura base de carpetas (`docs/`, `infra/`, `tests/`).
- Evidencia de retrabajo: commit experimental (`e123e97`) seguido de revert (`29ddeab`).
- Avance funcional de ciberseguridad (escenarios perimetral/zero-trust, pruebas, métricas): **no evidenciado en commits**.

## 2. Comparativa y Retrasos
- Comparado con el ciclo previo, mejora la gobernanza del proyecto (estado, roadmap y reporte), pero la **velocidad técnica del TFG sigue en 0 entregables funcionales**.
- Alineación con `admin/ROADMAP.md` (Marzo-Abril): **retraso** en los hitos esperados (Docker Compose operativo, conectividad entre contenedores, bloqueo simple de tráfico y avance de Capítulo 2).
- Delta semanal principal: progreso administrativo alto, progreso experimental/técnico bajo.

## 3. Bloqueos
- Foco excesivo en infraestructura de gestión del repositorio frente a construcción del laboratorio técnico.
- Falta de evidencia verificable (capturas, logs o scripts) de los hitos del escenario perimetral.
- Inconsistencia de nomenclatura documental (`DECISION_LOG.md` vs referencia solicitada `DECISIONS_LOG.md`) con riesgo de confusión operativa.
- Posible dependencia externa no cerrada: confirmación burocrática de alta del TFG en plataforma académica.

## 4. Tablero del Sprint Actual
### TODO
- [ ] T1. Crear `infra/perimetral/docker-compose.yml` con 2 contenedores y red plana.
- [ ] T2. Validar conectividad A->B (ping) y guardar evidencia reproducible.
- [ ] T3. Aplicar bloqueo simple de tráfico entre contenedores y documentar resultado.
- [ ] T4. Redactar borrador inicial de `Estado del Arte` (Cap. 2) con fuentes Zero Trust (NIST/IEEE).
- [ ] T5. Definir KPI semanales mínimos: entregables técnicos cerrados, evidencias y riesgos.

### DOING
- [ ] D1. Confirmar trámite de subida/aprobación del TFG en la plataforma ETSINF.
- [ ] D2. Normalizar nombre oficial del log de decisiones y reflejarlo en todos los documentos.

### DONE
- [x] Refactor del flujo administrativo en GitHub Actions con payload estructurado.
- [x] Actualización de artefactos de gestión iniciales en `/admin/` (ROADMAP, STATE y reporte ejecutivo).
- [x] Estructura base de directorios del proyecto creada (`docs/`, `infra/`, `tests/`).