# Capítulo 2 — Estado del Arte

> **Estado:** REDACTAR PRIMERO — semana 1 fase intensiva (25-30/05). Independiente del laboratorio.
> Insumos disponibles: `docs/01_investigacion/` (Docker101, SSTI Jinja2, Prototipo Red Perimetral).
> Objetivo de extensión: 10-12 páginas.
> Filtro del tutor: análisis de seguridad, no manual de arquitectura. Cada sección termina con implicación de seguridad.
> Gestión de citas: usar marcadores `[CITAR: fuente §sección]` inline mientras se redacta.

---

## 2.1 Evolución hacia infraestructuras contenerizadas

[TODO] De servidores monolíticos a microservicios. Docker como estándar de facto. Kubernetes para orquestación. La "comodidad" de las redes planas por defecto (`bridge` en Docker) y sus implicaciones de seguridad: visibilidad total entre contenedores de la misma red, sin control de flujo lateral.

[CITAR: Docker networking documentation / paper IEEE sobre contenedores y seguridad]

## 2.2 El modelo de seguridad perimetral y sus limitaciones

[TODO] Definición del modelo perimetral (firewall en el borde, confianza implícita en la red interna). Por qué funciona bien contra amenazas externas pero falla ante amenazas internas (post-explotación, movimiento lateral). Estadística de brechas que se originan desde dentro del perímetro.

[CITAR: NIST SP 800-207 §1 — introducción al problema de la confianza implícita]
[CITAR: IBM Security Cost of a Data Breach 2024/2025 — porcentaje de brechas con origen interno o post-compromiso]

## 2.3 El modelo Zero Trust

[TODO] Origen del término (Forrester Research, John Kindervag, 2010). Principios fundamentales: "nunca confíes, siempre verifica", acceso de mínimo privilegio, microsegmentación, verificación explícita de identidad. Evolución hasta BeyondCorp (Google, 2014) como implementación real a escala.

[CITAR: NIST SP 800-207 §2 — principios Zero Trust Architecture]
[CITAR: BeyondCorp: A New Approach to Enterprise Security (Google, 2014)]

## 2.4 Microsegmentación en entornos contenerizados

[TODO] Cómo se implementa Zero Trust a nivel de red en Docker: redes separadas por función (web, backend, datos), políticas de conectividad explícitas, identidad de servicio (mTLS entre contenedores). Comparativa con enfoques alternativos: Network Policies de Kubernetes, Service Mesh (Istio/Envoy).

[CITAR: NIST SP 800-207 §3 — implementaciones de ZTA]
[CITAR: paper IEEE / USENIX sobre microsegmentación en contenedores]

## 2.5 Sistemas de detección y observabilidad (SIEM/IDS)

[TODO] Papel del SIEM en un modelo Zero Trust: no solo detectar, sino correlacionar eventos de múltiples fuentes para identificar comportamiento anómalo. Wazuh como solución open-source para entornos Docker. Comparativa Wazuh vs Suricata: Wazuh orientado a host-based detection (logs, integridad de ficheros, reglas de correlación); Suricata orientado a network-based detection (captura de paquetes, firmas). Justificación de la elección para este TFG.

[CITAR: Wazuh documentation — agent deployment en Docker]
[CITAR: Suricata documentation — network IDS/IPS]

## 2.6 Amenazas en entornos post-explotación de contenedores

[TODO] Descripción técnica de las amenazas en alcance del TFG:
- **Movimiento lateral:** un atacante con RCE en un contenedor web accede a servicios internos no expuestos externamente.
- **Exfiltración de datos:** extracción de credenciales y datos de la base de datos sin cruzar el perímetro externo.
- **Interceptación de tráfico interno:** ausencia de cifrado en tráfico inter-contenedor (HTTP plano observable con tcpdump).

[CITAR: OWASP Top 10 — A05:2021 Security Misconfiguration (redes planas)]
[CITAR: MITRE ATT&CK — Lateral Movement (TA0008), Exfiltration (TA0010)]

## 2.7 Trabajos relacionados

[TODO] 2-3 párrafos sobre TFGs/papers similares: comparativas de seguridad en entornos Docker, estudios de microsegmentación. Diferenciar este trabajo: foco en evidencia cuantitativa reproducible (KPIs medibles), cadena de ataque HTB-style, comparativa A/B controlada.

[CITAR: buscar 2-3 papers IEEE de comparativas de seguridad en contenedores]
