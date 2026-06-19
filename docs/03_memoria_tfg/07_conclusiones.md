# Capítulo 7 — Conclusiones

> **Estado:** ESQUELETO — redactar en semana 4 (16/06), DESPUÉS de tener los resultados cuantitativos del Cap. 6.
> Incluir: discusión de resultados, limitaciones, trabajo futuro.
> Objetivo de extensión: 4-6 páginas.

---

## 7.1 Conclusiones del estudio

[DONE] Párrafo de apertura: **responder explícitamente a la pregunta de investigación formulada en §1.2** (en qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas) y confirmar o matizar la hipótesis con los datos reales de §6.4. Mantener correspondencia 1:1 con los objetivos específicos enumerados en §1.2 (cada objetivo → resultado alcanzado).

[DONE] Para cada métrica donde ZT mejoró: cuantificar y atribuir el mecanismo. Para cada métrica donde no mejoró: razonar por qué y qué implicaría en un entorno real.

[DONE] Conclusión general: ¿confirma el estudio que la microsegmentación Zero Trust reduce materialmente el impacto de una intrusión post-explotación en infraestructuras contenerizadas?

---
#### Texto redactado

[HUMANO]

Este trabajo se planteó para responder a una pregunta concreta: ¿en qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de los ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas?. 

A partir de la evidencia recogida en la sesión oficial de cada escenario (§6.4), la respuesta es que la reducción es sustancial en casi todas las dimensiones medidas: partiendo del mismo compromiso inicial, una ejecución remota de código en el servicio web, el modelo perimetral permitió al atacante alcanzar los tres nodos de la red y extraer información, mientras que el modelo Zero Trust confinó el compromiso al nodo de entrada e impidió que los hitos post-explotación prosperaran.

La hipótesis de partida (§1.2) se confirma en lo esencial, aunque con un matiz importante. Los tres efectos previstos, menor profundidad del compromiso, menor volumen de datos exfiltrados y mayor protección del tráfico interno, se observan con claridad: la profundidad del ataque se redujo de tres nodos a uno, la exfiltración pasó de varios cientos de bytes a cero y el tráfico interno dejó de ser legible al exigirse autenticación mutua.

Más allá de esos tres efectos, el modelo Zero Trust aporta una capacidad de detección activa inexistente en el perímetro. No se trata de detectar más rápido, la latencia no es comparable, porque el modelo perimetral carece de mecanismo de detección por diseño, sino de disponer de una observabilidad de la que el escenario perimetral no dispone en absoluto (§6.4.3).

En cuanto a los objetivos específicos planteados en §1.2, los cuatro se alcanzaron. Se diseñaron y desplegaron dos infraestructuras funcionalmente idénticas que solo difieren en su modelo de red (objetivo primero, desarrollado en §4). Se definió y midió un conjunto de métricas de contención y detección estrictamente comparables entre ambos escenarios (objetivo segundo, §3.4 y §6). Se ejecutó el mismo protocolo de ataque post-explotación de forma reproducible en los dos entornos (objetivo tercero, §6.1). Y se cuantificó el impacto de la microsegmentación y la observabilidad sobre la capacidad de contención (objetivo cuarto), con la salvedad de que la observabilidad demostró su valor de forma parcial.

El análisis por indicadores permite atribuir cada mejora a un mecanismo concreto. 
- La reducción de la profundidad del ataque y de la superficie interna visible es consecuencia directa de la microsegmentación en tres zonas y de la decisión de que el backend escuche solo en su interfaz de loopback: el atacante conserva la shell en el nodo de entrada, pero no encuentra rutas útiles hacia la base de datos. 
- El bloqueo de los comandos post-explotación combina tres controles: la separación de secretos por servicio, la autenticación mutua en el canal hacia el backend y la propia segmentación, de modo que ninguno de los objetivos del atacante sobre los activos protegidos llega a completarse. De ahí se derivan también la anulación de la exfiltración y la protección del tráfico.

