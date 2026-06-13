# Resumen / Abstract

> **Estado:** VÁLIDO — aprobado por el tutor Héctor el 09/04/2026 (ver `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md` §11–§12).
> Copiar textualmente a Overleaf. Solo retoques cosméticos de redacción en la última pasada (19/06).
> No reescribir desde cero.
> **Pendiente (Obligatorio):** falta el Abstract en inglés — la pauta ETSINF exige el resumen al menos en inglés y español (`00_PAUTAS_IMPORTANTES_MEMORIA/EstucturayContenidodeunTFG.md` línea 47). Esqueleto añadido abajo.
> [TODO] (pasada final, opcional) Valorar cerrar el resumen con una frase de resultados headline para reforzar el valor: profundidad −67 %, bloqueo del 100 % de los hitos post-RCE, detección a 22 s frente a ∞, exfiltración 766 B → 0 B. No alterar el texto aprobado salvo retoque cosmético.

---

Las nuevas arquitecturas basadas en microservicios y contenedores han servido para optimizar el despliegue de infraestructuras de red, pero frecuentemente, estos despliegues heredan configuraciones de red planas que amplían la superficie de ataque interno. En este contexto, las defensas perimetrales tradicionales resultan ineficaces cuando un atacante logra comprometer un servicio expuesto, facilitando la escalada de privilegios y el compromiso total del sistema.

Este Trabajo de Fin de Grado presenta un análisis comparativo entre el modelo de seguridad perimetral tradicional y un modelo de arquitectura basada en principios Zero Trust mediante micro-segmentación. Para ello, se diseñan y despliegan dos infraestructuras funcionalmente idénticas. Ambas arquitecturas son sometidas a auditorías de seguridad focalizadas en escenarios de post-explotación y mediante la evaluación de métricas de contención y detección, el estudio cuantifica la eficacia de cada modelo de red. El trabajo busca demostrar que la implementación de una arquitectura Zero Trust bloquea eficazmente el movimiento lateral, mitiga el impacto de las intrusiones y resulta fundamental para garantizar la resiliencia en redes corporativas modernas.

---

## Abstract

> **Estado:** ESQUELETO `[TODO]` — traducción al inglés del resumen aprobado (mismo contenido, sin reescribir el original español). Redactar/revisar en la pasada final de Overleaf (19/06).

[TODO] Traducir al inglés los dos párrafos del resumen aprobado: (1) contexto y problema (redes planas en contenedores, ineficacia del perímetro tras compromiso) y (2) propuesta del TFG (comparativa perimetral vs Zero Trust con microsegmentación, dos infraestructuras funcionalmente idénticas, auditoría post-explotación, métricas de contención y detección, conclusión sobre la resiliencia). Mantener correspondencia con el texto español validado.

---

## Palabras clave

Seguridad en redes, Zero Trust, microsegmentación, contenedores Docker, post-explotación, movimiento lateral, modelo perimetral, SIEM, métricas de seguridad.

## Keywords

Network security, Zero Trust, microsegmentation, Docker containers, post-exploitation, lateral movement, perimeter model, SIEM, security metrics.
