# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-04-26

## 1. Resumen Semanal
- Commits últimos 7 días: **1** (`6058c3f`).
- Trabajo completado según commits: actualización administrativa del estado semanal y creación del reporte ejecutivo del 19/04.
- No se observa evidencia nueva de ejecución técnica del laboratorio: no hay commits con `docker-compose` funcional, pruebas de conectividad, capturas, logs, bloqueo lateral ni avances del borrador académico.
- Tendencia observada: continuidad mínima en seguimiento del proyecto, con velocidad técnica nula durante la semana.

## 2. Comparativa y Retrasos
- Comparado con la semana anterior, la actividad baja de **3 a 1 commit** y se concentra al 100% en gestión administrativa.
- Alineación con `admin/ROADMAP.md`:
  - **Marzo-Abril (Escenario A perimetral):** retraso alto. Siguen sin cerrarse los hitos de Docker Compose, conectividad entre contenedores, bloqueo simple y evidencias reproducibles.
  - **Mayo (Zero Trust + Wazuh):** riesgo de arranque condicionado. El roadmap exige iniciar segmentación y visibilidad, pero la baseline perimetral A todavía no está validada.
- Delta principal: se mantiene la trazabilidad administrativa, pero aumenta el retraso acumulado en entregables técnicos y académicos.

## 3. Bloqueos
- Inactividad técnica visible en Git durante la semana: solo se registra un commit administrativo.
- Falta de evidencias reproducibles para cerrar el Escenario A (comandos, logs, capturas o scripts de validación).
- Riesgo metodológico: avanzar a Zero Trust/Wazuh sin baseline perimetral medida compromete la comparativa central del TFG.
- Riesgo de arrastre académico: el borrador de "Estado del Arte" continúa pendiente pese a estar previsto en el bloque marzo-abril.

## 4. Tablero del Sprint Actual
### TODO
- [ ] T1. Implementar `infra/perimetral/docker-compose.yml` funcional (Web + BBDD) y levantar entorno.
- [ ] T2. Ejecutar y documentar prueba de conectividad total en red plana (evidencia: comandos, logs y capturas).
- [ ] T3. Aplicar y validar bloqueo simple de tráfico lateral con comparativa antes/después.
- [ ] T4. Cerrar borrador del capítulo "Estado del Arte" con referencias NIST/IEEE.
- [ ] T5. Estudiar Wazuh para el hito de mayo: alcance, requisitos, arquitectura mínima y riesgos de despliegue.
- [ ] T6. Definir diseño objetivo del Escenario B Zero Trust: separación Web/BBDD, flujos permitidos y puntos de observabilidad.
- [ ] T7. Registrar evidencias mínimas por tarea cerrada: comandos ejecutados, resultado esperado, resultado observado y ubicación de capturas/logs.

### DOING
- [ ] D1. Cerrar la baseline del Escenario A perimetral antes de iniciar cambios de Zero Trust.
- [ ] D2. Mantener seguimiento semanal del riesgo roadmap-ejecución y escalar bloqueos si no aparecen commits técnicos.

### DONE
- [x] Actualización semanal de artefactos de gestión del 19/04 (`STATE.md` y reporte ejecutivo).
- [x] Incorporación previa de directrices de tutoría y bitácora de seguimiento de reuniones.
- [x] Publicación previa de documentación inicial del prototipo "Red Perimetral".
