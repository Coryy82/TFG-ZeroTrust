# Timeline de Correos con el Tutor (Héctor)

> **Propósito:** Material primario inmutable. Recoge los correos verbatim entre Pau Pérez Marco y el tutor Héctor desde noviembre de 2025 hasta la entrega del TFG.
> **Uso recomendado:** Fuente de verdad para reconstruir decisiones, validar interpretaciones del feedback del tutor y citar literalmente en la memoria si fuera necesario.
> **Documentos relacionados:**
> - [`00_DIRECTRICES_TUTOR.md`](00_DIRECTRICES_TUTOR.md) — síntesis normativa de las directrices destiladas de estos correos.
> - [`BITACORA_REUNIONES.md`](BITACORA_REUNIONES.md) — resumen cronológico por hitos.

---

## 1. 2025-11-19 — Pau → Héctor (contacto inicial)

> Buenas tardes,
>
> Mi nombre es Pau Pérez Marco, soy estudiante de último año de ingeniería informática interesado en dedicarme a la seguridad informática. Por este motivo, me gustaría realizar el TFG sobre algún tema relacionado con este ámbito, con la intención de posteriormente matricularme en el máster de ciberseguridad.
>
> Por mi cuenta he estudiado un poco sobre el área, realizando algunas formaciones, pero dado que este campo es muy extenso y se trata relativamente poco en la carrera, me gustaría pedirle consejo sobre qué tema en concreto podría desarrollar para el trabajo, especialmente si estuviera relacionado con el ámbito de las redes o el pentesting.
>
> Gracias por su atención y disculpe las molestias.
> Un saludo.

---

## 2. 2025-11-25 — Héctor → Pau (acotar intereses)

> Buenas tardes, Pau:
>
> Me alegra ver tu interés en orientar tu TFG hacia seguridad informática.
>
> Como comentas, es un campo muy amplio: no es lo mismo trabajar en aspectos de redes y pentesting que en explotación binaria (SSP, ASLR, etc.), en inteligencia artificial aplicada a ciberseguridad, en fuzzing, en análisis de malware, en forense digital, etc. Precisamente por eso, para poder orientarte bien necesito que acotes un poco más tus intereses.
>
> Lo que suelo pedir a los alumnos es que, antes de reunirnos, piensen y escriban 1–2 posibles líneas/ámbitos que les llamen especialmente la atención (por ejemplo: pentesting de aplicaciones web, seguridad en redes, explotación binaria, uso de IA para detección de ataques, etc.) y qué tipo de trabajo se imaginan haciendo en ese ámbito (más práctico/experimental, más de investigación bibliográfica, desarrollo de herramientas, análisis de casos, etc.).
>
> Te propongo lo siguiente:
> - Elige uno o dos ámbitos dentro de seguridad (por ejemplo, relacionados con redes o pentesting, si es lo que más te interesa).
> - Escríbeme un breve párrafo por cada opción indicando:
>   - El área concreta (p.ej. "seguridad en redes WiFi", "pentesting web", "automatización de pruebas con fuzzing", etc.).
>   - Qué te gustaría hacer en el TFG en ese ámbito (ejemplos de ideas, aunque sean preliminares).
>
> Con esa información podré decirte qué líneas son más razonables como TFG y, si procede, concretamos una reunión para acabar de enfocar bien el tema.
>
> Un saludo,
> Héctor

---

## 3. 2025-12-01 — Pau → Héctor (líneas candidatas)

