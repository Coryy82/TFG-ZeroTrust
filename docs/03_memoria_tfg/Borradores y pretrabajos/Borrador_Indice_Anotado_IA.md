# Borrador índice anotado — TFG (entregable para el tutor)

> **Propósito:** Responder a la petición del tutor (correo 24/05/2026): *"un borrador lo antes posible sobre qué cosas vas a tratar en cada parte del TFG"*.
> **Formato:** Índice de 8 capítulos ETSINF + cierre, con 2–3 frases por sección (contenido previsto + objetivo de cada parte).
> **Título oficial:** *Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas*.
> **Estado del proyecto a 05/06/2026:** Escenario A (perimetral) con baseline KPI cerrada. Escenario B implementado (microsegmentación 3 zonas, mTLS webapp↔backend, Wazuh manager+agente, reglas MITRE). Pruebas A/B formales y cierre de KPIs §2/§3 pendientes (06–08/06).
> **Versión anterior:** `Borrador_Funcional_Inicial.md` (febrero 2026) — conservado como referencia histórica.

---

## 0. Resumen / Abstract

**Qué se tratará:** Síntesis del problema (redes planas en contenedores, ineficacia del perímetro tras RCE), la hipótesis (Zero Trust + microsegmentación mejora contención y detección) y los resultados esperados de la comparativa cuantitativa.

**Objetivo de la sección:** Ofrecer al lector una visión global del trabajo en una o dos páginas, cumpliendo el requisito de la propuesta oficial en EBRON.

**Estado:** Texto validado provisionalmente por el tutor (09/04/2026). Solo retoques cosméticos previstos en la revisión final.

---

## 1. Introducción

### 1.1 Motivación

**Qué se tratará:** El contexto actual de ciberseguridad corporativa (aumento de ataques, coste económico, adopción de microservicios en Docker) y por qué el modelo perimetral tradicional falla una vez comprometido un servicio expuesto.

**Objetivo:** Justificar la relevancia del estudio y conectar el TFG con un escenario realista de infraestructura contenerizada.

### 1.2 Objetivos

**Qué se tratará:** Objetivo principal (comparar dos arquitecturas funcionalmente idénticas — perimetral vs Zero Trust — sometidas a la misma auditoría post-explotación) y objetivos secundarios (despliegue reproducible mediante IaC, definición de métricas comparables, evaluación de controles de segmentación, identidad y detección).

**Objetivo:** Delimitar qué se va a demostrar y qué queda explícitamente fuera del alcance técnico.

### 1.3 Metodología

**Qué se tratará:** Enfoque experimental e iterativo: diseño de prototipos, despliegue en laboratorio Docker, ejecución de cadenas de ataque idénticas en ambos escenarios, captura de evidencias (logs, pcap, alertas SIEM) y análisis cuantitativo mediante plantilla KPI v2.

**Objetivo:** Explicar cómo se garantiza la comparabilidad metodológica entre Escenario A y Escenario B (mismo protocolo, mismo atacante simulado, misma ventana de medición desde T0_efectivo).

### 1.4 Estructura de la memoria

**Qué se tratará:** Descripción breve de cada capítulo y su relación con el hilo narrativo del trabajo (marco teórico → problema → diseño → implementación → pruebas → conclusiones).

**Objetivo:** Orientar al lector sobre la organización del documento y la progresión lógica del argumento.

---

## 2. Estado del arte

### 2.1 Evolución hacia infraestructuras contenerizadas

**Qué se tratará:** De servidores monolíticos a contenedores Docker; redes planas por defecto en despliegues docker-compose y las vulnerabilidades de seguridad que esto introduce.

**Objetivo:** Situar el problema técnico en el contexto de la industria y justificar por qué un laboratorio Docker es representativo.

### 2.2 El modelo perimetral y sus limitaciones

**Qué se tratará:** Defensa en profundidad clásica, firewall perimetral, confianza implícita en la red interna y por qué este modelo no contiene el movimiento lateral tras una RCE.

**Objetivo:** Definir el Escenario A como baseline realista del estado actual de muchos despliegues.

### 2.3 El modelo Zero Trust

**Qué se tratará:** Principios NIST SP 800-207 (verificación explícita, mínimo privilegio, asumir brecha), BeyondCorp y su aplicación a entornos distribuidos.

