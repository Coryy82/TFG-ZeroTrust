# Capítulo 3 — Análisis del Problema



> **Estado:** BORRADOR — §3.1–§3.4 redactados [HUMANO]. Pendiente: revisión humana y alineación con §1.2 Introducción.

> El modelo de amenazas fue validado por el tutor en abril de 2026. No se altera la lógica acordada; solo se expande a prosa.

> Objetivo de extensión: 6-8 páginas.



---



## 3.1 Descripción del problema



[DONE] Formalizar el problema que motiva el TFG: infraestructuras contenerizadas con confianza implícita en la red interna; tras compromiso del servicio web expuesto, ausencia de contención y detección activa en fase post-explotación.



---

#### Texto redactado [HUMANO]



Las infraestructuras basadas en microservicios y contenedores facilitan el despliegue, pero a menudo heredan configuraciones de red en las que, una vez comprometido un servicio expuesto al exterior, el atacante puede desplazarse por la red interna, interceptar comunicaciones entre servicios y exfiltrar datos sin encontrar controles de contención ni mecanismos de detección activa. Ese patrón reproduce la limitación del modelo perimetral que ya hemos analizado en §2.2 y las amenazas post-explotación descritas en §2.6: el perímetro protege la entrada, no lo que ocurre después de una ejecución remota en la capa de aplicación.

El objetivo de este trabajo no es comparar dos despliegues por el mero contraste arquitectónico, sino responder a la pregunta de investigación siguiente: *¿En qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas?* La comparativa entre un escenario perimetral de referencia y un escenario Zero Trust es el método experimental con el que medimos esa reducción. En las secciones siguientes acotamos el modelo de amenazas, traducimos ese marco en requisitos verificables y definimos las métricas con las que cuantificaremos el impacto en el capítulo de pruebas.



---



## 3.2 Modelo de amenazas



El modelo de amenazas fue definido y validado por el tutor en abril de 2026. Se recoge aquí como marco del estudio, sin modificar los supuestos acordados.



---

#### Texto redactado [HUMANO]

El análisis del problema se centra en la fase post-explotación: asumimos que el atacante ya dispone de ejecución remota en el servicio web y medimos qué puede hacer a partir de ese punto dentro de la red de contenedores. Este acotamiento delimita el experimento frente a vectores de acceso inicial o ataques contra el host físico, los cuales quedan fuera del alcance de medición.

Los apartados §3.2.1 a §3.2.5 desarrollan las cinco dimensiones del modelo de amenazas que estructuran el resto de la memoria.



---



### 3.2.1 Asunciones sobre el atacante



- Atacante externo, no privilegiado.

- Ha logrado explotar una vulnerabilidad en el servicio web y obtiene ejecución de código remota (RCE).

- No tiene acceso físico al host ni credenciales de administración de red.



---

#### Texto redactado [HUMANO]

Consideramos un atacante externo y no privilegiado que ha explotado una vulnerabilidad en el servicio web y obtiene ejecución de código remota en el contenedor de la aplicación. No dispone de acceso físico al equipo anfitrión ni de credenciales de administración de la red corporativa. 

A partir de una reverse shell en `webapp` comienza la ventana de estudio: todo lo que se mide ocurre con el mismo nivel de privilegio dentro del namespace del contenedor comprometido.

---



### 3.2.2 Activos a proteger



- Base de datos (`db`): datos de empleados, credenciales almacenadas.

- Código fuente del backend y archivos de configuración (`.env` con credenciales de base de datos).



---

#### Texto redactado [HUMANO]

Los activos prioritarios son: 
1. La base de datos PostgreSQL, que almacena los registros de empleados y las credenciales asociadas al entorno de prueba
2. El backend de la aplicación, que concentra el código de la API interna y las variables de entorno sensibles (incluidas las credenciales de acceso a la base de datos).

Un movimiento lateral exitoso desde `webapp` comprometida puede alcanzar esos activos sin cruzar de nuevo el perímetro exterior, por eso el estudio evalúa controles que limiten ese alcance.



---



### 3.2.3 Superficie de estudio

- Red interna de contenedores Docker.

- Comunicaciones inter-servicio: `webapp ↔ backend`, `backend ↔ db`.

---

#### Texto redactado [HUMANO]

La superficie bajo análisis es la red interna de contenedores Docker y las comunicaciones este-oeste entre servicios: el flujo entre la aplicación web y el backend, y el flujo entre el backend y la base de datos. 

No evaluamos el host Windows ni la capa de orquestación fuera del experimento, el foco son los controles que cada arquitectura aplica entre contenedores una vez el atacante opera desde `webapp`.