> Buenas tardes,
>
> Primero de todo le agradezco que haya mostrado interés en mi propuesta.
>
> Como ya comenté en mi primer correo he tocado más cosas de redes y pentesting (por un lado hice la rama de redes y por el otro he hecho cursos básicos de pentesting por mi cuenta), pero mi objetivo, es poder tocar todas las áreas de la seguridad informática.
>
> En mi caso me imagino haciendo trabajos de análisis prácticos de intrusiones y sus contramedidas.
>
> Dada mi preferencia por las redes y el pentesting empezaré por eso:
>
> **Pentesting de redes:** Tengo algo de experiencia al haberlo tratado en la rama de redes (en la asignatura de seguridad en redes informáticas). En este TFG podría simular una pequeña red, analizarla y estudiar técnicas de intrusión, a la vez que podría diseñar un sistema de detección de ataques y como un buen trabajo de un blue team podría mitigar estos ataques (mediante vlans, nat, firewalls, etc.).
>
> **Algo que me llamó la atención mientras investigaba sobre la inteligencia artificial aplicada a ciberseguridad:** La creación de un watchdog de redes locales o públicas que pueda analizar el tráfico, detectar y clasificar malware. En este caso, tengo poca experiencia con los modelos de entrenamiento de inteligencia artificial pero me parece una idea interesante.
>
> El fuzzing también me parece interesante pero las 2 que más me llaman la atención son estas. Espero que esto haya especificado un poco más lo que busco.
>
> Muchas gracias por su tiempo
> Un saludo,
> Pau

---

## 4. 2026-01-09 — Héctor → Pau (luz verde a pentesting/redes)

> Hola Pau,
>
> Gracias por tu correo y feliz año.
>
> La opción de pentesting/redes es totalmente viable y da bastante juego para plantear un entorno de laboratorio, probar técnicas de intrusión y proponer/validar contramedidas (detección, segmentación, reglas, etc.).
>
> Como siguiente paso, te propongo que prepares un primer borrador con los ítems/secciones del TFG y 2–3 frases por sección sobre qué incluirías y qué objetivo tendría cada parte. Con ese material, podemos agendar una reunión (Teams o presencial) y aterrizar el planteamiento con algo más concreto.
>
> Un saludo,
> Hector.

---

## 5. 2026-02-02 — Pau → Héctor (primer borrador con enfoque ZT)

> Buenas tardes Héctor,
>
> He preparado el primer borrador con los apartados del TFG.
>
> Me interesaba que fuese aplicable al contexto actual así que lo he planteado como un estudio comparativo entre la seguridad tradicional y el modelo Zero Trust. La idea es simular infraestructuras de empresas que utilizan virtualización con Docker y probar su resistencia.
>
> Espero que este planteamiento te parezca adecuado, espero tus comentarios.
>
> Muchas gracias por tu tiempo.
> Un saludo,
> Pau Pérez Marco

---

## 6. 2026-02-05 — Héctor → Pau (corrección de enfoque)

> Buenos dias Pau,
>
> El planteamiento está bien y encaja en ciberseguridad, pero ahora mismo se lee más como arquitectura/despliegue que como análisis de seguridad.
>
> Para que quede claramente "pentesting + defensas", añade un apartado de modelo de amenazas y define 2–3 escenarios de ataque concretos (post-explotación: movimiento lateral, robo/abuso de credenciales, exfiltración, etc.).
>
> En "Pruebas", fija métricas comparables entre ambos escenarios.
>
> Reduce detalle de "cómo montar Docker" a lo imprescindible y pon el foco en qué se ataca, qué se mide y por qué Zero Trust mejora (o no).
>
> Como siguiente paso, envíame varias opciones de título y un resumen bien trabajado. Cuando te dé el OK tras revisarlo, lo subes tú a la plataforma de propuestas y yo lo valido allí.
>
> Un saludo,
> Hector.

---

## 7. 2026-02-11 — Pau → Héctor (duda sobre resumen y modelo de amenazas)

> Buenos días Héctor,
>
> Gracias por la aclaración, realizaré esos cambios.
>
> Me surge una duda, ¿con el resumen te refieres al apartado "resumen" del TFG? (tengo entendido que es algo que se hace al final del proceso) ¿o te refieres a una versión resumida del documento? (cada sección resumida), es decir, un borrador más extendido.
>
> Y, por último, entiendo que el apartado de modelo de amenazas se situaría dentro del apartado de "Pruebas".
>
> Gracias de nuevo por la información
> Un saludo,
> Pau