En conjunto, el estudio respalda que una arquitectura Zero Trust basada en microsegmentación e identidad de servicio reduce de forma significativa el impacto de una intrusión post-explotación en una infraestructura contenerizada. Conviene enmarcar esta conclusión en las condiciones del experimento: los valores proceden de una sola sesión oficial por escenario en un laboratorio local (§7.2), por lo que describen el comportamiento de los controles más que una estimación estadística. Aun así, el contraste es lo bastante nítido, y los mecanismos que lo producen lo bastante claros, como para sostener la conclusión con confianza dentro de ese alcance.

---

## 7.2 Limitaciones del trabajo

[TODO] Honestas y concretas:
- Entorno de laboratorio local: los resultados son reproducibles pero no directamente extrapolables a despliegues en producción con múltiples nodos o en cloud.
- mTLS implementado en un único canal (webapp ↔ backend): un escenario de producción requeriría mTLS en toda la malla de servicios.
- Wazuh sin dashboard ni respuesta automatizada: las alertas son pasivas, no bloquean el ataque en tiempo real (SOAR queda fuera del alcance).
- El atacante tiene RCE como punto de partida asumido: el TFG no estudia cómo prevenir el compromiso inicial, solo cómo contener el daño post-explotación.

---
#### Texto redactado

[IA - REVISAR]

Las conclusiones anteriores deben leerse a la luz de varias limitaciones que acotan su validez.

La principal es el tamaño de la muestra. Los valores comparados proceden de una única sesión oficial por escenario; son reproducibles mediante los scripts de captura y coherentes con el comportamiento esperado de cada control, pero no constituyen una estimación estadística con intervalos de confianza. Las cifras concretas —la reducción de la profundidad o de la superficie visible, el porcentaje de bloqueo— deben interpretarse como ilustrativas del comportamiento de cada arquitectura, no como medias de una población de ensayos.

El alcance del experimento es la segunda limitación. El estudio parte de un atacante que ya dispone de ejecución remota de código en el servicio web: no evalúa cómo se previene el compromiso inicial, sino qué ocurre después. Esta delimitación es deliberada y coherente con el modelo de amenazas (§3.2), pero implica que las conclusiones se refieren a la contención del daño post-explotación y no a la seguridad del sistema en su conjunto.

A ello se suman las limitaciones de diseño ya expuestas en §4.5, que también condicionan la generalización de los resultados: el mTLS protege un único canal, la observabilidad se despliega sin respuesta automatizada y el entorno es un laboratorio local sobre Docker, no un clúster en producción. No las repetimos aquí, pero conviene tenerlas presentes al trasladar las conclusiones a un escenario real.

Por último, la cobertura de detección resultó parcial. El bloqueo de los hitos fue completo, pero el mecanismo de observabilidad no registró la totalidad de las acciones del atacante: las de muy corta duración pudieron transcurrir entre dos muestreos consecutivos. Esto no afecta a la contención —que depende de los controles de red e identidad—, pero sí matiza cualquier afirmación sobre la capacidad de detección del sistema.

---

## 7.3 Trabajo futuro

[DONE] Lista concreta y realista de las líneas de mejora más relevantes:

- **Escalado a Kubernetes:** implementar las mismas políticas de red con NetworkPolicies de Kubernetes y un Service Mesh (Istio/Envoy). Los resultados serían directamente aplicables a entornos cloud.
- **mTLS completo en toda la malla de servicios:** extender mTLS al canal `backend ↔ db`. Añadir rotación automática de certificados (cert-manager).
- **Suricata como IDS de red complementario:** añadir una capa de detección network-based (firmas de tráfico) en paralelo a la detección host-based de Wazuh. Permite detectar ataques que evaden la detección host.
- **Respuesta automatizada (SOAR):** integrar Wazuh con un mecanismo de respuesta activa que bloquee la conexión o el contenedor cuando se detecta uno de los 4 hitos post-RCE.
- **Ataques adicionales:** spoofing DNS interno, escalada de privilegios en el host, ataques de denegación de servicio interna.
- **Evaluación en entorno cloud real:** despliegue en AWS/GCP/Azure con VPC, Security Groups y herramientas cloud-native de ZT.

---
#### Texto redactado

[HUMANO]

