# Capítulo 1 — Introducción

> **Estado:** ESQUELETO — redactar en fase intensiva semana 4 (15/06).
> Se redacta PENÚLTIMO (antes del resumen). Hasta no tener el resto no se sabe qué se presenta.
> Gancho de motivación: URL/noticia Endesa (`docs/01_investigacion/TFG-EstadoDelArte.md`) + coste creciente de ciberdelincuencia.

---

## 1.1 Motivación

[TODO] Párrafo de apertura con el gancho concreto: incidente de seguridad real (caso Endesa u otro con datos de coste) + estadística de crecimiento del coste anual de ciberdelincuencia a nivel global. Enmarcar el problema: redes planas de contenedores heredadas = superficie de ataque interior no controlada.

[CITAR: estadística coste ciberdelincuencia — buscar fuente IEEE/ENISA/IBM Cost of a Data Breach 2025]

## 1.2 Objetivos

El objetivo principal de este TFG es demostrar cuantitativamente la diferencia de eficacia entre el modelo de seguridad perimetral tradicional y una arquitectura Zero Trust mediante micro-segmentación, aplicada a infraestructuras contenerizadas.

Objetivos específicos:
- Diseñar y desplegar dos infraestructuras funcionalmente idénticas (Escenario A: perimetral; Escenario B: Zero Trust) sobre Docker.
- Definir y medir un conjunto de métricas de contención y detección (G1–G3, E1–E3) comparables entre ambos escenarios.
- Ejecutar pruebas de post-explotación reproducibles (movimiento lateral, exfiltración, interceptación de tráfico) en ambos escenarios.
- Cuantificar el impacto de la microsegmentación y la observabilidad activa sobre la capacidad de contención.

## 1.3 Estructura de la memoria

[TODO] Breve párrafo de un capítulo por línea, indicando qué contiene cada uno. Se escribe cuando el resto de capítulos esté en borrador.