---

## 8. 2026-02-13 — Héctor → Pau (clarificación resumen + concepto de amenazas)

> Hola Pau,
>
> Por desgracia para la propuesta se tiene que hacer con titulo y con resumen al inicio. A mi también me parece que debería hacerse al final pero actualmente está así.
>
> El modelo de amenazas se refiere a que vas a considerar en el trabajo qué es y qué no es una amenaza para ti, osea que tipo de amenazas vas a cubrir. Cuando lo tengas un poco mas avanzado lo hablamos si quieres, junta dudas y hacemos un Teams!
>
> Un saludo,
> Hector.

---

## 9. 2026-02-28 — Pau → Héctor (modelo de amenazas v1 + títulos + resumen)

> Buenas tardes Héctor,
>
> Primero de todo, disculpa la demora, estoy trabajando a tiempo completo, le estoy dedicando principalmente los findes a avanzar con el TFG y justo me puse malo este finde.
>
> Segundo, he podido avanzar en lo que me propusiste:
>
> Siguiendo tus recomendaciones, he añadido los siguientes modelos de amenazas al borrador:
>
> - **Movimiento lateral**
>   - Métricas específicas: Superficie de Ataque Interna Visible (visible desde el nodo inicial)
> - **Robo de datos**
>   - Métricas específicas: Volumen de datos fugados
> - **MITM**
>   - Métricas específicas: Integridad del flujo de tráfico
>
> Y como métricas generales, comunes para los 3:
> - Tiempo de Detección: Segundos hasta que el sistema alerta.
> - Profundidad del ataque: Número de nodos internos alcanzados.
> - Tasa de bloqueo: Éxito o fracaso de la contención automatizada.
>
> Se basan, como me recomendaste, en ataques post-explotación y creo que estas 3 cubren por lo menos lo básico.
>
> **Opciones de título:**
> 1. Análisis y comparativa de eficacia entre modelos de Defensa Perimetral y Zero Trust ante escenarios de post-explotación en infraestructuras contenerizadas.
> 2. Evaluación de seguridad en infraestructuras Docker: Mitigación de movimiento lateral y exfiltración mediante micro-segmentación.
> 3. Auditoría de arquitecturas de red: Impacto del modelo Zero Trust en la contención de amenazas persistentes y exfiltración de datos.
>
> **El resumen para presentar sería el siguiente:**
>
> > Las nuevas arquitecturas basadas en microservicios y contenedores han servido para optimizar el despliegue de infraestructuras de red, pero frecuentemente, estos despliegues heredan configuraciones de red planas que amplían la superficie de ataque interno. En este contexto, las defensas perimetrales tradicionales resultan ineficaces cuando un atacante logra comprometer un servicio expuesto, facilitando la escalada de privilegios y el compromiso total del sistema.
> >
> > Este Trabajo de Fin de Grado presenta un análisis comparativo entre el modelo de seguridad perimetral tradicional y un modelo de arquitectura basada en principios Zero Trust mediante micro-segmentación. Para ello, se diseñan y despliegan dos infraestructuras funcionalmente idénticas. Ambas arquitecturas son sometidas a auditorías de seguridad focalizadas en escenarios de post-explotación y mediante la evaluación de métricas de contención y detección, el estudio cuantifica la eficacia de cada modelo de red. El trabajo busca demostrar que la implementación de una arquitectura Zero Trust bloquea eficazmente el movimiento lateral, mitiga el impacto de las intrusiones y resulta fundamental para garantizar la resiliencia en redes corporativas modernas.
>
> Quedo a la espera de tu validación del título y el resumen para subirlo a la plataforma.
>
> Muchas gracias por tu tiempo.
> Un saludo,
> Pau Pérez Marco

---

## 10. 2026-03-11 — Héctor → Pau (corrección crítica del modelo de amenazas)

