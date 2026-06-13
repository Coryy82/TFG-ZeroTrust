# Capítulo 7 — Conclusiones

> **Estado:** ESQUELETO — redactar en semana 4 (16/06), DESPUÉS de tener los resultados cuantitativos del Cap. 6.
> Incluir: discusión de resultados, limitaciones, trabajo futuro.
> Objetivo de extensión: 4-6 páginas.

---

## 7.1 Conclusiones del estudio

[TODO POST-PRUEBAS] Párrafo de apertura: **responder explícitamente a la pregunta de investigación formulada en §1.2** (en qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas) y confirmar o matizar la hipótesis con los datos reales de §6.4. Mantener correspondencia 1:1 con los objetivos específicos enumerados en §1.2 (cada objetivo → resultado alcanzado).

[TODO] Para cada métrica donde ZT mejoró: cuantificar y atribuir el mecanismo. Para cada métrica donde no mejoró: razonar por qué y qué implicaría en un entorno real.

[TODO] Conclusión general: ¿confirma el estudio que la microsegmentación Zero Trust reduce materialmente el impacto de una intrusión post-explotación en infraestructuras contenerizadas?

## 7.2 Limitaciones del trabajo

[TODO] Honestas y concretas:
- Entorno de laboratorio local: los resultados son reproducibles pero no directamente extrapolables a despliegues en producción con múltiples nodos o en cloud.
- mTLS implementado en un único canal (webapp ↔ backend): un escenario de producción requeriría mTLS en toda la malla de servicios.
- Wazuh sin dashboard ni respuesta automatizada: las alertas son pasivas, no bloquean el ataque en tiempo real (SOAR queda fuera del alcance).
- El atacante tiene RCE como punto de partida asumido: el TFG no estudia cómo prevenir el compromiso inicial, solo cómo contener el daño post-explotación.

## 7.3 Trabajo futuro

[TODO] Lista concreta y realista de las líneas de mejora más relevantes:

- **Escalado a Kubernetes:** implementar las mismas políticas de red con NetworkPolicies de Kubernetes y un Service Mesh (Istio/Envoy). Los resultados serían directamente aplicables a entornos cloud.
- **mTLS completo en toda la malla de servicios:** extender mTLS al canal `backend ↔ db`. Añadir rotación automática de certificados (cert-manager).
- **Suricata como IDS de red complementario:** añadir una capa de detección network-based (firmas de tráfico) en paralelo a la detección host-based de Wazuh. Permite detectar ataques que evaden la detección host.
- **Respuesta automatizada (SOAR):** integrar Wazuh con un mecanismo de respuesta activa que bloquee la conexión o el contenedor cuando se detecta uno de los 4 hitos post-RCE.
- **Ataques adicionales:** spoofing DNS interno, escalada de privilegios en el host, ataques de denegación de servicio interna.
- **Evaluación en entorno cloud real:** despliegue en AWS/GCP/Azure con VPC, Security Groups y herramientas cloud-native de ZT.

## 7.4 Relación del trabajo desarrollado con los estudios cursados e impacto (ODS)

> **Estado:** ESQUELETO — apartado **Obligatorio** según `00_PAUTAS_IMPORTANTES_MEMORIA/EstucturayContenidodeunTFG.md` (línea 291). Figura como §7.4 en el índice anotado validado por el tutor. Redactar en la semana 4 (16/06), junto con §7.1–§7.3.
> No es una repetición de resultados: es un ejercicio de introspección sobre qué conocimientos del Grado se han puesto en juego.

### 7.4.1 Relación con los estudios cursados

[TODO] Justificar que el contenido del TFG es conforme a los estudios cursados. Vincular con asignaturas y áreas concretas de la titulación:
- Redes y Seguridad (modelo perimetral vs Zero Trust, microsegmentación, mTLS).
- Sistemas Distribuidos / Infraestructuras (contenedores Docker, arquitectura de servicios).
- Administración de sistemas / Sistemas Operativos (WSL2, namespaces, procesos, sockets).
- Ingeniería del Software (requisitos, diseño, IaC, reproducibilidad).

[TODO] Indicar qué conocimientos o tecnologías NO se vieron en la carrera (o se vieron de forma insuficiente) y que hubo que aprender para este TFG (Wazuh/SIEM, OpenSSL/mTLS, SSTI Jinja2, MITRE ATT&CK), y el grado de dominio alcanzado.

[TODO] Competencias transversales puestas en práctica (p. ej. análisis crítico, comunicación escrita, planificación y gestión del tiempo del sprint) y en qué grado.

### 7.4.2 Impacto y relación con los ODS

[TODO] Explicar las ventajas/mejoras que aporta el trabajo (contención de intrusiones, resiliencia de redes corporativas contenerizadas) e identificar usuarios beneficiados. Relacionar con los ODS:
- ODS 9 (Industria, innovación e infraestructura): infraestructuras digitales más resilientes.
- ODS 16 (Paz, justicia e instituciones sólidas): reducción del impacto de la ciberdelincuencia.

[CITAR: ODS — https://www.un.org/sustainabledevelopment/es/objetivos-de-desarrollo-sostenible/]
