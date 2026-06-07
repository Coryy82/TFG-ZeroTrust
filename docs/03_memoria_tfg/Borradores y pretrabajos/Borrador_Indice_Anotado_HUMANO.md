# Título: Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas

---

## 0. Resumen / Abstract
Las nuevas arquitecturas basadas en microservicios y contenedores han servido para optimizar el despliegue de infraestructuras de red, pero frecuentemente, estos despliegues heredan configuraciones de red planas que amplían la superficie de ataque interno. En este contexto, las defensas perimetrales tradicionales resultan ineficaces cuando un atacante logra comprometer un servicio expuesto, facilitando la escalada de privilegios y el compromiso total del sistema.

Este Trabajo de Fin de Grado presenta un análisis comparativo entre el modelo de seguridad perimetral tradicional y un modelo de arquitectura basada en principios Zero Trust mediante micro-segmentación. Para ello, se diseñan y despliegan dos infraestructuras funcionalmente idénticas. Ambas arquitecturas son sometidas a auditorías de seguridad focalizadas en escenarios de post-explotación y mediante la evaluación de métricas de contención y detección, el estudio cuantifica la eficacia de cada modelo de red. El trabajo busca demostrar que la implementación de una arquitectura Zero Trust bloquea eficazmente el movimiento lateral, mitiga el impacto de las intrusiones y resulta fundamental para garantizar la resiliencia en redes corporativas modernas.

---

## 1. Introducción

### 1.1 Motivación

El contexto actual de ciberseguridad corporativa (aumento de ataques, coste económico, adopción de microservicios en Docker) y por qué el modelo perimetral tradicional falla una vez comprometido un servicio expuesto.

### 1.2 Objetivos

- Objetivo principal: comparar dos arquitecturas funcionalmente idénticas, Perimetral vs Zero Trust, sometidas a la misma auditoría post-explotación.
- Objetivos secundarios: despliegue reproducible mediante IaC, definición de métricas comparables, evaluación de controles de segmentación, identidad y detección.

Delimitar qué se va a demostrar y qué queda explícitamente fuera del alcance técnico.

### 1.3 Metodología

Enfoque experimental: diseño de prototipos, despliegue en laboratorio Docker, ejecución de cadenas de ataque idénticas en ambos escenarios, captura de evidencias y análisis cuantitativo.

Explicar cómo se garantiza la comparabilidad metodológica entre Escenario A y Escenario B.

### 1.4 Estructura de la memoria

Descripción breve de cada capítulo y su relación con el hilo narrativo del trabajo. Orientar al lector sobre la organización del documento.

---

## 2. Estado del arte

### 2.1 Evolución hacia infraestructuras contenerizadas

De servidores monolíticos a contenedores Docker; redes planas por defecto en despliegues docker-compose y las vulnerabilidades de seguridad que esto introduce.

Situar el problema técnico en el contexto de la industria y justificar por qué un laboratorio Docker es representativo.

### 2.2 El modelo perimetral y sus limitaciones

Defensa en profundidad clásica, firewall perimetral, confianza implícita en la red interna.

 Definir la red perimetral como el estado actual de muchos despliegues.

### 2.3 El modelo Zero Trust

Principios:
1. Verificación explícita
2. Mínimo privilegio
3. Assume breach

Aplicación de la metodología Zero Trust a entornos distribuidos.

Establecer el marco conceptual

### 2.4 Microsegmentación en entornos contenerizados

Segmentación de red en Docker, identidad de servicio y separación de secretos.

Conectar la teoría Zero Trust con mecanismos implementables en el prototipo.

### 2.5 Observabilidad en arquitecturas de defensa

Mención de que los marcos Zero Trust incluyen visibilidad continua. Comentar la elección de Wazuh como solución de observabilidad.

### 2.6 Amenazas en entornos post-explotación

Tipos:
- Movimiento lateral
- Exfiltración de credenciales
- Escaneo interno y captación de tráfico
- Técnicas MITRE ATT&CK relevantes

Vincular el marco teórico con los escenarios de ataque que se ejecutarán en las pruebas.

### 2.7 Trabajos relacionados

Revisión de TFG/TFM similares y posicionamiento de este trabajo respecto al estado del arte académico.

---

## 3. Análisis del problema

### 3.1 Descripción del problema

Formalización del problema: una infraestructura Docker con red plana permite al atacante, tras comprometer `webapp`, alcanzar `backend` y `db` sin controles de contención ni detección activa.

### 3.2 Modelo de amenazas

