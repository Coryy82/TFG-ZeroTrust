# Capítulo 1 — Introducción

> **Estado:** ESQUELETO — redactar en fase intensiva semana 4 (15/06).
> Se redacta PENÚLTIMO (antes del resumen). Hasta no tener el resto no se sabe qué se presenta.
> Gancho de motivación: URL/noticia Endesa (`docs/01_investigacion/TFG-EstadoDelArte.md`) + coste creciente de ciberdelincuencia.

---

## 1.1 Motivación

[DONE] Párrafo de apertura con el gancho concreto: incidente de seguridad real (caso Endesa u otro con datos de coste) + estadística de crecimiento del coste anual de ciberdelincuencia a nivel global. Enmarcar el problema: redes planas de contenedores heredadas = superficie de ataque interior no controlada.

[CITAR: estadística coste ciberdelincuencia — buscar fuente IEEE/ENISA/IBM Cost of a Data Breach 2025]

---
#### Texto redactado

[HUMANO]

Una brecha de seguridad reciente expuso los datos personales de cerca de 300.000 clientes de Endesa, una de las mayores compañías energéticas de España [CITAR: filtración de datos de Endesa — 20minutos.es]. Lejos de ser un caso aislado, incidentes como este se han vuelto frecuentes y responden a una tendencia de fondo: el coste económico de la ciberdelincuencia aumenta año tras año a escala global [CITAR: estadística coste ciberdelincuencia — IEEE/ENISA/IBM Cost of a Data Breach]. Para cualquier organización, una intrusión ha dejado de ser un suceso excepcional para convertirse en un riesgo que conviene asumir como probable.

Al mismo tiempo, la manera de construir y desplegar software ha cambiado. Las arquitecturas basadas en microservicios y contenedores se han generalizado porque agilizan el despliegue y el escalado de las aplicaciones. Esa comodidad, sin embargo, tiene una contrapartida de seguridad: muchos despliegues heredan configuraciones de red planas, en las que los servicios internos confían entre sí por el simple hecho de compartir la misma red. El resultado es una superficie de ataque interior que apenas está controlada.

El modelo de seguridad perimetral, sobre el que se ha apoyado tradicionalmente la protección de las redes corporativas, encaja mal con este escenario. Su planteamiento protege la frontera entre la red interna y el exterior, pero presupone que todo lo que sucede dentro del perímetro es de confianza. Cuando un atacante compromete un único servicio expuesto, esa confianza implícita se vuelve en su contra: puede desplazarse lateralmente, alcanzar servicios internos y bases de datos y extraer información sin volver a cruzar ninguna frontera vigilada. El modelo Zero Trust parte de la premisa opuesta y no concede confianza por defecto a ningún componente, ni siquiera a los que ya operan dentro de la red.

Este contraste entre lo que el perímetro promete y lo que realmente contiene una vez producida la intrusión es lo que motiva el presente trabajo. Más que defender un modelo frente a otro en el plano teórico, nos proponemos medir, en condiciones reproducibles, cuánto reduce el impacto de un ataque interno una arquitectura Zero Trust frente a un despliegue perimetral equivalente.

---

## 1.2 Objetivos

> **Estado:** REFORMULAR como pregunta de investigación (feedback tutor 06/06, "vender la cabra" — ver ADR 2026-06-06 en `admin/DECISIONS_LOG.md`).
> La comparativa A/B es el **método**, no el mensaje central. La pregunta debe abrir aquí y cerrarse en §7.1; debe ser coherente con §2.9 (Propuesta).

### Pregunta de investigación

[DONE] Cerrar la redacción definitiva. Formulación de trabajo ya validada con el tutor (ADR 2026-06-06):

> ¿En qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas?

---
#### Texto redactado

[HUMANO]

El trabajo se articula en torno a una única pregunta de investigación, que orienta tanto el diseño de la solución como las pruebas realizadas:

> ¿En qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas?

---

### Hipótesis

[DONE] Enunciar la hipótesis que el trabajo contrasta: la microsegmentación, la identidad de servicio (mTLS) y la observabilidad activa de un modelo Zero Trust reducen materialmente la profundidad del compromiso, el volumen exfiltrado y el tiempo de detección tras una ejecución remota, frente a un modelo perimetral funcionalmente equivalente.

---
#### Texto redactado

[HUMANO]

