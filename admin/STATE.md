# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-04-19

## 1. Resumen Semanal
- Commits últimos 7 días: **3** (`521d5ee`, `005f261`, `37d51b6`).
- Trabajo completado según commits: actualización de estado y reporte semanal, incorporación de directrices de tutoría y registro de reuniones, y creación de documentación inicial del prototipo de red perimetral.
- Tendencia observada: progreso constante en gobernanza y planificación documental, con baja evidencia de ejecución técnica verificable del laboratorio (sin trazas en commits de compose operativo, pruebas de conectividad o bloqueo).

## 2. Comparativa y Retrasos
- Comparado con la semana anterior, baja la actividad total (de 10 a 3 commits), manteniéndose el enfoque principal en artefactos de coordinación y documentación.
- Alineación con `admin/ROADMAP.md`:
  - **Marzo-Abril (Escenario A perimetral):** cumplimiento parcial. Hay avance en planificación, pero quedan pendientes hitos críticos de implementación y validación experimental.
  - **Preparación de Mayo (Zero Trust + Wazuh):** existe riesgo de entrada con retraso si no se cierra primero la baseline perimetral medible.
- Delta principal: mejora en orden y seguimiento del proyecto, con retraso acumulado en entregables técnicos demostrables.

## 3. Bloqueos
- Falta de evidencias técnicas reproducibles en commits (logs, capturas o scripts de validación) para cerrar tareas del escenario perimetral.
- Concentración de esfuerzo en gestión/documentación frente a ejecución de infraestructura experimental.
- Riesgo metodológico: avanzar a Zero Trust sin baseline A validada compromete la calidad de la comparativa del TFG.

## 4. Tablero del Sprint Actual
### TODO
- [ ] T1. Implementar `infra/perimetral/docker-compose.yml` funcional (Web + BBDD) y levantar entorno.
- [ ] T2. Ejecutar y documentar prueba de conectividad total en red plana (evidencia: comandos + capturas).
- [ ] T3. Aplicar y validar bloqueo simple de tráfico lateral con comparativa antes/después.
- [ ] T4. Cerrar borrador del capítulo "Estado del Arte" con referencias NIST/IEEE.
- [ ] T5. Iniciar estudio técnico de Wazuh para preparar el hito de mayo (alcance, requisitos y despliegue mínimo).
- [ ] T6. Definir KPI semanal obligatorio: tareas técnicas cerradas, evidencias adjuntas y riesgos abiertos.

### DOING
- [ ] D1. Refinar el plan del prototipo de red perimetral y convertirlo en backlog técnico ejecutable.
- [ ] D2. Mantener la coordinación con tutor y actualizar decisiones de trabajo según reuniones.

### DONE
- [x] Actualización semanal de artefactos de gestión (`STATE.md` y reporte ejecutivo del 12/04).
- [x] Incorporación de directrices de tutoría y bitácora de seguimiento de reuniones.
- [x] Publicación de documentación inicial del prototipo "Red Perimetral".