> Hola Pau,
>
> He revisado lo que me has enviado, pero como te comentava en el correo anterior "El modelo de amenazas se refiere a que vas a considerar en el trabajo qué es y qué no es una amenaza para ti", pero no has puesto nada concrerto.
>
> Normalmente se refiere a algo más de este estilo:
> - qué asumes del atacante
> - qué activos quieres proteger
> - qué superficie entra en el estudio
> - qué amenazas sí vas a considerar
> - qué amenazas quedan fuera del alcance
>
> O sea, más que una lista de ataques concretos, es el marco de alcance del trabajo.
>
> Lo que tu comentas es mas bien post-explotación, osea una vez te han explotado, qué cosas pueden hacer, que si movimiento lateral, exfiltrar, etc pero en ese punto ya está tarde, ya te han explotado, eso no es una "amenaza" tal cual la entendemos nosotros sino mas bien accesiones a realizar después.
>
> En cuanto al titulo debe reflejar lo más importante del trabajo, piensa que es el core del trabajo y propón 3 títulos pero que no sean tan diferentes, tienen que ser muy parecidos para ver cual respuesta mejor el trabajo.
>
> Inténtalo este feedback y me vuelves a enviar algo cuando lo tengas.
>
> Un saludo,
> Hector.

---

## 11. 2026-03-17 — Pau → Héctor (modelo de amenazas v2 + títulos homogéneos)

> Buenos días Héctor,
>
> Gracias por la corrección. Siguiendo tus recomendaciones y como estamos analizando el comportamiento y la eficacia de cada arquitectura de red, sigo partiendo de un contexto de post-explotación por lo que:
>
> - **Qué asumo del atacante:** Asumo un atacante (externo) no privilegiado que ha logrado explotar una vulnerabilidad en un servicio (Web) y obtiene ejecución de código remota. No asumo que tenga acceso al host físico y credenciales de admin de la red.
> - **Activos a proteger:** El más crítico es la BBDD y el código fuente alojado en los servicios de backend (archivos .env).
> - **Superficie estudiada:** La superficie que entra está compuesta por la red interna de contenedores.
> - **Amenazas a considerar:** Se consideraría amenazas el movimiento lateral, interceptación de tráfico interno y la exfiltración de datos hacia el exterior.
> - **Amenazas fuera del alcance:** Quedan fuera del estudio ataques de ingeniería social, seguridad física, vulnerabilidades del kernel subyacente y todo aquel que no esté relacionado con poner a prueba la microsegmentación.
>
> Para que los títulos propuestos sean más similares entre sí:
> 1. Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas.
> 2. Evaluación de seguridad en infraestructuras contenerizadas: Comparativa entre modelos de Defensa Perimetral y Zero Trust
> 3. Estudio comparativo de contención de amenazas en entornos contenerizados: Defensa Perimetral frente a arquitectura Zero Trust.
>
> A priori el resumen quedaría igual, dime si necesitas que cambie algo de él también.
>
> Espero que con este enfoque el alcance esté correctamente delimitado
> Un saludo y gracias de nuevo por la guía,
> Pau.

---

## 12. 2026-04-09 — Héctor → Pau (validación del alcance y los títulos)

> Hola Pau,
>
> Ahora sí, así está mucho mejor planteado y el alcance queda bastante más claro.
>
> La delimitación del modelo de amenazas está bien enfocada: queda claro qué asumes del atacante, qué activos quieres proteger, qué entra dentro del estudio y qué amenazas consideras o dejas fuera. Con este enfoque, el trabajo ya queda mejor encuadrado como análisis de seguridad.
>
> Los títulos también van en la línea adecuada, porque son bastante homogéneos entre sí y reflejan bien el núcleo del trabajo.
>
> En principio, por mi parte lo veo bien así. Si quieres, puedes mantener de momento el resumen como está y más adelante ya afinamos algún detalle de redacción si hiciera falta.
>
> Un saludo,
> Hector

---

## 13. 2026-04-19 — Pau → Héctor (confirmación de subida + dudas metodológicas)

