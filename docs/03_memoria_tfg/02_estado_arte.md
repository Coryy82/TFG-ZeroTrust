# Capítulo 2 — Estado del Arte

> **Estado:** REDACTAR PRIMERO — semana 1 fase intensiva (25-30/05). Independiente del laboratorio.
> Insumos disponibles: `docs/01_investigacion/` (Docker101, SSTI Jinja2, Prototipo Red Perimetral).
> Objetivo de extensión: 10-12 páginas.
> Filtro del tutor: análisis de seguridad, no manual de arquitectura. Cada sección termina con implicación de seguridad.
> Gestión de citas: usar marcadores `[CITAR: fuente §sección]` inline mientras se redacta.

---

## 2.1 Evolución hacia infraestructuras contenerizadas

[REVISAR] De servidores monolíticos a microservicios. Docker como estándar de facto. Kubernetes para orquestación. La "comodidad" de las redes planas por defecto (`bridge` en Docker) y sus implicaciones de seguridad: visibilidad total entre contenedores de la misma red, sin control de flujo lateral.

[CITAR: Docker networking documentation / paper IEEE sobre contenedores y seguridad]

### Texto redactado:
NO APLICA A ESTE TFG, DOCKER ES SIMPLEMENTE UNA HERRAMIENTA DE TRABAJO PARA DESPLEGAR Y SIMULAR UNA RED CORPORATIVA PERO EL OBJETIVO DEL TFG ES ANALIZAR PERIMETRAL VS ZERO TRUST.

## 2.2 El modelo de seguridad perimetral y sus limitaciones

[DONE] Definición del modelo perimetral (firewall en el borde, confianza implícita en la red interna). Por qué funciona bien contra amenazas externas pero falla ante amenazas internas (post-explotación, movimiento lateral). Estadística de brechas que se originan desde dentro del perímetro.

[CITAR: NIST SP 800-207 §1 — introducción al problema de la confianza implícita]
[CITAR: IBM Security Cost of a Data Breach 2024/2025 — porcentaje de brechas con origen interno o post-compromiso]

### Texto redactado:

> IA:
>La seguridad perimetral ha constituido durante décadas el paradigma predominante para la protección de redes corporativas. Este modelo se fundamenta en la creación de una frontera de seguridad entre la red interna y los entornos externos mediante mecanismos como firewalls, sistemas de filtrado y controles de acceso, asumiendo que los usuarios y dispositivos ubicados dentro del perímetro son entidades confiables. Históricamente, este enfoque resultó eficaz en organizaciones con infraestructuras centralizadas y límites de red claramente definidos, donde la principal amenaza procedía de actores externos. Sin embargo, diversos estudios han señalado limitaciones significativas cuando un atacante consigue superar los controles perimetrales. La confianza implícita otorgada a los sistemas internos favorece actividades de post-explotación, incluyendo movimiento lateral, escalada de privilegios y acceso no autorizado a recursos corporativos. Asimismo, la supervisión del tráfico interno presenta dificultades que pueden retrasar la detección de comportamientos maliciosos. La evidencia empírica reciente refuerza estas limitaciones: el informe Verizon DBIR 2025 identifica el abuso de credenciales y la explotación de vulnerabilidades entre los principales vectores de acceso inicial, mientras que casi un tercio de las brechas analizadas en la región EMEA tuvo origen interno. Estos resultados evidencian que la protección exclusiva del perímetro resulta insuficiente frente a amenazas que operan desde dentro de la red o tras comprometer los mecanismos de acceso inicial.


---