**Objetivo:** Establecer el marco conceptual que guía el diseño del Escenario B.

### 2.4 Microsegmentación en entornos contenerizados

**Qué se tratará:** Segmentación de red en Docker (redes bridge aisladas, políticas de conectividad por servicio), identidad de servicio y separación de secretos.

**Objetivo:** Conectar la teoría Zero Trust con mecanismos implementables en el prototipo.

### 2.5 Sistemas de detección — Wazuh vs Suricata

**Qué se tratará:** SIEM/HIDS (Wazuh) frente a NIDS (Suricata); capacidades de detección host-based vs network-based en entornos contenerizados.

**Objetivo:** Fundamentar la elección de Wazuh como solución de observabilidad del Escenario B. Suricata se analiza como alternativa pero **no se implementa** (trabajo futuro).

### 2.6 Amenazas en entornos post-explotación

**Qué se tratará:** Movimiento lateral, exfiltración de credenciales, escaneo interno y técnicas MITRE ATT&CK relevantes (T1046, T1552.004, etc.).

**Objetivo:** Vincular el marco teórico con los escenarios de ataque que se ejecutarán en las pruebas.

### 2.7 Trabajos relacionados

**Qué se tratará:** Revisión de TFG/TFM similares (arquitecturas Zero Trust simuladas, SOC/SIEM con Wazuh, NAC y segmentación) y posicionamiento de este trabajo respecto al estado del arte académico.

**Objetivo:** Demostrar conocimiento del campo y diferenciar la contribución propia (comparativa cuantitativa A vs B con KPIs definidos).

---

## 3. Análisis del problema

### 3.1 Descripción del problema

**Qué se tratará:** Formalización del problema: una infraestructura Docker con red plana permite al atacante, tras comprometer `webapp`, alcanzar `backend` y `db` sin controles de contención ni detección activa.

**Objetivo:** Transitar del marco teórico al problema concreto que el TFG resuelve.

### 3.2 Modelo de amenazas

**Qué se tratará:** Marco de alcance validado por el tutor (17/03/2026, confirmado 09/04/2026):
- **Atacante:** externo, no privilegiado, con RCE en el servicio web; sin acceso físico ni credenciales de admin de red.
- **Activos:** base de datos y credenciales/código en backend (`.env`).
- **Superficie:** red interna de contenedores Docker.
- **En alcance:** movimiento lateral, interceptación de tráfico interno, exfiltración.
- **Fuera de alcance:** ingeniería social, seguridad física, kernel, DoS, vectores ajenos a la microsegmentación.

**Objetivo:** Delimitar el estudio como análisis de seguridad (no solo despliegue), respondiendo a la corrección conceptual del tutor sobre qué es y qué no es una "amenaza" en este trabajo.

### 3.3 Especificación de requisitos

**Qué se tratará:** Requisitos funcionales (reproducir cadena de ataque, medir KPIs, bloquear/detectar 4 hitos post-RCE, evidencias verificables) y no funcionales (despliegue reproducible con `docker compose`, ejecución en hardware de escritorio, versionado Git).

**Objetivo:** Traducir el modelo de amenazas en criterios verificables para el diseño y las pruebas.

### 3.4 Definición de métricas (KPIs)

**Qué se tratará:** Los 6 KPIs comparables (G1–G3 generales: tiempo de detección, profundidad del ataque, tasa de bloqueo; E1–E3 específicos: superficie interna visible, volumen exfiltrado, integridad del tráfico). Definición operativa y protocolo de medición desde T0_efectivo.

**Objetivo:** Fijar el instrumento cuantitativo que permite responder a la hipótesis del TFG con datos, tal como exigió el tutor en la corrección de enfoque (05/02/2026).

---

## 4. Diseño de la solución

### 4.1 Visión general del sistema comparativo

**Qué se tratará:** Diagrama de alto nivel de ambos escenarios. Misma aplicación (Flask + PostgreSQL + Nginx), diferente modelo de red y controles de seguridad.

**Objetivo:** Presentar la arquitectura comparativa antes de entrar en el detalle de cada escenario.

### 4.2 Escenario A — Arquitectura perimetral