> Buenas tardes Héctor,
>
> Genial, muchas gracias por la confirmación. ¿Te parece entonces si subo a la plataforma la propuesta con el Título 1 (*Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas*)?
>
> Cambiando de tema, ya llevo unas semanas que he empezado a investigar y trastear con el despliegue de las redes contenerizadas en Docker y a estudiar conceptos de Zero Trust.
>
> Dado que voy a empezar a montar configuraciones, me gustaría pedirte consejo sobre metodología de trabajo: ¿Cómo me recomiendas planificar y documentar esta fase de laboratorio y pruebas? Quiero llevar una buena trazabilidad para facilitar la redacción en el futuro.
>
> Había pensado en ir apuntando en un archivo lo que voy haciendo cada vez que me ponga a trabajar (como un diario), pero no estoy seguro hasta qué punto se debe reflejar en el trabajo final cada cambio que haya habido a lo largo del proceso de creación de la solución. Por ejemplo, si corrijo un archivo de configuración en gran parte, ¿se debe reflejar a la hora de redactar la elaboración de la solución? o, por otro lado ¿las fuentes que vaya investigando ahora de Zero Trust, las voy simplemente apuntado para luego incluirlas en la bibliografía?.
>
> Cualquier consejo tuyo me será de gran ayuda
> Un saludo,
> Pau

---

## 14. 2026-04-20 — Héctor → Pau (luz verde + directrices metodológicas)

> Buenos días Pau,
>
> Sí sube la propuesta y la valido (seguramente también necesitaras resumen y keywords etc).
>
> Sobre el laboratorio, te recomiendo que no improvises sesión a sesión, sino que trabajes con un plan sencillo. Intenta repartir el tiempo entre tres bloques: montar y probar el laboratorio, buscar y ordenar referencias, y avanzar poco a poco en la memoria. Aunque sea de forma básica, conviene que tengas previsto qué quieres tener hecho y para cuándo.
>
> Además, lleva un diario de trabajo breve: qué has probado, qué cambios has hecho, qué ha funcionado y qué no. Eso te dará trazabilidad y luego te facilitará mucho la redacción.
>
> En la memoria final no hace falta reflejar cada cambio menor, solo las decisiones, ajustes y resultados que sean realmente relevantes para explicar la solución. Muchas veces los alumnos se centran solo en la parte técnica y se pierden ahí, pero el porqué de las decisiones es igual o incluso más importante que el propio montaje técnico. Si hace falta poner configuraciones extendidas usa anexos.
>
> Y las fuentes que vayas consultando ahora te conviene guardarlas ya, porque luego te servirán tanto para el marco teórico como para la bibliografía.
>
> Un saludo,
> Hector.

---

## 15. 2026-05-24 — Pau → Héctor (solicitud convocatoria julio)

> Buenos días Héctor,
>
> Te escribo para comentarte un par de cosas. Primero, decirte que voy avanzando en el TFG, tengo algunos artículos y material para redactar el Estado del Arte y voy a empezar a montar el Escenario con Zero Trust. Mis próximos pasos serán redactar la Introducción y el Estado del Arte y estudiar y montar la red Zero Trust.
>
> Segundo, mi contrato a tiempo completo está por terminar y me ha surgido la duda sobre qué tan realista sería entregar el TFG para la convocatoria de julio, sé que es un poco precipitado, pero me preguntaba si habría opción de llegar si le dedico muchas horas. Esto lo haría con el fin de poder optar a un master y no perder prioridad por no tener el TFG.
>
> Un saludo y gracias de antemano,
> Pau Pérez Marco

---

## 16. 2026-05-24 — Héctor → Pau (luz verde condicionada a borrador)