> HUMANO:
> La seguridad perimetral ha constituido durante décadas el paradigma predominante para la protección de redes corporativas. Este modelo utiliza una frontera entre una red interna y la externa como elemento de seguridad, para ello utiliza mecanismos como firewalls, filtros y controles de acceso. A su vez, asume que los usuarios y dispositivos ubicados dentro del perímetro, dentro de la red, son entidades confiables.
> Históricamente, este enfoque resultó eficaz en tiempos donde las organizaciones tenían infraestructuras centralizadas y límites de red claramente definidos, y en tiempos donde la principal amenaza procedía de actores externos. Sin embargo, con el paso de los años, se han ido observando limitaciones significativas cuando un atacante consigue superar los controles perimetrales. La confianza otorgada a los sistemas internos favorece increíblemente actividades de post-explotación, incluyendo movimiento lateral, escalada de privilegios y acceso no autorizado a recursos críticos. Asimismo, la supervisión del tráfico interno presenta dificultades que pueden retrasar la detección de comportamientos maliciosos.
> Asimismo, la evidencia reciente refuerza estas limitaciones: en 2025 se identificó el abuso de credenciales y la explotación de vulnerabilidades entre los principales vectores de acceso y explotación inicial, mientras que casi un tercio de las brechas tuvo origen interno. Estos resultados evidencian que la protección exclusiva del perímetro resulta insuficiente frente a amenazas que operan desde dentro de la red o que consiguen superar los mecanismos de acceso inicial

## 2.3 El modelo Zero Trust

[DONE] Origen del término (Forrester Research, John Kindervag, 2010). Principios fundamentales: "nunca confíes, siempre verifica", acceso de mínimo privilegio, microsegmentación, verificación explícita de identidad. Evolución hasta BeyondCorp (Google, 2014) como implementación real a escala.

[CITAR: NIST SP 800-207 §2 — principios Zero Trust Architecture]
[CITAR: BeyondCorp: A New Approach to Enterprise Security (Google, 2014)]

### Texto redactado:

> IA:
>El modelo Zero Trust surgió formalmente en 2010 a partir de los trabajos de John Kindervag en Forrester Research, como respuesta a las limitaciones de los enfoques de seguridad basados en la confianza implícita dentro de las redes corporativas. Su propuesta se fundamenta en la premisa de que ningún usuario, dispositivo o sistema debe considerarse confiable por defecto, independientemente de su ubicación, dando origen al principio “never trust, always verify”. Con el tiempo, este planteamiento evolucionó desde una propuesta conceptual hasta convertirse en un marco de referencia ampliamente reconocido por organismos de estandarización y entidades gubernamentales. La publicación NIST SP 800-207 consolidó esta evolución al definir una arquitectura Zero Trust basada en la verificación continua de identidades, la autorización dinámica, el acceso de mínimo privilegio y la evaluación contextual de usuarios, dispositivos y recursos. Asimismo, la microsegmentación y la protección centrada en los recursos se establecieron como mecanismos esenciales para reducir la superficie de ataque y limitar el impacto de posibles compromisos. Un hito fundamental en la adopción práctica del modelo fue BeyondCorp, desarrollado por Google a partir de 2014. Esta iniciativa trasladó los principios de Zero Trust a una infraestructura empresarial de gran escala, sustituyendo la confianza basada en la ubicación de red por decisiones de acceso fundamentadas en la identidad del usuario y el estado de los dispositivos. La experiencia de Google demostró la viabilidad operativa del modelo y contribuyó significativamente a su difusión y consolidación en la industria y la comunidad académica.


---

> HUMANO:
 >El modelo Zero Trust apareció oficialmente en 2010 como respuesta a las limitaciones de los enfoques de seguridad basados en la confianza implícita dentro de las redes corporativas. Su propuesta se fundamenta en la premisa de que ningún usuario, dispositivo o sistema debe considerarse confiable por defecto, dando origen al principio "never trust, always verify".
> Con el tiempo, este planteamiento evolucionó hasta convertirse en un marco de referencia. La publicación NIST SP 800-207 consolidó esta evolución al definir una arquitectura Zero Trust basada en la verificación continua de identidades, la autorización dinámica, el acceso de mínimo privilegio y la evaluación contextual de usuarios, dispositivos y recursos. Debido al impacto que tuvo, la microsegmentación y la protección centrada en los recursos se establecieron como mecanismos esenciales para reducir la superficie de ataque. BeyondCorp, desarrollada por Google en 2014, fue la primera iniciativa en trasladar los principios de Zero Trust a una infraestructura empresarial de gran escala, sustituyendo la confianza basada en la ubicación de red por reglas de acceso fundamentadas en la identidad del usuario y el estado de los dispositivos, esto contribuyó significativamente a la difusión del modelo y a la demostración de su viabilidad, lo que concluyó en su consolidación en la industria y la comunidad académica.

