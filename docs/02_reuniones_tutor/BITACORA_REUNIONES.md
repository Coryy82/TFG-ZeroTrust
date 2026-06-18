# Bitácora de Reuniones y Comunicaciones con el Tutor (Héctor)

## 2025-11 / 2026-01 - Fase de Ideación
- **Evento:** Intercambio de correos inicial.
- **Acuerdo:** TFG orientado a pentesting y redes. Enfoque: Entorno de laboratorio, prueba de técnicas de intrusión y validación de contramedidas.

## 2026-02 - Corrección de Enfoque
- **Evento:** Revisión del primer borrador de índice.
- **Feedback Héctor:** El enfoque parecía demasiado centrado en despliegue. Exigió pivotar hacia "Pentesting + Defensas", añadiendo métricas comparables y restando importancia a la configuración de Docker.

## 2026-03 - Definición del Modelo de Amenazas
- **Evento:** Corrección conceptual profunda.
- **Feedback Héctor:** Aclaración de que el "Modelo de Amenazas" no es una lista de ataques (eso es post-explotación), sino el marco de alcance (Atacante, Activos, Superficie, In/Out of scope).
- **Acción:** Pau reformuló el marco de amenazas correctamente.

## 2026-04-09 - Aprobación del Alcance y Títulos
- **Evento:** Email de validación.
- **Acuerdo:** Héctor da el OK oficial al modelo de amenazas reformulado, al alcance y a las opciones de título. Resumen validado preliminarmente.

## 2026-04-19 al 2026-04-27 - Aprobación Oficial y Metodología
- **Evento:** Intercambio de correos y confirmación automática del sistema EBRON.
- **Acciones y Acuerdos:**
  1. **Burocracia:** TFG subido, validado por el tutor y APROBADO oficialmente por Secretaría. Título oficial fijado: *"Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas"*.
  2. **Metodología acordada:** Trabajar con plan previo (no improvisar). Mantener un diario de laboratorio interno y recopilar bibliografía en paralelo.
- **ESTADO:** 🟢 Burocracia inicial completada. Proyecto 100% oficializado.

## 2026-05-24 — Solicitud de entrega en julio y activación del Sprint Final

- **Evento:** Correo de Pau al tutor solicitando valoración sobre entrega en convocatoria de julio. Respuesta del tutor abriendo la puerta condicionada a un borrador previo.
- **Correo Pau → Héctor:** Pau informa de avance (material para Estado del Arte, inicio de montaje del Escenario B) y pregunta si es viable entregar en julio dado que su contrato a tiempo completo está por terminar.
- **Respuesta Héctor:** "Lo podemos intentar sí." Condición explícita: tener un borrador "razonablemente decente" lo antes posible antes de comprometerse formalmente. Instrucción: consultar otros TFGs, hacer un plan y enviarlo cuando sea defendible.
- **Decisión tomada:** Activación del Sprint Final con deadline 21/06/2026. Plan documentado en `admin/ROADMAP_v2_sprint_final.md`. ADR registrado en `admin/DECISIONS_LOG.md`.
- **Próximo hito de comunicación:** envío al tutor el **31/05/2026** con índice de 8 capítulos + Estado del Arte v0 + propuesta de alcance del Escenario B.
- **ESTADO:** 🟡 Sprint Final activo. Pendiente validación del tutor el 31/05.

## 2026-06-06 — Envío del índice anotado y validación del borrador

- **Evento:** Correo de Pau al tutor con el índice anotado del TFG (recuperación del hito vencido del 31/05). Respuesta del tutor con luz verde condicionada y feedback de redacción.
- **Correo Pau → Héctor (06/06/2026 14:32):** Disculpa por la demora. Revisión de otros trabajos como indicó el tutor. Laboratorio con ambos escenarios desplegados. Adjunto `Borrador_Indice_Anotado` (índice anotado). Redacción en curso: Estado del Arte y Diseño de la solución. Pregunta de validación: *¿Es razonablemente decente este planteamiento para continuar hacia la memoria?*
- **Respuesta Héctor (06/06/2026):** *"Sí, pero hay matices siempre."* En general ve bien el planteamiento. Puede avanzar; cuando haya contenido redactado, quedar en su despacho para repaso y feedback presencial.
- **Feedback crítico de redacción (objetivos):** El objetivo principal no debe formulase solo como *"comparar dos arquitecturas"* — es más amplio: **responder a una pregunta clave e importante**. Hay que *"vender la cabra"*: pensar qué se quiere transmitir, ligarlo bien al problema y a la solución. Cita textual el borrador: *"Objetivo principal: comparar dos arquitecturas funcionalmente idénticas, Perimetral vs Zero Trust, sometidas a la misma auditoría post-explotación."*
- **Acciones derivadas:**
  1. Reformular §1.2 Objetivos (y posiblemente Introducción/Conclusiones) como **pregunta de investigación** + hipótesis, no como lista de tareas comparativas.
  2. Seguir redacción (EdA, Diseño) y pruebas A/B sin bloquearse esperando más feedback.
  3. **Próximo contacto:** solicitar cita en despacho cuando haya borrador sustancial (caps. 3–6 o memoria ~60–70%, alineado con hito 14/06).
- **Artefacto enviado:** `docs/03_memoria_tfg/Borradores y pretrabajos/Borrador_Indice_Anotado_HUMANO.md`
- **ESTADO:** 🟢 Hito `email_tutor_31_05` recuperado y validado en línea general. Sprint Final desbloqueado para redacción y pruebas formales.

## 2026-06-16 — Envío borrador caps. 2–6 y solicitud de cita presencial

- **Evento:** Correo de Pau al tutor con borrador sustancial de la memoria (caps. 2–6), cumpliendo el acuerdo del 06/06 de contactar cuando hubiera contenido redactado.
- **Correo Pau → Héctor (16/06/2026):** Agradece las recomendaciones del correo anterior. Revisó otros TFGs y reorientó la redacción hacia la pregunta de investigación (*por qué Zero Trust es mejor que lo tradicional*). Adjunto: caps. 2–6 (sin Introducción ni Conclusiones), transferidos del borrador a la plantilla LaTeX ETSINF — pendiente adaptación completa a LaTeX, figuras y tablas. Duda editorial: contenido redactado con anterioridad que no encaja del todo en su capítulo (ej. §5.4, ¿debería ir al capítulo de pruebas?). Próximos pasos: acabar Intro y Conclusiones; insertar figuras y tablas. Ofrece disponibilidad para cita en despacho.
- **Respuesta Héctor:** Sin respuesta a **18/06/2026**.
- **Artefacto enviado:** Plantilla `borradorplantillatfgoverleaf.tex` con caps. 2–6 (fuentes MD en `docs/03_memoria_tfg/`).
- **Acciones derivadas:**
  1. Esperar feedback del tutor sobre estructura y núcleo cuantitativo.
  2. Resolver duda §5.4 con respuesta del tutor o decisión editorial.
  3. Completar Intro y Conclusiones, figuras y tablas antes del PDF final (hito 19/06).
- **ESTADO:** 🟡 Borrador sustancial enviado. Pendiente respuesta del tutor.