**Qué se tratará:** Topología de red plana (`perimetral_net_interna`), todos los servicios en la misma red bridge, Nginx como único punto de entrada. Ausencia intencional de SIEM/IDS. Los 4 hitos post-RCE que definen el denominador de comparación.

**Objetivo:** Documentar el baseline "antes" que reproduce configuraciones Docker habituales en producción.

### 4.3 Escenario B — Arquitectura Zero Trust

**Qué se tratará:** Principios ZT aplicados: 3 redes Docker (`web_zone`, `backend_zone`, `db_zone`), secretos separados por servicio, mTLS webapp↔backend (Nginx como PEP), Wazuh manager+agente con reglas custom alineadas a MITRE ATT&CK.

**Objetivo:** Describir el diseño "después" y cómo cada control responde a una amenaza del modelo de amenazas.

### 4.4 Tecnología utilizada y justificación

**Qué se tratará:** Stack elegido: Docker Compose (IaC), OpenSSL (certificados mTLS), Nginx (proxy TLS), Wazuh 4.x (SIEM/HIDS). Tabla comparativa de alternativas descartadas (Suricata como NIDS — no implementada por alcance; Falco como fallback documentado).

**Objetivo:** Justificar cada decisión tecnológica; el porqué pesa igual o más que el cómo (directriz del tutor, 20/04/2026).

### 4.5 Limitaciones del diseño

**Qué se tratará:** Alcance reducido del sprint: mTLS solo en webapp↔backend, un agente Wazuh, sin dashboard custom, sin despliegue en Kubernetes/cloud.

**Objetivo:** Honestidad intelectual sobre qué representa el prototipo y qué no pretende ser.

---

## 5. Desarrollo e implantación

### 5.1 Infrastructure as Code — Escenario A

**Qué se tratará:** Estructura de `infra/perimetral/`, servicios, redes y decisiones de configuración documentadas en el diario de laboratorio.

**Objetivo:** Mostrar la reproducibilidad del baseline perimetral.

### 5.2 Desarrollo del Escenario B

**Qué se tratará:** Implementación por fases en `infra/zero_trust/`: (1) segmentación 3 zonas, (2) separación de secretos, (3) mTLS con certificados OpenSSL, (4) stack Wazuh (manager + agente Docker), (5) reglas de detección para hitos post-RCE. Referencia a diarios `docs/04_diario_laboratorio/`.

**Objetivo:** Documentar las decisiones de implementación relevantes, no cada cambio menor (directriz del tutor).

### 5.3 Puesta en marcha del laboratorio

**Qué se tratará:** Procedimiento de despliegue (`docker compose up --build -d`), verificación de healthchecks, integración de la red Wazuh con las redes ZT, enrollment del agente.

**Objetivo:** Explicar cómo el diseño teórico se convierte en un entorno de ejecución operativo.

### 5.4 Problemas de integración y soluciones

**Qué se tratará:** 3–5 casos reales de troubleshooting (healthchecks en NTFS/WSL2, enrollment Wazuh, bind mounts de configuración, fallback Wazuh vs Falco descartado). Configuraciones extensas remitidas a anexos.

**Objetivo:** Aportar trazabilidad técnica y demostrar capacidad de resolución de problemas, sin saturar el cuerpo del documento.

---

## 6. Pruebas y resultados

### 6.1 Metodología de pruebas

**Qué se tratará:** Entorno (Windows 11 + WSL2 + Docker Desktop), protocolo de ejecución idéntico en A y B, definición de T0_efectivo y ventana de medición post-RCE. Separación pre-RCE/post-RCE (ADR 2026-05-12).

**Objetivo:** Garantizar que la comparativa es metodológicamente rigurosa y reproducible.

### 6.2 Resultados — Escenario A (perimetral)

**Qué se tratará:** Cronología de la sesión oficial (`perimetral_sesion_20260523`), valores baseline de KPIs §1 (G1–G3, E1–E3), evidencias (RCE, `lateral.pcap`, `creds.txt`, `lateral.json`).

**Objetivo:** Establecer el punto de referencia cuantitativo contra el que se mide la mejora.

### 6.3 Resultados — Escenario B (Zero Trust)

**Qué se tratará:** Ejecución de la misma cadena de ataque en el Escenario B. Qué hitos post-RCE quedan bloqueados (microsegmentación, mTLS) y cuáles detectados (alertas Wazuh). Valores KPI §2.