---



### 3.2.4 Amenazas en alcance



- **Movimiento lateral:** acceso desde `webapp` comprometida a servicios internos (`backend`, `db`) no expuestos externamente.

- **Interceptación de tráfico interno:** lectura de datos en tránsito entre servicios (sin cifrado, HTTP plano).

- **Exfiltración de datos:** extracción de credenciales de base de datos y volcado de tablas hacia el exterior.



---

#### Texto redactado [HUMANO]

Dentro de ese marco consideramos tres amenazas principales:

Primero, el **movimiento lateral**: uso de la posición en `webapp` para alcanzar el backend o la base de datos sin pasar por el único punto de entrada externo.

Segundo, la **interceptación del tráfico interno** entre servicios, en particular cuando las peticiones viajan en texto claro y pueden capturarse desde el contenedor comprometido. 

Tercero, la **exfiltración de credenciales y datos almacenados**, incluido el volcado de tablas de la base de datos.

En las pruebas materializamos esas amenazas mediante cuatro hitos post-explotación comunes tanto a la red perimetral como a la red Zero Trust (§4.2.3): 
1. Exfiltración de credenciales del entorno del contenedor
2. Escaneo de la red interna
3. Acceso al backend
4. Volcado de la base de datos.

Esos hitos son el denominador comparativo entre el escenario perimetral y el escenario Zero Trust.



---



### 3.2.5 Amenazas fuera del alcance



- Ingeniería social y ataques de phishing.

- Seguridad física del host.

- Vulnerabilidades del kernel del sistema operativo subyacente.

- Ataques de denegación de servicio (DoS/DDoS).

- Vectores no relacionados con la microsegmentación de la red interna.



---

#### Texto redactado [HUMANO]



Quedan explícitamente fuera del alcance: 
1. La ingeniería social y el phishing
2. La seguridad física del dispositivo donde se hospedan las redes
3. Las vulnerabilidades del kernel del sistema operativo subyacente
4. Los ataques de denegación de servicio
5. Cualquier vector cuya mitigación no depende directamente de la microsegmentación, la identidad de servicio o la detección host-based que implementamos en el escenario Zero Trust.

Esta delimitación permite centrar el diseño y las pruebas en controles comparables entre arquitecturas sin dispersar el alcance del TFG.



---



## 3.3 Especificación de requisitos



### 3.3.1 Requisitos funcionales



| ID   | Requisito                                                                                       |

|------|-------------------------------------------------------------------------------------------------|

| Requisito-F 1 | El sistema debe reproducir una cadena de acceso inicial reproducible hasta RCE en `webapp`.  |

| Requisito-F 2 | El sistema debe medir los 6 indicadores (G1–G3, E1–E3) de forma comparable entre Escenario A y B.    |

| Requisito-F 3 | El Escenario B debe bloquear o detectar los 4 hitos post-RCE del Escenario A.                  |

| Requisito-F 4 | Las evidencias de cada escenario deben ser reproducibles y verificables (logs, capturas de tráfico,etc.) |



---

#### Texto redactado [HUMANO]

Los requisitos funcionales traducen el modelo de amenazas y la pregunta de investigación en criterios que se deben cumplir: 
- **Requisito-F 1** exige un acceso inicial reproducible hasta ejecución remota en `webapp`, de modo que el instante de inicio de la ventana post-explotación sea comparable en ambos escenarios.
- **Requisito-F 2** impone que los seis indicadores definidos en §3.4 se midan con el mismo protocolo de ataque una vez obtenida la reverse shell.
- **Requisito-F 3** vincula el escenario Zero Trust con el baseline perimetral: los cuatro hitos post-RCE alcanzables en el escenario A deben quedar bloqueados o, como mínimo, detectados en el escenario B.
- **Requisito-F 4** garantiza trazabilidad académica mediante logs, capturas de tráfico y artefactos de sesión que respalden cada valor reportado en el capítulo de resultados.

---



### 3.3.2 Requisitos no funcionales



| ID    | Requisito                                                                                        |

|-------|--------------------------------------------------------------------------------------------------|

| Requisito-NF 1 | Despliegue automatizado mediante `docker compose up` en un solo comando.                        |

| Requisito-NF 2 | El entorno debe ejecutarse en hardware de escritorio (sin infraestructura cloud).               |

| Requisito-NF 3 | Las capturas de evidencia deben almacenarse de forma estructurada y reproducible.               |

| Requisito-NF 4 | El código de infraestructura debe ser mantenible.                           |



---

#### Texto redactado [HUMANO]