Las limitaciones anteriores señalan de forma natural las líneas de trabajo futuro más relevantes.

La validez externa de los resultados se reforzaría llevando el experimento a un orquestador real: reimplementar las mismas políticas con NetworkPolicies de Kubernetes y un service mesh (Istio/Envoy) permitiría comprobar si la contención observada se mantiene a escala y en un entorno cloud, más cercano a producción.

La protección del tráfico interno, hoy limitada a un único canal, debería extenderse a toda la malla de servicios —en particular al canal entre el backend y la base de datos— e incorporar rotación automática de certificados, de modo que la identidad de servicio deje de ser una excepción y pase a ser la norma del sistema.

La cobertura de detección parcial justifica añadir una capa de detección a nivel de red, como Suricata, que complemente a la detección basada en host: los ataques que evadan el muestreo de procesos podrían detectarse entonces por sus patrones de tráfico.

El carácter pasivo de las alertas invita a incorporar respuesta automatizada (SOAR): vincular la detección de un hito post-explotación con una acción de contención —aislar el contenedor o cortar la conexión— cerraría el ciclo entre detectar y responder.

Por último, sería valioso ampliar el repertorio de ataques: envenenamiento de DNS interno, escalada de privilegios en el host o denegación de servicio interna, y repetir el estudio con varias sesiones por escenario, lo que daría soporte estadístico a las cifras y reduciría la principal limitación del trabajo actual.

---

## 7.4 Relación del trabajo desarrollado con los estudios cursados e impacto (ODS)

> **Estado:** ESQUELETO — apartado **Obligatorio** según `00_PAUTAS_IMPORTANTES_MEMORIA/EstucturayContenidodeunTFG.md` (línea 291). Figura como §7.4 en el índice anotado validado por el tutor. Redactar en la semana 4 (16/06), junto con §7.1–§7.3.
> No es una repetición de resultados: es un ejercicio de introspección sobre qué conocimientos del Grado se han puesto en juego.

### 7.4.1 Relación con los estudios cursados

[DONE] Justificar que el contenido del TFG es conforme a los estudios cursados. Vincular con asignaturas y áreas concretas de la titulación:
- Redes y Seguridad (modelo perimetral vs Zero Trust, microsegmentación, mTLS).
- Sistemas Distribuidos / Infraestructuras (contenedores Docker, arquitectura de servicios).
- Administración de sistemas / Sistemas Operativos (WSL2, namespaces, procesos, sockets).
- Ingeniería del Software (requisitos, diseño, IaC, reproducibilidad).

[DONE] Indicar qué conocimientos o tecnologías NO se vieron en la carrera (o se vieron de forma insuficiente) y que hubo que aprender para este TFG (Wazuh/SIEM, OpenSSL/mTLS, SSTI Jinja2, MITRE ATT&CK), y el grado de dominio alcanzado.

[DONE] Competencias transversales puestas en práctica (p. ej. análisis crítico, comunicación escrita, planificación y gestión del tiempo del sprint) y en qué grado.

---
#### Texto redactado

[HUMANO]

El desarrollo de este trabajo puso en juego buena parte de los conocimientos adquiridos durante el Grado, integrados en torno a un problema concreto. 

Los fundamentos de redes y seguridad fueron el eje: la contraposición entre el modelo perimetral y Zero Trust, la microsegmentación y la autenticación mutua con certificados parten directamente de esos contenidos. El diseño del laboratorio se apoyó en lo aprendido sobre sistemas distribuidos e infraestructuras, al estructurar la aplicación en servicios contenerizados que se comunican entre sí. La puesta en marcha exigió nociones de administración de sistemas y de sistemas operativos, espacios de nombres, procesos, sockets y la ejecución sobre WSL2, y todo el trabajo se ordenó con prácticas de ingeniería del software: especificación de requisitos, diseño previo, infraestructura como código y reproducibilidad.