Como respuesta tentativa a esa pregunta partimos de la siguiente hipótesis: los mecanismos propios de una arquitectura Zero Trust, la microsegmentación de la red, la identidad de servicio mediante mTLS y la observabilidad activa, reducen de forma apreciable la profundidad del compromiso, el volumen de datos exfiltrados y el tiempo de detección tras una ejecución remota de código, en comparación con un modelo perimetral funcionalmente equivalente. El estudio se concibe para contrastar esta hipótesis con datos medibles.

---

### Objetivo principal

[DONE] Redactar el objetivo principal como la **acción de responder** a la pregunta de investigación mediante un experimento comparativo controlado y reproducible (no como "comparar dos arquitecturas").

---
#### Texto redactado

[HUMANO]

El objetivo principal de este trabajo es responder a la pregunta de investigación mediante un experimento comparativo, controlado y reproducible. Para ello desplegamos dos infraestructuras funcionalmente idénticas, una con arquitectura perimetral y otra con arquitectura Zero Trust, y las sometemos a las mismas pruebas, de modo que las diferencias observadas puedan comparar los distintos modelos de red

---

### Objetivos específicos

- Diseñar y desplegar dos infraestructuras funcionalmente idénticas (Escenario A: perimetral; Escenario B: Zero Trust) sobre Docker.
- Definir y medir un conjunto de métricas de contención y detección (G1–G3, E1–E3) comparables entre ambos escenarios.
- Ejecutar pruebas de post-explotación reproducibles (movimiento lateral, exfiltración, interceptación de tráfico) en ambos escenarios.
- Cuantificar el impacto de la microsegmentación y la observabilidad activa sobre la capacidad de contención.

> **Nota de coherencia:** cada objetivo específico debe quedar respondido en §7.1 Conclusiones (correspondencia 1:1).

---
#### Texto redactado

[HUMANO]

De este objetivo principal se derivan cuatro objetivos específicos:

- Diseñar y desplegar dos infraestructuras funcionalmente idénticas sobre Docker.
- Definir y medir un conjunto de métricas de contención y detección comparables entre ambos escenarios.
- Ejecutar pruebas de post-explotación reproducibles —movimiento lateral, exfiltración e interceptación de tráfico interno— en los dos escenarios.
- Cuantificar el impacto de la microsegmentación y la observabilidad activa sobre la capacidad de contención.

---

## 1.3 Impacto esperado

> **Estado:** ESQUELETO — apartado **Recomendable** (referencia, línea 120). El índice anotado validado lo había situado en §7.4; se adelanta aquí a la Introducción según la pauta ETSINF, y los ODS se desarrollan en §7.4 (evitar duplicación: aquí solo mención breve).

[DONE] Explicar las ventajas/mejoras que aporta el resultado del trabajo y para quién:
- Para equipos de plataforma/DevSecOps: criterio cuantitativo para justificar la inversión en microsegmentación e identidad de servicio.
- Para organizaciones con despliegues contenerizados heredados (redes planas): evidencia del riesgo real post-explotación y de la contención alcanzable.
- Relación con problemas contemporáneos y ODS (desarrollo en §7.4): ODS 9 (infraestructura resiliente) y ODS 16.

---
#### Texto redactado

[HUMANO]

Los resultados de este trabajo aspiran a ser útiles para dos perfiles:
1. Para los equipos de plataforma y de seguridad operativa (DevSecOps). Este trabajo ofrece un criterio cuantitativo con el que justificar la inversión en microsegmentación e identidad de servicio, más allá de la recomendación genérica de adoptar Zero Trust. 
2. Para las organizaciones que mantienen despliegues contenerizados heredados, que a menudo sobre redes planas, aportan evidencia del riesgo real al que se exponen tras una intrusión y del grado de contención que pueden alcanzar con controles asumibles.

En un plano más amplio, el trabajo se relaciona con los Objetivos de Desarrollo Sostenible, en particular con el ODS 9, por su contribución a infraestructuras digitales más resilientes, y con el ODS 16, por la reducción del impacto de la ciberdelincuencia. Esta relación se desarrolla en §7.4.

---

## 1.4 Metodología

> **Estado:** ESQUELETO — apartado **Recomendable** (referencia, línea 126). Figuraba como §1.3 en el índice anotado validado por el tutor; se restaura aquí. El detalle operativo del protocolo está en §6.1 (no duplicar: aquí solo el enfoque).

