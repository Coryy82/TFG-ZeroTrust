# Directrices y Expectativas del Tutor (Héctor)

Estas reglas dictadas por el tutor deben respetarse estrictamente en la redacción y ejecución del TFG:

## 1. Enfoque General del Documento (CRÍTICO)
- **Seguridad vs. Infraestructura:** El documento debe leerse como un "Análisis de Seguridad", NO como un manual de "Arquitectura/Despliegue".
- **Límite de detalle técnico:** Reducir al mínimo imprescindible las explicaciones teóricas de "cómo montar Docker".
- **Foco principal:** Centrar el texto en qué se ataca, qué se mide, y por qué Zero Trust mejora (o no) la defensa frente a la perimetral.
- **Objetivos como pregunta de investigación (correo 06/06/2026):** No reducir el objetivo del TFG a *"comparar dos arquitecturas"*. El tutor exige formular una **pregunta clave** que el trabajo responda con evidencia (problema → hipótesis → diseño → pruebas → conclusiones). La comparativa A/B es el **método**, no el mensaje central. *"Vender la cabra"*: enlazar motivación, modelo de amenazas, solución y métricas en un hilo narrativo coherente.

## 2. Redacción de la Solución (CÓMO DOCUMENTAR EL CÓDIGO)
- **Justificación sobre el montaje:** El *porqué* de las decisiones de arquitectura es IGUAL O MÁS IMPORTANTE que el propio montaje técnico. 
- **Nivel de detalle:** En la memoria final NO se debe reflejar cada cambio o error menor del laboratorio. Se documentan exclusivamente las decisiones, ajustes y resultados que sean relevantes para explicar la solución.
- **Gestión de Anexos:** Si es necesario incluir archivos de configuración extendidos (ej. un `docker-compose.yml` completo o reglas largas de firewall), estos irán OBLIGATORIAMENTE a la sección de Anexos, no en el cuerpo principal del texto.

## 3. Marco del Modelo de Amenazas (Threat Model)
Cualquier referencia al modelo de amenazas en la memoria debe estructurarse obligatoriamente en estos 5 puntos:
1. **Asunciones del atacante:** Atacante externo, no privilegiado, con ejecución de código remota (RCE) en servicio Web. Sin acceso físico ni credenciales de admin de red.
2. **Activos a proteger:** Base de datos y código fuente del backend (archivos .env).
3. **Superficie de estudio:** Red interna de contenedores.
4. **Amenazas en alcance:** Movimiento lateral, interceptación de tráfico interno, exfiltración de datos.
5. **Amenazas fuera de alcance:** Ingeniería social, seguridad física, vulnerabilidades del kernel host.

## 4. Pruebas y Métricas
- Las métricas deben ser **estrictamente comparables** entre ambos escenarios (Perimetral vs Zero Trust).
- Las pruebas deben simular escenarios de *post-explotación* (una vez la vulnerabilidad inicial ya ha sido aprovechada).

## 5. Metodología de Trabajo en Laboratorio (correo 20/04/2026)
- **Plan en lugar de improvisación:** Trabajar con un plan previo que reparta el tiempo entre tres bloques en paralelo:
  1. Montar y probar el laboratorio.
  2. Buscar y ordenar referencias bibliográficas.
  3. Avanzar progresivamente en la redacción de la memoria.
- **Diario de laboratorio breve:** Registro por sesión con qué se ha probado, qué cambios se han hecho, qué ha funcionado y qué no. Esta trazabilidad es la base de la redacción posterior.
- **Filtro de relevancia para la memoria:** No reflejar cada cambio menor. Solo decisiones, ajustes y resultados realmente relevantes para explicar la solución. Configuraciones extendidas → Anexos (refuerza el punto 2).
- **Bibliografía en paralelo:** Guardar las fuentes consultadas desde el inicio de la fase técnica. Servirán tanto para el marco teórico como para la bibliografía final.

## 6. Comunicación con el Tutor
- **Cadencia esperada:** Respuestas habituales en 1-3 semanas según carga del tutor. No bloquear el trabajo esperando feedback; avanzar en vías paralelas mientras llega la respuesta.
- **Modalidad de contacto:** Correo para entregar artefactos consolidados. Teams disponible bajo demanda cuando se acumulen dudas en cadena que requieran desbloqueo (acordado en correo 13/02/2026).
- **Naturaleza del feedback:** El tutor valida el marco académico y el enfoque, no audita detalles técnicos finos (Wazuh, payloads, microsegmentación). La validación técnica de profundidad recae en bibliografía y buenas prácticas asumidas por Pau.

## 7. Estrategia de Comunicación — Sprint Final (correos 24/05 y 06/06/2026)

Derivada del correo §16 del timeline (`00_TIMELINE_CORREOS.md`). La luz verde del tutor para la convocatoria de julio estaba condicionada a un borrador "razonablemente decente" — **cumplida el 06/06/2026** (§17–§18).

- **Condición de desbloqueo:** ✅ Cumplida. Índice anotado enviado el 06/06. Respuesta del tutor: en general lo ve bien; puede avanzar.
- **Qué significa "razonablemente decente":** según el correo, equivale a un documento con el índice de capítulos y 2-3 frases por sección que expliquen qué va en cada parte. No hace falta el texto completo; sí hace falta que sea coherente con otros TFGs del ámbito.
- **Feedback pendiente de incorporar:** reformular objetivos (§1) como pregunta de investigación, no como "comparar arquitecturas".
- **Próximo contacto tutor:** cita en despacho cuando haya contenido redactado (alineado con envío 14/06).
- **Calendario de envíos al tutor:**

  | Fecha  | Qué se envía                                                        | Qué se pide                                          | Estado |
  |--------|---------------------------------------------------------------------|------------------------------------------------------|--------|
  | ~~31/05~~ **06/06** | Índice anotado del TFG (`Borrador_Indice_Anotado_HUMANO.md`) | Validación "razonablemente decente" / luz verde | ✅ Enviado; OK general |
  | 14/06  | Memoria ~60-70% (caps 3, 4, 5, 6 en borrador)                      | Revisión del núcleo cuantitativo (pruebas, KPIs)    | Pendiente |
  | ~~19/06~~ **19/06** | PDF compilado completo en Overleaf                                  | Correcciones de última pasada (plazo: 48h)           | ✅ Enviado (§20); caps. 4–5 y figuras/tablas pendientes |

- **Regla de no-bloqueo:** si el tutor no responde en 48h tras cualquier envío, se avanza igualmente. Su feedback se incorpora como ajuste puntual, nunca como rediseño. Ver §6 (cadencia 1-3 semanas).
- **Señal de alarma:** si el tutor responde con "esto no llega" o feedback crítico estructural antes del 15/06, ese es el último día para activar la convocatoria de septiembre como Plan C sin quemar tiempo inútilmente.
- **Formato de los correos:** breve, con bullets claros de (1) qué se entrega, (2) qué se pide, (3) qué se hará por defecto si no responde. Sin lenguaje dubitativo ni disculpas por el ritmo de trabajo.