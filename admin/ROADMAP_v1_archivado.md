# ROADMAP GLOBAL - TFG Ciberseguridad (Zero Trust vs Perimetral)

## ESTRATEGIA MENSUAL

### MARZO-ABRIL: Cimientos y Escenario A (Perimetral)
**Objetivo:** Burocracia cerrada, entorno técnico "Hola Mundo" y red plana.
- **Hitos:** Docker Compose listo. Contenedores con ping. Bloqueo simple. Despliegue de red plana (Web + BBDD) vulnerable.
- **Entregable:** Capturas de conectividad total y Borrador Cap 2 (Estado del Arte).
- **Riesgo:** Parálisis por análisis. (Mitigación: Timeboxing de 2h máximo por problema).

### MAYO: Escenario B (Zero Trust) + Visibilidad
**Objetivo:** Implementar segmentación y vigilancia (Wazuh).
- **Hitos:** Separación de Web y BBDD. Despliegue de Wazuh (SIEM).
- **Entregable:** Tráfico ilegítimo cortado y Wazuh generando alertas. Borrador Cap 3 (Diseño).

### JUNIO: El Experimento (Ataque y Medición)
**Objetivo:** Ejecutar la comparativa (El corazón del TFG).
- **Hitos:** Ejecutar ataques (Movimiento Lateral, Datos, Spoofing) en ambos escenarios. Medir y documentar.
- **Entregable:** Tablas de resultados en Excel y Borrador Cap 4 (Pruebas).

### JULIO: Redacción Intensiva
**Objetivo:** Documento al 90% enviado al tutor antes de que se vaya de vacaciones.
- **Hitos:** Unificar capítulos. Escribir Intro y Conclusiones.
- **Entregable:** Borrador Completo (Draft 1) enviado el ~20 de Julio.

### AGOSTO-SEPTIEMBRE: Pulido, Congelación y Defensa
**Objetivo:** Perfección académica y entrega.
- **Hitos:** CONGELACIÓN DE CÓDIGO (prohibido tocar Docker). Revisión ETSINF. Crear PPT. Defensa oral.

---
## PRODUCT BACKLOG (Pila de tareas pendiente de asignar a Sprints)
*(El Agente Administrador sacará tareas de aquí para rellenar la columna TODO del STATE.md)*

- Búsqueda de contenido Zero-Trust (NIST, IEEE).
- Redactar "Estado del Arte".
- Estudiar y desplegar Wazuh (SIEM).
- Crear prototipo de red Zero-Trust.
- Acoplar Wazuh a la red Zero Trust.
- Redactar "Diseño de la Solución".
- Automatizar ataques con scripts (Bash/Python).
- Ejecutar y medir ataques en Escenario A y B.
- Redactar "Análisis de problemas", "Pruebas" y "Conclusiones".

# LISTADO DE TAREAS ORIGINAL + FECHA PARA REFERENCIA

- Crear proyecto docker en repo git -> 14/03/2026
- Investigar y agrupar para estudiar conceptos de Docker Networks (Bridge vs Host) y sintaxis YAML -> 15/03/2026
- Crear Agente constructor, instalar docker, docker compose y vs code -> 15/03/2026
- Tener repositorio git con docker-compose que levante 2 máquinas. -> 28/03/2026
- TFG Subido a plataforma -> 28/03/2026
- Buscar contenido Zero-Trust (conceptos a estudiar) -> 01/04/2026
- Crear documento TFG en latex -> 04/04/2026
- Redactar “Estado del arte” -> 11/04/2026
- Evaluar estado TFG -> 12/04/2026
- Estudiar Wazuh (SIEM) -> 15/04/2026
- Crear prototipo red Zero-Trust -> 18/04/2026
- Ver forma de montar y configurar Wazuh -> 25/04/2026
- Acabar de crear red Zero-Trust con Wazuh acoplado -> 02/05/2026
- Redactar “Diseño de la solución” (1) -> 09/05/2026
- Redactar “Diseño de la solución” (2) -> 16/05/2026
- Estudiar como ejecutar las pruebas (ataques) a realizar (1) -> 20/05/2026
- Estudiar como ejecutar las pruebas (ataques) a realizar (2) - automatizar ataques -> 23/05/2026
- Documentar y medir ataques en Escenario A -> 30/05/2026
- Documentar y medir ataques en Escenario B -> 06/06/2026
- Redactar capítulo “Pruebas” -> 13/06/2026
- Redactar capítulo “Introducción” -> 27/06/2026
- Redactar capítulo “Análisis de problemas” -> 28/06/2026
- Redactar capítulo “Conclusiones” -> 04/07/2026
- Crear PPT -> 18/07/2026