## 2.4 Microsegmentación en entornos contenerizados

[DONE] Cómo se implementa Zero Trust a nivel de red en Docker: redes separadas por función (web, backend, datos), políticas de conectividad explícitas, identidad de servicio (mTLS entre contenedores). Comparativa con enfoques alternativos: Network Policies de Kubernetes, Service Mesh (Istio/Envoy).

[CITAR: NIST SP 800-207 §3 — implementaciones de ZTA]
[CITAR: paper IEEE / USENIX sobre microsegmentación en contenedores]

### Texto redactado:

> IA:
>Los principios del modelo Zero Trust se materializan en gran medida mediante técnicas de microsegmentación, cuyo objetivo es eliminar la confianza implícita entre recursos internos y establecer controles de acceso granulares sobre las comunicaciones de red. De acuerdo con NIST SP 800-207, la microsegmentación permite restringir el acceso entre servicios y limitar la exposición de recursos, reduciendo así la superficie de ataque y dificultando el movimiento lateral de un atacante tras una posible intrusión. En entornos contenerizados, esta estrategia suele implementarse mediante la creación de redes virtuales independientes que agrupan servicios según su función, como componentes frontend, backend o bases de datos. Docker proporciona mecanismos de aislamiento de red que permiten definir explícitamente qué contenedores pueden comunicarse entre sí, aplicando el principio de mínimo privilegio a nivel de conectividad. Adicionalmente, las arquitecturas modernas incorporan mecanismos de identidad de servicio y autenticación mutua mediante certificados digitales para reforzar la confianza entre componentes distribuidos. En escenarios de mayor escala, Kubernetes amplía estas capacidades mediante Network Policies, que permiten controlar el tráfico de ingreso y salida entre pods mediante reglas declarativas y etiquetas. Por otra parte, los enfoques basados en Service Mesh, como Istio apoyado en Envoy, complementan la microsegmentación incorporando identidad criptográfica de servicios, autenticación mutua (mTLS), observabilidad avanzada y políticas de autorización basadas en identidad. En conjunto, estas tecnologías representan distintas aproximaciones para aplicar los principios de Zero Trust en infraestructuras contenerizadas, con diferentes niveles de granularidad, escalabilidad y complejidad operativa.

---

> HUMANO:
> Los principios de Zero Trust consisten en gran medida en técnicas de microsegmentación, cuyo objetivo es eliminar la confianza entre recursos internos y establecer controles de acceso sobre las comunicaciones de red. La microsegmentación permite restringir el acceso entre servicios y limitar la exposición de recursos, de esta forma se reduce la superficie de ataque y dificulta el movimiento lateral de un atacante tras una intrusión. En entornos contenerizados, como aquellos gestionados por Kubernetes (común en redes corporativas modernas), esta estrategia suele implementarse mediante la creación de redes virtuales independientes que agrupan servicios según su función (frontend, backend o bases de datos). Para ayudar a este fin, docker proporciona mecanismos de aislamiento de red que permiten definir explícitamente qué contenedores pueden comunicarse entre sí. Además de esto, las arquitecturas modernas incorporan mecanismos de identidad de servicio y autenticación mutua mediante certificados digitales para reforzar la confianza entre componentes distribuidos. A mayor escala, se utilizan Network Policies, que permiten controlar el tráfico de ingreso y salida entre pods mediante reglas declarativas y etiquetas.

## 2.5 Sistemas de detección y observabilidad (SIEM/IDS)

[REVISAR] Papel del SIEM en un modelo Zero Trust: no solo detectar, sino correlacionar eventos de múltiples fuentes para identificar comportamiento anómalo. Wazuh como solución open-source para entornos Docker. Comparativa Wazuh vs Suricata: Wazuh orientado a host-based detection (logs, integridad de ficheros, reglas de correlación); Suricata orientado a network-based detection (captura de paquetes, firmas). Justificación de la elección para este TFG.

