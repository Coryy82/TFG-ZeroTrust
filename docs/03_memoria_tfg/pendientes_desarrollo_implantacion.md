# Pendientes — Capítulo 5 (Desarrollo e Implantación)

> Recopilación de marcas `[APUNTE]` en `05_desarrollo_implantacion.md` (revisión 12/06/2026).
> Convertidos en tareas accionables agrupadas por sección.

---

## §5.2.2 — Vectores de vulnerabilidad

- [ ] **Consultar al tutor (reunión):** ¿El detalle de la cadena pre-RCE (robots → backup → login → SSTI) es proporcionado para un TFG centrado en post-explotación, o aporta contexto necesario al baseline?
  - *Criterio interno:* Si se acorta, conservar una frase que fije el punto de entrada (RCE en webapp) y remitir CWEs a anexo o §3.2.
  - *Si se mantiene:* No superar 1 párrafo; evitar duplicar §4.2 ni §6.1.2.

---

## §5.2.3 — Decisiones de implementación

- [ ] **Definición formal de métricas:** Asegurar que existe un apartado que explique *cómo se mide* cada indicador (tiempo de detección, profundidad, bloqueo, superficie, volumen exfiltrado, integridad del tráfico).
  - *Ubicación prevista:* Cap. 3 §3.4 (definición) + Cap. 6 §6.1.3 (operacionalización en sesión).
  - *Acción Cap. 5:* En §5.2.3, una sola frase de remisión; no redefinir métricas aquí.

---

## §5.3.3 — Implementación de mTLS

- [ ] **Figuras y evidencia visual:** Añadir al menos:
  - Fragmento Nginx mTLS (`[FIG:]` ya previsto en esqueleto).
  - Captura de verificación: `curl` con/sin certificado cliente.
  - Opcional: árbol de `infra/zero_trust/certs/` o esquema CA → server/client.
- [ ] **Más comandos/capturas en todo el capítulo:** Incorporar 2–3 bloques de verificación por fase ZT (segmentación, secretos, mTLS, Wazuh) — no solo prosa.
- [ ] **Glosario / primera mención:** Explicar «montar en runtime» (volúmenes Docker vs bake en imagen) en nota al pie, glosario o §4.4/§5.1 en una frase.

---

## Transversal (índice anotado / borrador)

- [ ] **§5.3 «Puesta en marcha del laboratorio» (falta en capítulo actual):** Redactar apartado con:
  - Requisitos host (Docker Desktop, WSL2, Compose v2).
  - Orden de arranque Escenario A vs B (ZT → Wazuh).
  - Comprobaciones previas al ataque (`docker ps`, healthchecks, `process-webapp` OK).
  - *Fuente:* `06_pruebas.md` §6.1.1 (no duplicar resultados; solo procedimiento de despliegue).

---

## Transversal (tecnologías y términos)

- [ ] **Tecnologías utilizadas:** El autor señala necesidad de explicar Nginx, Flask, Jinja2, CWE.
  - *Recomendación:* No duplicar §4.4; añadir glosario breve o notas al pie en primera mención en Cap. 5.
  - CWE: una frase en §5.2.2 («Common Weakness Enumeration — catálogo de debilidades software») + cita OWASP.

---

## Limpieza editorial (derivado de revisión)

- [ ] Eliminar del cuerpo todas las marcas `[REVISAR]`, `[APUNTE]`, `[TODO]` residuales y comentarios meta del autor antes de envío al tutor.
- [ ] Corregir esqueletos cruzados: `[TODO]` de §5.4 aparece bajo §5.2.4; `[TODO]` de §5.2.4 aparece bajo §5.2.2.
- [ ] Restaurar párrafo §5.2.3 sobre plantilla KPI v2 / `T0_efectivo` (usuario lo recortó; contenido necesario pero debe ir condensado y remitir a Cap. 3/6).
- [ ] Restaurar caso «artefactos 0 bytes» en §5.4 si se eliminó por error (está en diario 20260523a).
