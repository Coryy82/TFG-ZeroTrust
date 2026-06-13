# Capítulo 1 — Introducción

> **Estado:** ESQUELETO — redactar en fase intensiva semana 4 (15/06).
> Se redacta PENÚLTIMO (antes del resumen). Hasta no tener el resto no se sabe qué se presenta.
> Gancho de motivación: URL/noticia Endesa (`docs/01_investigacion/TFG-EstadoDelArte.md`) + coste creciente de ciberdelincuencia.

---

## 1.1 Motivación

[TODO] Párrafo de apertura con el gancho concreto: incidente de seguridad real (caso Endesa u otro con datos de coste) + estadística de crecimiento del coste anual de ciberdelincuencia a nivel global. Enmarcar el problema: redes planas de contenedores heredadas = superficie de ataque interior no controlada.

[CITAR: estadística coste ciberdelincuencia — buscar fuente IEEE/ENISA/IBM Cost of a Data Breach 2025]

## 1.2 Objetivos

> **Estado:** REFORMULAR como pregunta de investigación (feedback tutor 06/06, "vender la cabra" — ver ADR 2026-06-06 en `admin/DECISIONS_LOG.md`).
> La comparativa A/B es el **método**, no el mensaje central. La pregunta debe abrir aquí y cerrarse en §7.1; debe ser coherente con §2.9 (Propuesta).

### Pregunta de investigación

[TODO] Cerrar la redacción definitiva. Formulación de trabajo ya validada con el tutor (ADR 2026-06-06):

> ¿En qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas?

### Hipótesis

[TODO] Enunciar la hipótesis que el trabajo contrasta: la microsegmentación, la identidad de servicio (mTLS) y la observabilidad activa de un modelo Zero Trust reducen materialmente la profundidad del compromiso, el volumen exfiltrado y el tiempo de detección tras una ejecución remota, frente a un modelo perimetral funcionalmente equivalente.

### Objetivo principal

[TODO] Redactar el objetivo principal como la **acción de responder** a la pregunta de investigación mediante un experimento comparativo controlado y reproducible (no como "comparar dos arquitecturas").

### Objetivos específicos

- Diseñar y desplegar dos infraestructuras funcionalmente idénticas (Escenario A: perimetral; Escenario B: Zero Trust) sobre Docker.
- Definir y medir un conjunto de métricas de contención y detección (G1–G3, E1–E3) comparables entre ambos escenarios.
- Ejecutar pruebas de post-explotación reproducibles (movimiento lateral, exfiltración, interceptación de tráfico) en ambos escenarios.
- Cuantificar el impacto de la microsegmentación y la observabilidad activa sobre la capacidad de contención.

> **Nota de coherencia:** cada objetivo específico debe quedar respondido en §7.1 Conclusiones (correspondencia 1:1).

## 1.3 Impacto esperado

> **Estado:** ESQUELETO — apartado **Recomendable** (referencia, línea 120). El índice anotado validado lo había situado en §7.4; se adelanta aquí a la Introducción según la pauta ETSINF, y los ODS se desarrollan en §7.4 (evitar duplicación: aquí solo mención breve).

[TODO] Explicar las ventajas/mejoras que aporta el resultado del trabajo y para quién:
- Para equipos de plataforma/DevSecOps: criterio cuantitativo para justificar la inversión en microsegmentación e identidad de servicio.
- Para organizaciones con despliegues contenerizados heredados (redes planas): evidencia del riesgo real post-explotación y de la contención alcanzable.
- Relación con problemas contemporáneos y ODS (desarrollo en §7.4): ODS 9 (infraestructura resiliente) y ODS 16.

## 1.4 Metodología

> **Estado:** ESQUELETO — apartado **Recomendable** (referencia, línea 126). Figuraba como §1.3 en el índice anotado validado por el tutor; se restaura aquí. El detalle operativo del protocolo está en §6.1 (no duplicar: aquí solo el enfoque).

[TODO] Describir el enfoque experimental que guía el trabajo: diseño de dos prototipos funcionalmente idénticos, despliegue reproducible en laboratorio Docker (IaC), ejecución de la misma cadena de ataque y de los mismos hitos post-explotación en ambos escenarios, captura estructurada de evidencias y análisis cuantitativo mediante las métricas G1–G3 / E1–E3. Justificar cómo se garantiza la comparabilidad (mismo atacante simulado, misma ventana de medición desde T0_efectivo). Remitir el protocolo detallado a §6.1.

## 1.5 Estructura de la memoria

[TODO] Breve párrafo de un capítulo por línea, indicando qué contiene cada uno. Se escribe cuando el resto de capítulos esté en borrador. Incluir una referencia a los contenidos de los Anexos.

[TODO] Avisar al lector de la existencia de un **Glosario de términos y acrónimos** al final de la memoria (ver `101_glosario.md`), para un tribunal no especialista en el área (pauta ETSINF, referencia líneas 137 y 357).