[CITAR: Wazuh documentation — agent deployment en Docker]
[CITAR: Suricata documentation — network IDS/IPS]

### Texto redactado
No veo necesario cubrir esto en el estado del arte ya que no forma parte del enfoque principal del TFG

## 2.6 Amenazas en entornos post-explotación de contenedores

[DONE] Descripción técnica de las amenazas en alcance del TFG:
- **Movimiento lateral:** un atacante con RCE en un contenedor web accede a servicios internos no expuestos externamente.
- **Exfiltración de datos:** extracción de credenciales y datos de la base de datos sin cruzar el perímetro externo.
- **Interceptación de tráfico interno:** ausencia de cifrado en tráfico inter-contenedor (HTTP plano observable con tcpdump).

[CITAR: OWASP Top 10 — A05:2021 Security Misconfiguration (redes planas)]
[CITAR: MITRE ATT&CK — Lateral Movement (TA0008), Exfiltration (TA0010)]

### Texto redactado
> IA
> A pesar de los mecanismos de aislamiento proporcionados por las plataformas de contenedores, la obtención de ejecución de código dentro de una carga de trabajo sigue constituyendo un punto de partida relevante para actividades de post-explotación. NIST SP 800-190 señala que un contenedor comprometido puede convertirse en una plataforma desde la que explorar recursos internos, acceder a servicios auxiliares y obtener información sensible disponible dentro del entorno contenerizado. En arquitecturas basadas en microservicios, donde numerosos componentes intercambian información mediante comunicaciones internas, un atacante puede aprovechar la conectividad existente para descubrir APIs, servicios backend o bases de datos que no se encuentran expuestos externamente. Diversos marcos de análisis de amenazas, como MITRE ATT&CK for Containers y Kubernetes Threat Matrix, documentan técnicas de reconocimiento interno, abuso de credenciales y movimiento lateral utilizadas para ampliar progresivamente el alcance del compromiso. Asimismo, la presencia de secretos en variables de entorno, archivos de configuración, volúmenes compartidos o mecanismos de almacenamiento insuficientemente protegidos puede facilitar la exfiltración de credenciales y datos sensibles. Otro riesgo significativo está relacionado con las comunicaciones este-oeste entre servicios. Tanto NIST SP 800-207 como la documentación de Istio y SPIFFE destacan que la pertenencia a una red interna no debe considerarse una garantía de confianza, ya que un atacante con presencia en el entorno puede capturar y analizar tráfico no cifrado para obtener credenciales, tokens o información confidencial en tránsito. Estas amenazas adquieren especial relevancia en entornos cloud-native debido al elevado número de interacciones entre servicios y a la creciente complejidad de las dependencias internas, lo que incrementa las oportunidades de expansión del compromiso una vez superada la fase inicial de acceso.

---

> HUMANO:
> A pesar de los mecanismos de protección proporcionados, la obtención de ejecución de código remota dentro de una aplicación sigue constituyendo un punto de partida relevante para actividades de post-explotación. Un contenedor comprometido puede convertirse en una plataforma desde la que explorar recursos internos, acceder a servicios auxiliares y obtener información sensible dentro del entorno. En arquitecturas basadas en microservicios, un atacante puede aprovechar la conectividad existente entre componentes para descubrir APIs, servicios backend o bases de datos que no se encuentran expuestos externamente. Diversos marcos de análisis de amenazas, como MITRE ATT&CK for Containers y Kubernetes Threat Matrix, documentan técnicas de reconocimiento interno, abuso de credenciales y movimiento lateral utilizadas para ampliar progresivamente el alcance del compromiso. Asimismo, la presencia de secretos en variables de entorno, archivos de configuración, volúmenes compartidos o mecanismos de almacenamiento insuficientemente protegidos puede facilitar la exfiltración de credenciales y datos sensibles. Otro riesgo significativo está relacionado con las comunicaciones este-oeste entre servicios: cuando el tráfico interno no está cifrado, un atacante con presencia en el entorno puede capturar credenciales o información confidencial en tránsito.
> Estas amenazas adquieren especial relevancia en entornos cloud-native debido al elevado número de interacciones entre servicios y a la creciente complejidad de las dependencias internas, lo que incrementa las oportunidades de expansión del atacante una vez superada la fase inicial de acceso.