**Objetivo:** Cuantificar la eficacia de los controles Zero Trust implementados.

### 6.4 Comparativa A vs B

**Qué se tratará:** Tabla comparativa final (KPI §3), análisis cuantitativo por métrica con explicación del mecanismo ZT que produce la mejora (o no), y casos sin mejora o con degradación.

**Objetivo:** Responder a la hipótesis del TFG con datos — **corazón del trabajo**.

---

## 7. Conclusiones

### 7.1 Conclusiones

**Qué se tratará:** Respuesta a la hipótesis con los datos del Cap. 6. Qué controles ZT demostraron mayor impacto (segmentación, mTLS, detección host-based) y en qué condiciones.

**Objetivo:** Sintetizar los hallazgos del estudio comparativo.

### 7.2 Limitaciones

**Qué se tratará:** Alcance del laboratorio (un host, certs autofirmados, un agente, sin tráfico real de producción), validez externa de los resultados y sesgos del atacante simulado.

**Objetivo:** Honestidad intelectual sobre la generalización de las conclusiones.

### 7.3 Trabajo futuro

**Qué se tratará:** Extensiones no implementadas por alcance: Suricata como NIDS complementario, mTLS en todo el stack, despliegue en Kubernetes, múltiples agentes Wazuh, automatización SOAR, dashboard custom.

**Objetivo:** Abrir líneas de investigación derivadas del prototipo actual.

### 7.4 Relación con los estudios cursados e impacto (ODS)

**Qué se tratará:** Vinculación con asignaturas de la rama de redes y seguridad (Seguridad en Redes, Sistemas Distribuidos, etc.) y contribución al ODS 9 (infraestructura resiliente) y ODS 16 (sociedades pacíficas).

**Objetivo:** Cumplir requisitos ETSINF-UPV de reflexión académica personal.

---

## 8. Bibliografía y anexos

### 8.1 Bibliografía

**Qué se tratará:** Referencias académicas y técnicas (NIST 800-207, BeyondCorp, OWASP, MITRE ATT&CK, documentación Docker/Wazuh) en formato BibTeX.

**Objetivo:** Sustentar el marco teórico y las decisiones de diseño con fuentes verificables.

### 8.2 Anexos

**Qué se tratará:** Configuraciones extensas (`docker-compose.yaml`, `nginx.conf`, `local_rules.xml`, `ossec.conf`), fragmentos de `alerts.json`, capturas de pantalla de evidencias, plantilla KPI v2 completa.

**Objetivo:** Mantener el cuerpo de la memoria legible sin perder trazabilidad técnica (directriz del tutor, 20/04/2026).

---

## Cambios respecto al borrador inicial (`Borrador_Funcional_Inicial.md`)

| Aspecto | Borrador inicial (feb 2026) | Este borrador (jun 2026) |
|---------|----------------------------|--------------------------|
| Modelo de amenazas | Ausente | Sección propia en Cap. 3 (validado por tutor) |
| KPIs / métricas | Ausente | Sección propia en Cap. 3 + Cap. 6 comparativa |
| Suricata | En stack "utilizado" | Solo en EdA (justificación) y trabajo futuro |
| Python/Bash automatización | Objetivo principal | Fuera de alcance; pruebas manuales/semi con protocolo fijo |
| Desarrollo + Implantación | Dos capítulos separados | Fusionados en Cap. 5 (convención ROADMAP v2) |
| Pruebas | Párrafo genérico | 4 subsecciones: metodología, A, B, comparativa |
| Conclusiones | Solo discusión de resultados | + limitaciones, trabajo futuro, relación con estudios/ODS |
| Anexos / Bibliografía | Ausente | Cap. 8 explícito |

---

## Notas para el envío al tutor

- Este documento puede enviarse **en el cuerpo del correo** (sin adjunto) o como PDF exportado.
- El Estado del Arte (Cap. 2) está parcialmente redactado; §2.7 "Trabajos relacionados" pendiente de cerrar.
- La implementación técnica del Escenario B está **completa y verificada**; las pruebas A/B formales y el cierre de KPIs están programadas para el 06–08/06.
- Pregunta de validación sugerida: *¿Le parece razonablemente decente este planteamiento para continuar hacia la entrega del 21/06?*