> Buenos días Pau,
>
> Lo podemos intentar sí.
>
> Lo que suelo pedir es un "mínimo" para realizar la propuesta (es mejor eso que luego echarse atrás).
>
> La idea sería que tuvieras un borrador lo antes posible sobre qué cosas vas a tratar en cada parte del TFG. Para ello tienes que hacer un trabajo de ver otros TFGs como lo hacen etc. Se supone que estas cosas debéis empezar ya a realizarlas como parte del TFG (no solo la parte técnica).
>
> Así que mira los plazos, hazte un plan, y cuando tengas algo "razonablemente decente" para enseñarme, me lo pasas y lo hablamos para ver si llegamos.
>
> Un saludo,
> Hector.

---

## 17. 2026-06-06 — Pau → Héctor (índice anotado — recuperación hito 31/05)

> Buenos días Héctor,
>
> Disculpa la demora. He revisado otros trabajos como me indicaste y, con la parte técnica del laboratorio ya avanzada (ambos escenarios desplegados), he preparado el borrador del índice.
>
> Adjunto el índice anotado del TFG.
> Por el lado de la redacción, tengo empezados el Estado del Arte y el Diseño de la solución.
>
> ¿Es razonablemente decente este planteamiento para continuar hacia la memoria?
>
> Gracias de antemano,
> Pau Pérez Marco

---

## 18. 2026-06-06 — Héctor → Pau (validación del borrador + feedback objetivos)

> Buenos días Pau,
>
> Sí, pero hay matices siempre. Por ejemplo cuando dices
>
> "Objetivo principal: comparar dos arquitecturas funcionalmente idénticas, Perimetral vs Zero Trust, sometidas a la misma auditoría post-explotación."
>
> En realidad, tu objetivo es mas amplio, no es "comparar" es responder a una pregunta clave e importante. Tienes que vender la "cabra", pensar bien lo que quieres transmitir, ligarlo bien al problema y a la solución etc.
>
> En general lo veo bien, si quieres avanzando y cuando tengas contenido quedamos un día en mi despacho y lo repasamos y te doy feedback.
>
> Un saludo,
> Hector.

---

## 19. 2026-06-16 — Pau → Héctor (borrador caps. 2–6 + solicitud de cita)

> Buenas tardes Hector,
>
> Gracias por las recomendaciones, dediqué un tiempo a ver otros trabajos y además enfoqué un poco más la redacción a responder a la pregunta de por qué Zero Trust era mejor que lo tradicional.
>
> Te adjunto lo que he redactado del trabajo (caps 2-6), a excepción de la Introducción y las Conclusiones. Está copiado directamente del borrador a la plantilla del TFG de la ETSINF, por lo que falta adaptarlo del todo a Latex y meter las figuras y tablas.
> Aún tengo dudas sobre donde poner x contenido porque hay partes que empecé a redactar hace tiempo que me parece que no acaban de ajustarse del todo al capítulo (Por ejemplo, la sección 5.4 no sé si debería ir al capítulo de pruebas)
>
> Lo siguiente que haré será acabar de redactar los últimos capítulos que me faltan y meter figuras y tablas donde hagan falta.
>
> Si lo ves bien, tengo disponibilidad para acercarme a repasarlo.
>
> Gracias de antemano,
> Pau.

---

## 20. 2026-06-19 — Pau → Héctor (PDF casi final: caps. 1–3 y 6–7 pulidos; 4–5 pendientes)

> Hola de nuevo Héctor,
>
> He realizado algunos cambios en la redacción en los capítulos 1-3 y 6-7, mañana acabaré con el repaso y redactaré mejor los capitulos 4-5 de diseño y desarrollo, pero de momento, salvo esos dos caps que te digo, sería la versión final (y a excepción de tablas y figuras que lo voy a dejar para el final)
>
> Gracias de antemano,
> Pau

---

## Estado al cierre del timeline