Los requisitos no funcionales aseguran que el experimento sea repetible y suponen mejoras de calidad de vida para facilitar las pruebas:
- **Requisito-NF 1**: cada escenario se levanta con un único comando.
- **Requisito-NF 2**: acota el laboratorio a una estación de trabajo con Docker Desktop, sin depender de servicios cloud, lo que hace viable la réplica del estudio en condiciones académicas.
- **Requisito-NF 3**: exige que cada sesión de prueba deje una carpeta estructurada de evidencias, coherente con el protocolo de captura descrito en §5.2.4 y §5.4.
- **Requisito-NF 4**: el código debe ser mantenible (compose legible, servicios separados, etc.)

En conjunto, estos requisitos se concretan en el diseño comparativo del capítulo 4 y se verifican en las sesiones documentadas en el capítulo 6.

---

## 3.4 Definición de métricas (KPIs)

[DONE] Seis indicadores definidos en coordinación con el tutor. Aquí solo definición y operacionalización; los valores medidos corresponden a §6.4.



| Código | Nombre | Definición | Operacionalización |

|--------|--------|------------|-------------------|

| G1 | Tiempo de detección | Tiempo desde `T0_efectivo` hasta la primera alerta activa de seguridad. | Tupla `(mecanismo_existe, segundos \| ∞)`. En el escenario perimetral, ausencia de SIEM por diseño: el mecanismo no existe. En Zero Trust, segundos hasta alerta del agente de detección. |

| G2 | Profundidad del ataque | Número de nodos o servicios internos desde los que el atacante opera con éxito tras RCE en `webapp`. | Conteo de servicios alcanzados con operación útil (p. ej. `webapp`, `backend`, `db`). |

| G3 | Bloqueo de comandos desde reverse shell | Porcentaje de hitos post-RCE en los que un control impide o frustra la acción del atacante. | Tupla `(mecanismo_existe, %)`. Evaluación sobre los cuatro hitos de §3.2.4. En perimetral, sin mecanismo de bloqueo activo por diseño. |

| E1 | Superficie interna visible | Servicios y puertos internos descubiertos o alcanzables desde `webapp` tras RCE. | Recuento de servicios visibles en escaneo interno desde el contenedor comprometido. |

| E2 | Volumen de datos exfiltrados | Cantidad y naturaleza de la información extraída en la ventana post-explotación. | Registros, credenciales y bytes exfiltrados (ficheros de credenciales, volcados de API, dumps de base de datos). |

| E3 | Integridad del tráfico interno | Grado de protección de las comunicaciones este-oeste entre servicios. | Clasificación: tráfico en texto claro observable frente a TLS o conexión rechazada; evidencia mediante captura de tráfico en el contenedor. |



> **T0_efectivo:** instante en que el atacante dispone de reverse shell operativa en `webapp`. Todos los indicadores G1–G3 y E1–E3 se interpretan en la ventana post-explotación a partir de ese instante; la fase previa al RCE caracteriza el laboratorio pero no alimenta el cuadro comparativo entre escenarios.



---

#### Texto redactado [HUMANO]

Fijamos el instante de inicio de registro de evidencias en el momento en que la reverse shell en `webapp` queda operativa bajo control del atacante. A partir de ese instante medimos los seis indicadores de la tabla anterior.

Para el tiempo de detección y el bloqueo de comandos desde reverse shell empleamos una tupla `(mecanismo_existe, valor)`. En el escenario A no hay SIEM por diseño, la tupla registra la ausencia del mecanismo, en el escenario Zero Trust esperamos mecanismo activo y valor numérico medible.

Los cuatro hitos post-explotación, numerados en 3.2.4, alimentan sobre todo los indicadores de bloqueo, superficie visible y volumen exfiltrado. La integridad del tráfico se evalúa con captura de las comunicaciones entre `webapp` y `backend` durante el intento de movimiento lateral. Los valores obtenidos en cada escenario y el análisis comparativo se recogen en §6.4.

---



## Observaciones para revisión humana



- **§1.2 Introducción:** la pregunta de investigación debe repetirse con la misma redacción literal que en §3.1 cuando se redacte el capítulo 1.

- **Tabla §3.4:** confirmar si el tribunal prefiere conservar los códigos G/E en la tabla o sustituirlos por nombres en lenguaje natural únicamente (en §6.4 la prosa ya evita esos códigos).

- **RF-1:** la redacción actual menciona la cadena hasta RCE; si se desea minimizar el pre-RCE en este capítulo, puede acortarse a «acceso inicial reproducible hasta RCE en `webapp`» sin detallar pasos intermedios.



---