Junto a lo anterior, el trabajo obligó a aprender tecnologías y conceptos que no forman parte del plan de estudios, o que solo se tratan de forma tangencial. Hubo que familiarizarse con un sistema de detección basado en host (Wazuh) y la escritura de sus reglas, con la generación y el uso de certificados para mTLS mediante OpenSSL, con la explotación de inyección de plantillas del lado del servidor (SSTI) como vector de acceso inicial y con los marcos de clasificación de amenazas como MITRE ATT&CK. El grado de dominio alcanzado fue suficiente para diseñar, desplegar y validar los controles, si bien cada una de estas tecnologías admite una profundización que excede el alcance del trabajo.

Por último, el trabajo desarrolló competencias transversales relevantes: el análisis crítico de los resultados sin sobrevalorarlos, la comunicación escrita de un problema técnico para un lector no especialista y la planificación y gestión del tiempo en un sprint con plazos ajustados.

---

### 7.4.2 Impacto y relación con los ODS

[DONE] Explicar las ventajas/mejoras que aporta el trabajo (contención de intrusiones, resiliencia de redes corporativas contenerizadas) e identificar usuarios beneficiados. Relacionar con los ODS:
- ODS 9 (Industria, innovación e infraestructura): infraestructuras digitales más resilientes.
- ODS 16 (Paz, justicia e instituciones sólidas): reducción del impacto de la ciberdelincuencia.

[CITAR: ODS — https://www.un.org/sustainabledevelopment/es/objetivos-de-desarrollo-sostenible/]

---
#### Texto redactado

[HUMANO]

Más allá del ejercicio académico, el trabajo aporta un criterio cuantitativo allí donde suele haber recomendaciones genéricas. Para los equipos de plataforma y de seguridad operativa, mostrar con datos cuánto se reduce el alcance de una intrusión al introducir microsegmentación e identidad de servicio ofrece un argumento concreto con el que priorizar esas inversiones. Para las organizaciones que mantienen despliegues contenerizados sobre redes planas heredadas, el estudio evidencia el riesgo real al que se exponen una vez comprometido un servicio y el grado de contención que pueden alcanzar con controles asumibles.

Esta aportación conecta con dos Objetivos de Desarrollo Sostenible [CITAR: ODS — https://www.un.org/sustainabledevelopment/es/objetivos-de-desarrollo-sostenible/]. Con el ODS 9, en tanto que contribuye a infraestructuras digitales más resilientes frente a incidentes: una red que contiene el movimiento lateral se degrada de forma controlada en lugar de comprometerse por completo. Y con el ODS 16, porque reducir el impacto de las intrusiones, el volumen de datos expuestos y el alcance del compromiso, limita el daño que la ciberdelincuencia causa sobre ciudadanos e instituciones.

---

## Observaciones para revisión humana

- **Duplicación §7.2 ↔ §4.5 (decisión tomada):** tres de las cuatro limitaciones del esqueleto de §7.2 (entorno local, mTLS en un solo canal, Wazuh sin SOAR) ya figuraban en §4.5 «Limitaciones del diseño». Para evitar la repetición, §4.5 se mantiene como lugar canónico de las limitaciones de diseño y §7.2 se reenfoca a las que afectan a la validez de las conclusiones (muestra n=1, alcance post-RCE, cobertura de detección parcial), remitiendo a §4.5 para el resto. No se ha borrado contenido de §4.5. Confirmar que esta división convence.
- **Cifras n=1:** todas las conclusiones cuantitativas se enmarcan como sesión oficial única; si se ejecutan más sesiones, conviene actualizar §7.1 y suavizar la limitación de §7.2.
- **Detección (G1):** se concluye que la capacidad de detección activa solo existe en Zero Trust, no que detecte más rápido (la comparación de latencia no es simétrica por la ausencia de SIEM en el Escenario A).
- **Cobertura de detección parcial:** basada en §6.3.3 (las reglas de `curl` y `grep` no se dispararon); se presenta como matiz honesto, no como fallo del diseño.
- **Asignaturas (§7.4.1):** se citan áreas genéricas del Grado; el autor debe sustituirlas por los nombres reales de las asignaturas de su plan de estudios.
- **Cita ODS (§7.4.2):** pendiente de formato bibliográfico definitivo (`[CITAR:]`).