[DONE] Describir el enfoque experimental que guía el trabajo: diseño de dos prototipos funcionalmente idénticos, despliegue reproducible en laboratorio Docker (IaC), ejecución de la misma cadena de ataque y de los mismos hitos post-explotación en ambos escenarios, captura estructurada de evidencias y análisis cuantitativo mediante las métricas G1–G3 / E1–E3. Justificar cómo se garantiza la comparabilidad (mismo atacante simulado, misma ventana de medición desde T0_efectivo). Remitir el protocolo detallado a §6.1.

---
#### Texto redactado

[HUMANO]

El trabajo sigue un enfoque experimental. Diseñamos dos prototipos funcionalmente idénticos y los desplegamos en un laboratorio basado en Docker, definido como infraestructura como código (IaC) para que cada escenario pueda levantarse de forma reproducible. Sobre ambos ejecutamos la misma cadena de ataque y los mismos hitos de post-explotación, y capturamos de manera estructurada las evidencias generadas para su análisis cuantitativo posterior.

La comparación solo es válida si los dos escenarios se miden en las mismas condiciones. Por ese motivo empleamos el mismo atacante simulado y una ventana de medición común, que comienza en el instante en que el atacante dispone de ejecución remota en el servicio web. Así, todo lo que se mide ocurre a partir de un punto de partida equivalente en ambos escenarios. El protocolo operativo detallado se describe en §6.1.

---

## 1.5 Estructura de la memoria

[DONE] Breve párrafo de un capítulo por línea, indicando qué contiene cada uno. Se escribe cuando el resto de capítulos esté en borrador. Incluir una referencia a los contenidos de los Anexos.

[DONE] Avisar al lector de la existencia de un **Glosario de términos y acrónimos** al final de la memoria (ver `101_glosario.md`), para un tribunal no especialista en el área (pauta ETSINF, referencia líneas 137 y 357).

---
#### Texto redactado

[HUMANO]

El resto de la memoria se organiza como sigue: El capítulo 2 revisa el estado del arte: el modelo perimetral y sus limitaciones, los principios de Zero Trust y la microsegmentación, las amenazas en fase de post-explotación y los trabajos relacionados, para situar la aportación de este trabajo. El capítulo 3 analiza el problema, formaliza el modelo de amenazas, fija los requisitos y define las métricas con las que se evalúan ambos escenarios. El capítulo 4 presenta el diseño de las dos arquitecturas comparadas y justifica las decisiones tecnológicas adoptadas. El capítulo 5 describe el desarrollo y la implantación del laboratorio, incluidos los problemas de integración encontrados. El capítulo 6 expone la metodología de pruebas y los resultados de cada escenario, junto con la comparativa final entre ambos. Por último, el capítulo 7 recoge las conclusiones, las limitaciones del trabajo, las líneas de trabajo futuro y la relación con los estudios cursados y los ODS.

La memoria se completa con la bibliografía y con una serie de anexos que recogen las configuraciones extensas, ficheros de despliegue, configuración de mTLS, reglas de detección y scripts de captura de evidencias, de modo que el cuerpo del documento se mantenga legible. Asimismo, al final se incluye un glosario de términos y acrónimos, pensado para el lector no especialista en seguridad de redes, que conviene consultar ante cualquier duda sobre la terminología específica utilizada a lo largo del texto.

---

## Observaciones para revisión humana

- **Estadística de coste de ciberdelincuencia (§1.1):** no existe una fuente verificable en el repositorio; queda como `[CITAR:]`. Conviene aportar una fuente solvente (IEEE, ENISA o IBM Cost of a Data Breach).
- **Caso Endesa (§1.1):** la única fuente disponible es una noticia de prensa (20minutos.es) con la cifra de ~300.000 clientes; no se ha podido verificar la fecha del incidente, por lo que se ha omitido. Valorar con el tutor si una noticia divulgativa es admisible como gancho o si conviene complementarla con una fuente adicional.
- **Objetivo principal (§1.2):** el índice anotado validado lo formulaba como "comparar dos arquitecturas", mientras que el esqueleto de este capítulo y el ADR 2026-06-06 piden formularlo como pregunta de investigación (la comparativa A/B es el método, no el mensaje). Se ha seguido el esqueleto; confirmar con el tutor.
- **Objetivos específicos (§1.2):** se han trasladado al texto final omitiendo los códigos de métricas G1–G3 / E1–E3, que se introducen en §3.4, para no anticipar jerga. La lista anotada del esqueleto se conserva encima del bloque.
- **Pregunta de investigación:** se reproduce de forma literal por coherencia con §3.1 y §7.1 (misma redacción en los tres puntos). Si se reformula en alguno, debe actualizarse en los tres.