- **Propuesta:** APROBADA por el tutor el 2026-04-09 y oficializada en EBRON entre el 2026-04-19 y el 2026-04-27.
- **Título oficial:** *Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas*.
- **Modelo de amenazas:** validado en su versión v2 (correo 2026-03-17 → respuesta 2026-04-09).
- **Resumen:** validado provisionalmente, abierto a afinar redacción más adelante.
- **Metodología de trabajo:** acordada en el correo 2026-04-20 (origen normativo del [`00_DIRECTRICES_TUTOR.md §5–§6`](00_DIRECTRICES_TUTOR.md)).
- **Convocatoria objetivo:** **julio 2026**. Deadline de entrega: **21/06/2026**. Luz verde del tutor tras borrador "razonablemente decente" enviado el **2026-06-06** (§17–§18). Ver [`00_DIRECTRICES_TUTOR.md §7`](00_DIRECTRICES_TUTOR.md).
- **Borrador índice anotado:** ENVIADO 2026-06-06. Validación general positiva; matizar redacción de objetivos (pregunta de investigación, no solo "comparar"). Próximo paso acordado: cita en despacho cuando haya contenido redactado.
- **Borrador memoria caps. 2–6:** ENVIADO 2026-06-16 (§19). Incluye reorientación hacia la pregunta de investigación (Zero Trust vs. tradicional). Sin Introducción ni Conclusiones en el adjunto. Plantilla ETSINF/LaTeX sin figuras ni tablas definitivas. Duda editorial pendiente: ubicación de §5.4. Solicitud de cita presencial. **Respuesta del tutor:** pendiente a **2026-06-18**.
- **PDF casi final (Borrador1.2.tex):** ENVIADO 2026-06-19 (§20). Caps. 1–3 y 6–7 con repaso de redacción; caps. 4–5 pendientes de pulir (previsto 20/06); tablas y figuras al final. **Respuesta del tutor:** pendiente.
- **Depósito plataforma ETSINF:** COMPLETADO ~2026-06-21. Memoria final en `DocumentoFinalOverleaf.tex`.
- **PDF versión final al tutor:** ENVIADO post-21/06. Memoria completa (caps. 1–7, figuras, tablas, anexos, glosario). Solicitud defensa julio.
- **Feedback tutor (versión final):** RECIBIDO post-21/06 (§21). Luz verde julio. Ajustes: contextualizar figuras, corregir CWE, repasar formato. Incorporado.
- **Fase actual (2026-07-08):** preparación defensa oral. Blueprint: `Esqueleto-Presentacion-TFG.md`.

---

## 21. Post-21/06 — Pau → Héctor (versión final + solicitud defensa julio)

> Hola Héctor,
>
> Respecto al PDF que te mandé el viernes, he cerrado lo que faltaba: repaso de los capítulos 4 y 5 (diseño y desarrollo), tablas de resultados del capítulo 6, figuras, bibliografía, anexos (configuraciones, protocolo de pruebas, scripts de captura y código de la aplicación) y glosario.
>
> Adjunto la versión final del TFG.
>
> Por mi parte, si puede ser y en caso de que lo veas bien, prefiero solicitar la defensa ya para julio.
>
> Gracias y espero su respuesta,
> Pau

---

## 22. Post-21/06 — Héctor → Pau (luz verde julio + feedback formato/CWE)

> Buenos días Pau,
>
> Justo te he contestado hace poco a un correo anterior. Esta version está mucho mejor, creo que no hay problema en que vayas a Julio.
>
> Quizá el formato si lo repasaría un poco, algunas paginas están un poco cargadas de imágenes pero no de texto (ejemplo pag. 25), lo ideal es que comentes algo de la imagen y que hagas referencia a ella, a poder ser, en un texto explicativo (evita las frases cortas) explica qué es interesante.
>
> Por ejemplo en:
>
> "Filtrado de rutas internas en 'robots.txt' (CWE-200) (figura 5.3)"
>
> --> Aquí hay 2 problemas: 1) la frase no dice que tengo que ver de la imagen [...] 2) [...] no se muy bien que quires decir con eso, ¿Por qué lo has puesto? [...]
>
> He visto este fallo repetido por todo el trabajo, creo que debes repasar ambas cosas.
>
> Venga que ya casi lo tienes.
>
> Un saludo,
> Hector.