- Atacante: externo, no privilegiado, con RCE en el servicio web; sin acceso físico ni credenciales de admin de red.
- Activos: base de datos y credenciales/código en backend (`.env`).
- Superficie: red interna de contenedores Docker.
- En alcance: movimiento lateral, interceptación de tráfico interno, exfiltración.
- Fuera de alcance: ingeniería social, seguridad física, kernel, DoS, vectores ajenos a la microsegmentación.



### 3.3 Especificación de requisitos

Requisitos funcionales y no funcionales. Traducir el modelo de amenazas en criterios verificables para el diseño y las pruebas.

### 3.4 Definición de métricas

Los 6 métricas comparables: 
1. Tiempo de detección
2. Profundidad del ataque
3. Tasa de bloqueo
4. superficie interna visible
5. volumen exfiltrado
6. integridad del tráfico


---

## 4. Diseño de la solución

### 4.1 Visión general del sistema comparativo

Diagrama de alto nivel de ambos escenarios. Misma aplicación, diferente modelo de red y controles de seguridad.

Presentar la arquitectura comparativa.

### 4.2 Escenario A — Arquitectura perimetral

Topología de red plana, todos los servicios en la misma red bridge, un único punto de entrada.

Describir escenario perimetral, que reproduce configuraciones Docker habituales en producción.

### 4.3 Escenario B — Arquitectura Zero Trust

Principios Zero Trust aplicados: 
- 3 redes Docker
- secretos separados por servicio
- mTLS webapp↔backend
- Wazuh manager (capa auxiliar  de observabilidad)

Describir el escenario Zero Trust y cómo cada control responde a una amenaza del modelo de amenazas.

### 4.4 Tecnología utilizada y justificación

Stack elegido: Docker Compose (IaC), OpenSSL (certificados mTLS), Nginx (proxy TLS), Wazuh 4.x (SIEM/HIDS). 

Tabla comparativa de alternativas descartadas (Suricata como NIDS, no implementada por alcance)

Justificar cada decisión tecnológica

### 4.5 Limitaciones del diseño

Alcance reducido: mTLS solo en webapp y backend, un agente Wazuh, sin dashboard custom, sin despliegue en Kubernetes/cloud.
Aclarar qué representa el prototipo y qué no pretende ser.

---

## 5. Desarrollo e implantación

### 5.1 Infrastructure as Code — Escenario A

 Estructura de red perimetral, servicios y redes.

### 5.2 Desarrollo del Escenario B

Implementación de la metodología por fases:
1. segmentación 3 zonas
2. separación de secretos
3. mTLS con certificados OpenSSL
4. stack Wazuh (manager + agente Docker)
5. reglas de detección

Documentar las decisiones de implementación relevantes

### 5.3 Puesta en marcha del laboratorio

Procedimiento de despliegue, verificación de contenedores desplegados correctamente, integración de la red Wazuh con las redes ZT, etc.

### 5.4 Problemas de integración y soluciones

Aportar trazabilidad técnica mencionando casos de troubleshooting con contenedores, volúmenes, Wazuh, etc.

---

## 6. Pruebas y resultados

### 6.1 Metodología de pruebas

Entorno, protocolo de ejecución idéntico en los dos escenarios.

Garantizar que la comparativa es metodológicamente rigurosa y reproducible.

### 6.2 Resultados — Escenario A (perimetral)

Establecer el punto de referencia cuantitativo contra el que se mide la mejora.

### 6.3 Resultados — Escenario B (Zero Trust)

Ejecución de la misma cadena de ataque para cuantificar la eficacia de los controles Zero Trust implementados.

### 6.4 Comparativa A vs B

Tabla comparativa final, análisis cuantitativo por métrica con explicación del mecanismo ZT que produce la mejora (o no), y casos sin mejora o con degradación.
---

## 7. Conclusiones

### 7.1 Conclusiones

Respuesta a la pregunta inicial con los datos de las preubas. Qué controles ZT demostraron mayor impacto y en qué condiciones.

### 7.2 Limitaciones

Alcance del laboratorio, un host, certs autofirmados, un agente, sin tráfico real de producción, validez externa de los resultados y sesgos del atacante simulado.

### 7.3 Trabajo futuro

Extensiones no implementadas por alcance: Suricata como NIDS complementario, mTLS en todo el stack, despliegue en Kubernetes, múltiples agentes Wazuh, automatización SOAR, dashboard custom.

### 7.4 Relación con los estudios cursados e impacto (ODS)

Vinculación con asignaturas de la rama de redes y seguridad (Seguridad en Redes, Sistemas Distribuidos, etc.).

---

## 8. Bibliografía y anexos

### 8.1 Bibliografía

Aquí irá la bibliografía

### 8.2 Anexos

Aquí irán las configuraciones extensas
