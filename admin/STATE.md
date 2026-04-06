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

# STATE - Seguimiento TFG Ciberseguridad DUPLICADO GENERADO A PARTIR DE REFINAMIENTO DE ARCHIVO, ELIMINAR REDUNDANCIAS, SACAR INFORMACIÓN CLAVE DEL ANTERIOR Y UNIR A ESTE

Fecha de actualización: 2026-04-06 - Entrada manual

## 1) Resumen de actividad de esta semana
El proyecto ha transicionado a un modelo de Sprints (Kanban) gestionado por IA y se ha consolidado la estructura de directorios (`docs/`, `infra/`, `tests/`).

## 2) Comparativa y Retrasos
- **Progreso Técnico:** Cero.
- **Estado vs Roadmap:** 🚨 RETRASO CRÍTICO. El Roadmap exigía tener la infraestructura básica y la burocracia cerrada en marzo. Estamos en abril y no hay Dockers operativos. Se activa Plan de Choque.

## 3) Bloqueos
- Riesgo de "Parálisis por análisis" con la configuración de la IA y el repositorio, descuidando el trabajo de ciberseguridad real.

## 4) Tablero del Sprint Actual (Semana del 6 al 12 de Abril)

### 🔴 TODO (Por Hacer - Plan de Choque)
- [ ] T1. Crear `infra/perimetral/docker-compose.yml` con 2 contenedores básicos (Ubuntu/Alpine).
- [ ] T2. Lograr que el contenedor A haga `ping` al contenedor B.
- [ ] T3. Aislar: Añadir una regla de iptables/red para bloquear ese ping.
- [ ] T4. Crear el archivo `docs/03_memoria_tfg/cap2_estado_arte.md` y escribir solo el índice.

### 🟡 DOING (En Progreso o Esperando)
- [ ] Burocracia: Confirmar que el TFG está subido/aprobado en la plataforma de la ETSINF.

### 🟢 DONE (Completado esta semana)
- [x] Configuración del Cursor Cloud Agent en GitHub Actions completada.
- [x] Transición del proyecto a arquitectura Hub & Spoke con Kanban.
- [x] Renombrar archivo log a `DECISIONS_LOG.md` para unificar nomenclatura.