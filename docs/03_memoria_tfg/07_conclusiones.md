# Capítulo 7 — Conclusiones

> **Estado:** ESQUELETO — redactar en semana 4 (16/06), DESPUÉS de tener los resultados cuantitativos del Cap. 6.
> Incluir: discusión de resultados, limitaciones, trabajo futuro.
> Objetivo de extensión: 4-6 páginas.

---

## 7.1 Conclusiones del estudio

[TODO POST-PRUEBAS] Párrafo de apertura: retomar la hipótesis del TFG (ZT mejora la contención post-explotación) y responderla con los datos reales de §6.4.

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