## 2.7 Trabajos relacionados

[DONE] Revisión de TFG/TFM similares y posicionamiento respecto al estado del arte. Fuentes: `docs/01_investigacion/TFG_Otros/`.

[CITAR: Jiménez 2025 TFG UPM — implementación ZT laboratorio]
[CITAR: Pérez TFG G6508 — Zero Trust como concepto]
[CITAR: Torregrosa 2025 TFG UPV — NAC y acceso corporativo]
[CITAR: Vico 2025 TFM UPV — SIEM Wazuh Suricata]

### Texto redactado [HUMANO]

En los últimos años han proliferado trabajos académicos que abordan Zero Trust desde ángulos distintos: implementación en laboratorio, análisis conceptual, control de acceso a la red corporativa u observabilidad centralizada. Sin embargo, al revisar la literatura y los trabajos de fin de grado o máster más cercanos al ámbito de este proyecto, se observa un patrón recurrente: demuestran la viabilidad de un enfoque concreto, pero rara vez miden de forma cuantitativa qué ocurre **después** de un compromiso inicial en una infraestructura contenerizada. La evidencia que compara modelo perimetral y Zero Trust con métricas operativas reproducibles —tiempos de detección, profundidad alcanzada por el atacante, bloqueo de hitos post-explotación— sigue siendo escasa [CITAR: Investigacion_ZeroTrust §Resumen Ejecutivo].

Jiménez [CITAR: Jiménez 2025 TFG UPM — implementación ZT laboratorio] diseña e implementa un entorno Zero Trust híbrido simulado con identidad federada, segmentación mediante firewall y aplicación web en Flask; valida autenticación y políticas de acceso de forma funcional, pero no ejecuta una cadena adversarial post-explotación ni contrasta el resultado con un escenario perimetral de referencia. Pérez [CITAR: Pérez TFG G6508 — Zero Trust como concepto] profundiza en el marco teórico —modelos frente a arquitecturas, visión de fabricantes, normalización NIST— y plantea un despliegue ZTNA a escala empresarial, sin experimento que cuantifique el impacto de un atacante ya presente en la red. Torregrosa [CITAR: Torregrosa 2025 TFG UPV — NAC y acceso corporativo] aborda el acceso local mediante NAC y segmentación dinámica alineada con Zero Trust, centrado en quién entra a la red corporativa, no en qué puede hacer un servicio comprometido en comunicaciones este-oeste entre microservicios. Vico [CITAR: Vico 2025 TFM UPV — SIEM Wazuh Suricata] integra Wazuh, Suricata y un SIEM corporativo para centralizar la detección; su aportación está en el pipeline de observabilidad y los casos de uso de alertas, no en comparar arquitecturas de red ni en medir la contención del movimiento lateral tras una ejecución remota.

Este trabajo se sitúa en ese hueco. La pregunta que guía el estudio no es simplemente si dos despliegues son distintos, sino **en qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas**. Para responderla, desplegamos la misma aplicación vulnerable en dos topologías —perimetral y Zero Trust— y reproducimos el mismo protocolo de ataque a partir de una reverse shell en el servicio web, midiendo detección, profundidad del compromiso y bloqueo de los hitos descritos en las secciones anteriores. Docker Compose actúa como herramienta de laboratorio para simular la red corporativa, sin pretender replicar un clúster Kubernetes productivo. En conjunto, los trabajos revisados confirman que identidad, segmentación y observabilidad son piezas maduras por separado; este TFG las cruza en un experimento controlado que enlaza las limitaciones del perímetro (§2.2), las amenazas post-explotación (§2.6) y el diseño comparativo desarrollado en los capítulos siguientes.