# Esqueleto de la presentación — Defensa del TFG (20 min)

> Blueprint para maquetar las diapositivas de la defensa oral. **No es el guion literal a leer**: las diapositivas apoyan al orador; el mensaje lo lleva la persona, no la pantalla (Recomendaciones-Defensa-TFG §Comunicador).

## Metadatos

- **Título:** Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas
- **Autor:** Pau Pérez Marco
- **Tutor:** Héctor Marco Gisbert
- **Titulación:** Grado en Ingeniería Informática — ETSINF, Universitat Politècnica de València (4º)
- **Formato de defensa:** 20 min de exposición (turno de preguntas del tribunal aparte)
- **Fuentes:** memoria `DocumentoFinalOverleaf.tex`; figuras en `Overleaf/img/*.jpg`; capturas de sesión en `tests/`

## Reparto global de tiempo (objetivo ≤ 20:00; suma ≈ 19:15 + colchón)

| # | Diapositiva | Tiempo | Bloque narrativo |
|---|-------------|--------|------------------|
| 1 | Portada | 0:30 | Apertura |
| 2 | Índice / hoja de ruta | 0:30 | Apertura |
| 3 | Motivación | 1:15 | Problema |
| 4 | Modelo perimetral: el punto ciego | 1:00 | Problema |
| 5 | Zero Trust: never trust, always verify | 1:00 | Fundamentos |
| 6 | El hueco + pregunta + hipótesis | 1:30 | Tesis |
| 7 | Propuesta + diseño experimental | 1:15 | Solución |
| 8 | Metodología de medición (KPIs) | 1:30 | Solución |
| 9 | Escenario A — Perimetral | 1:00 | Solución |
| 10 | Escenario B — Zero Trust | 1:45 | Solución |
| 11 | DEMO (vídeo A vs B) | 2:30 | Prueba |
| 12 | Resultados: comparativa 6 KPIs | 2:00 | Clímax |
| 13 | Atribución + contribución | 1:15 | Clímax |
| 14 | Conclusiones | 1:00 | Cierre |
| 15 | Limitaciones + trabajo futuro | 0:45 | Cierre |
| 16 | Cierre: impacto + ODS + gracias | 0:30 | Cierre |
| — | **TOTAL** | **≈ 19:15** | |
| B | Slides de backup (Q&A) | — | Fuera de los 20 min |

## Principios de diseño aplicados (de Recomendaciones-Defensa-TFG.md)

- **Público = el tribunal**, multidisciplinar y generalista. No especialistas en Zero Trust. Nivelar sin insultar.
- **Una idea por diapositiva**, ≤ 75 palabras, prioridad al grafismo. El tribunal no puede leer y escuchar a la vez.
- **No leer las diapositivas.** Las notas del orador *amplían*, no repiten, lo que se ve.
- **Diapositivas conectadas**: problema → solución en secuencias contiguas.
- **Mini-índice** en una esquina resaltando la sección actual (navegación para el tribunal).
- **Control de tiempo**: cronómetro visible; ensayo cronometrado previo. Ni corto (parece pobre) ni largo (falta de síntesis).
- **Referenciar la fuente** de cada imagen en un pie discreto (figura de la memoria / captura de sesión).

## Regla transversal: conceptual, no implementación

El tutor exigió leer los capítulos de diseño/desarrollo como *análisis de seguridad*, no como *manual de Docker*. Se traslada a las diapositivas: el flujo principal usa **figuras conceptuales** (`cap04-*`: topologías, handshake mTLS, integración Wazuh) y **evidencias de resultado** (`cap06-*`: nmap, exfiltración, tcpdump). Las figuras de **implementación** (`cap05-*`: YAML de compose, `nginx.conf`, comandos OpenSSL) y la operacionalización fina de KPIs se reservan a las **slides de backup** para el turno de preguntas.

---

# Slide 1 — Portada

## Objetivo

- **Por qué existe:** abrir con formalidad y situar de inmediato de qué trata el trabajo.
- **Qué pregunta responde:** "¿quién defiende, qué y ante quién?".
- **Qué debe entenderse antes de pasar:** el tema (Perimetral vs Zero Trust en contenedores) y que es un trabajo comparativo y cuantitativo.

## Contenido visual

- Portada limpia, marca ETSINF-UPV. Un único motivo gráfico de fondo (silueta de red segmentada / candado sobre contenedores), tenue, sin recargar.
- Sin figura de la memoria aquí.

## Contenido de slide

- Título del TFG.
- Autor: Pau Pérez Marco.
- Tutor: Héctor Marco Gisbert.
- Grado en Ingeniería Informática — ETSINF, UPV.
- Fecha de la defensa.

## Notas del orador

Buenos días. Muchas gracias por su tiempo. Me llamo Pau Pérez y voy a defender mi Trabajo de Fin de Grado, dirigido por el profesor Héctor Marco. El trabajo compara dos formas de proteger una red de contenedores —el modelo perimetral clásico y el modelo Zero Trust— pero no se queda en la teoría: monta las dos, las ataca en igualdad de condiciones y *mide* cuánto daño consigue contener cada una. En los próximos veinte minutos verán ese experimento y, sobre todo, los números que salen de él.

## Tiempo estimado

0:30

## Transición

"Permítanme empezar por qué este problema importa hoy."

---

# Slide 2 — Índice / hoja de ruta

## Objetivo

- **Por qué existe:** dar al tribunal el mapa del recorrido (recomendación explícita de la guía).
- **Qué pregunta responde:** "¿cuánto hay y por dónde vamos?".
- **Qué debe entenderse antes de pasar:** que hay una progresión problema → solución → prueba → resultados.

## Contenido visual

- Cuatro bloques encadenados con flechas: **Problema → Solución → Experimento → Resultados**.
- Este esquema se replica en miniatura, en una esquina, en el resto de diapositivas, resaltando el bloque activo.

## Contenido de slide

- Problema: por qué el perímetro no basta.
- Solución: dos arquitecturas comparables.
- Experimento: mismo ataque, mismas métricas.
- Resultados y conclusiones.

## Notas del orador

La charla sigue cuatro pasos. Primero, el problema: por qué una red que confía en sí misma es frágil una vez que alguien entra. Segundo, la propuesta: dos infraestructuras idénticas que solo se diferencian en cómo está diseñada la red. Tercero, el experimento: el mismo ataque y las mismas métricas sobre ambas. Y cuarto, lo que de verdad importa, los resultados. Verán este pequeño mapa en la esquina durante toda la presentación para saber en todo momento dónde estamos.

## Tiempo estimado

0:30

## Transición

"Empecemos por el problema, y lo haré con un caso real y reciente."

---

# Slide 3 — Motivación: una intrusión ya no es excepcional

## Objetivo

- **Por qué existe:** enganchar emocionalmente y justificar la relevancia del tema con evidencia real.
- **Qué pregunta responde:** "¿por qué debería importarme esto?".
- **Qué debe entenderse antes de pasar:** las brechas son frecuentes y caras, y las arquitecturas modernas (microservicios/contenedores) amplían la superficie de ataque *interna*.

## Contenido visual

- Titular real de la brecha de Endesa (~300.000 clientes, enero 2026) como imagen ancla, con su fuente citada.
- A la derecha, dos iconos-dato: coste creciente de las brechas (IBM *Cost of a Data Breach*) y "~1/3 de brechas con origen interno" (Verizon DBIR 2025).
- Abajo, un pictograma de "red plana": muchos contenedores conectados entre sí sin muros internos.

## Contenido de slide

- Brecha real: ~300.000 clientes (2026).
- La ciberdelincuencia cuesta más cada año.
- Microservicios/contenedores → redes planas → superficie interna sin control.

## Notas del orador

A principios de este año se filtraron los datos de unos trescientos mil clientes de una de las mayores eléctricas del país. No es un caso aislado: el coste de las brechas crece año tras año y, según el informe de Verizon de 2025, casi un tercio tiene origen interno. Al mismo tiempo, la forma de construir software ha cambiado: hoy desplegamos aplicaciones como decenas de microservicios en contenedores. Es cómodo, pero tiene una contrapartida silenciosa: muchos de estos despliegues heredan redes "planas", donde los servicios confían entre sí solo por compartir la misma red. Es decir, hemos multiplicado las piezas internas sin poner muros entre ellas. Esa es exactamente la debilidad que este trabajo pone a prueba.

## Tiempo estimado

1:15

## Transición

"Para entender por qué esto es peligroso, hay que mirar el modelo de seguridad que seguimos usando por defecto."

---

# Slide 4 — El modelo perimetral y su punto ciego

## Objetivo

- **Por qué existe:** nivelar al tribunal sobre el modelo perimetral y exponer su fallo estructural (base del "antes").
- **Qué pregunta responde:** "¿qué protege el perímetro y qué deja de proteger?".
- **Qué debe entenderse antes de pasar:** el perímetro vigila la frontera, pero concede confianza implícita al interior; tras una intrusión, el atacante se mueve lateralmente sin obstáculos.

## Contenido visual

- Metáfora visual "castillo con muralla": muro exterior fuerte, interior abierto.
- Animación en dos pasos: (1) atacante bloqueado en la muralla; (2) atacante *dentro*, desplazándose libremente entre servicios internos (flechas de movimiento lateral hacia backend y base de datos).

## Contenido de slide

- Perímetro = frontera interior/exterior (firewall).
- Presunción: "lo de dentro es de confianza".
- Una vez dentro → movimiento lateral libre.

## Notas del orador

El modelo perimetral ha protegido las redes durante décadas y su idea es sencilla: levantar un muro fuerte entre lo de dentro y lo de fuera. Funcionó cuando la amenaza venía siempre del exterior. El problema es la presunción que lo sostiene: que todo lo que ya está dentro es de confianza. Y ahí está el punto ciego. Cuando un atacante compromete un único servicio expuesto —y siempre acaba habiendo uno—, esa confianza se vuelve en su contra: puede saltar de un servicio a otro, alcanzar el backend, llegar a la base de datos y extraer información sin volver a cruzar ninguna frontera vigilada. El muro no ha caído; simplemente ya no sirve, porque el atacante juega dentro.

## Tiempo estimado

1:00

## Transición

"Frente a esa confianza implícita, en 2010 se propuso justo lo contrario."

---

# Slide 5 — Zero Trust: never trust, always verify

## Objetivo

- **Por qué existe:** presentar el modelo alternativo y sus dos mecanismos clave, de forma conceptual.
- **Qué pregunta responde:** "¿en qué consiste Zero Trust y cómo cierra el punto ciego anterior?".
- **Qué debe entenderse antes de pasar:** Zero Trust no confía por defecto en nadie; se materializa con **microsegmentación** (compartimentar la red) e **identidad de servicio** (autenticación mutua, mTLS).

## Contenido visual

- El mismo "castillo" de la slide 4 pero **compartimentado** en salas con puertas que verifican identidad: contraste visual directo con la diapositiva anterior (diapositivas conectadas).
- Dos etiquetas conceptuales: "Microsegmentación" (muros internos) y "Identidad de servicio / mTLS" (control en cada puerta).
- Cita discreta: Kindervag (Forrester, 2010); NIST SP 800-207.

## Contenido de slide

- Principio: "nunca confíes, siempre verifica".
- Microsegmentación → muros *dentro* de la red.
- Identidad de servicio (mTLS) → estar en la red ≠ tener permiso.

## Notas del orador

Zero Trust parte de la premisa opuesta: no conceder confianza por defecto a nadie, ni siquiera a lo que ya está dentro. Lo formuló Kindervag en 2010 y lo estandarizó el NIST en 2020. Para esta charla basta con quedarse con dos ideas. La primera, microsegmentación: en lugar de una gran sala interior, dividimos la red en compartimentos, de modo que comprometer uno no da acceso a los demás. La segunda, identidad de servicio: cada servicio debe demostrar quién es antes de que otro le hable, mediante autenticación mutua con certificados, lo que llamamos mTLS. En una frase: con Zero Trust, estar dentro de la red deja de ser suficiente para que confíen en ti.

## Tiempo estimado

1:00

## Transición

"Ahora bien, si sabemos que el perímetro falla y que Zero Trust promete contenerlo, ¿por qué hace falta este trabajo?"

---

# Slide 6 — El hueco, la pregunta y la hipótesis

## Objetivo

- **Por qué existe:** justificar la aportación mostrando el vacío en la literatura y formular la tesis contrastable. Es el eje de toda la defensa.
- **Qué pregunta responde:** "¿qué falta por resolver y qué se propone demostrar exactamente este TFG?".
- **Qué debe entenderse antes de pasar:** existe evidencia de que el perímetro falla y de que Zero Trust es viable, pero **casi nadie lo ha medido de forma comparable**; este trabajo llena ese hueco con una pregunta y una hipótesis concretas.

## Contenido visual

- Diagrama de tres círculos que casi no se solapan: "Límites del perímetro" · "Viabilidad de Zero Trust" · "Amenazas post-explotación (MITRE ATT&CK)". En la intersección vacía, un signo de interrogación: *falta la medición comparativa*.
- Debajo, la **pregunta de investigación** en un recuadro destacado (estilo `tcolorbox` de la memoria).
- La **hipótesis** en una línea, marcada como "predicción a contrastar".

## Contenido de slide

- Documentado por separado: fallo del perímetro · viabilidad ZT · técnicas post-explotación.
- Falta: comparación **cuantitativa** perimetral vs Zero Trust tras el compromiso.
- **Pregunta:** ¿en qué medida Zero Trust reduce el impacto post-explotación frente al perímetro, y por qué?
- **Hipótesis:** microsegmentación + mTLS reducen profundidad, exfiltración y capacidad de daño.

## Notas del orador

Al revisar la literatura encontré tres cuerpos bien documentados por separado: las limitaciones del perímetro, la viabilidad de Zero Trust —con estándares del NIST y casos como BeyondCorp de Google— y los catálogos de técnicas post-explotación de MITRE. El problema es que rara vez se conectan. Los trabajos de fin de grado y máster más cercanos demuestran que *se puede* montar Zero Trust, pero casi ninguno mide qué ocurre *después* de un compromiso, ni lo compara con un perímetro equivalente. Ese es el hueco. De ahí mi pregunta de investigación —en qué medida Zero Trust reduce el impacto de un ataque una vez dentro, y por qué es superior— y mi hipótesis: que la microsegmentación y la identidad de servicio reducen de forma apreciable la profundidad del compromiso, el volumen de datos robados y, en general, el daño. Todo lo que viene ahora está diseñado para contrastar esa hipótesis con datos.

## Tiempo estimado

1:30

## Transición

"Para responder a esa pregunta con rigor, diseñé un experimento controlado."

---

# Slide 7 — La propuesta: dos infraestructuras idénticas, una sola variable

## Objetivo

- **Por qué existe:** presentar la idea central del método —comparar dos redes que solo difieren en su modelo— y la aplicación que sirve de banco de pruebas.
- **Qué pregunta responde:** "¿qué se compara exactamente y por qué la comparación es justa?".
- **Qué debe entenderse antes de pasar:** la única variable es el **modelo de red**; la aplicación (`webapp → backend → db`) es idéntica en ambos escenarios, lo que aísla la causa del efecto.

## Contenido visual

- Figura `img/cap04-arquitectura-microservicios.jpg` (o `cap04-flujo-microservicios.jpg`): cadena lineal **webapp → backend → db** con los tres roles (portal, API de empleados, PostgreSQL).
- Recuadro de "experimento controlado": misma app + mismo atacante + mismo punto de partida = **solo cambia la red** (A perimetral / B Zero Trust).

## Contenido de slide

- Misma aplicación en 3 capas: `webapp` (portal) → `backend` (API) → `db` (PostgreSQL).
- Escenario A = red perimetral · Escenario B = red Zero Trust.
- **Única variable: el modelo de red.**

## Notas del orador

La idea del experimento es la de un ensayo controlado: si quiero atribuir una diferencia a la arquitectura de red, todo lo demás tiene que ser igual. Por eso construí una sola aplicación, deliberadamente sencilla, con tres piezas en cadena: un portal web, que llama a una API interna de empleados, que a su vez es la única que habla con la base de datos PostgreSQL. Esa misma aplicación se despliega en dos escenarios. En el Escenario A la red es perimetral, la clásica; en el Escenario B, Zero Trust. La aplicación no cambia, el atacante no cambia y el punto de partida no cambia. Lo único que cambia es cómo está diseñada la red. Así, cualquier diferencia en los resultados solo puede venir de ahí.

## Tiempo estimado

1:15

## Transición

"Antes de ver cada red, quiero enseñarles la regla con la que voy a medir ambas, porque es la misma para las dos."

---

# Slide 8 — Cómo se mide: assumed breach, cuatro hitos y seis métricas

## Objetivo

- **Por qué existe:** dar al tribunal el "rasero" común *antes* de ver las arquitecturas, para que A y B se perciban como dos instancias medidas igual (mejora estructural de la revisión).
- **Qué pregunta responde:** "¿desde dónde empieza la medición y qué se mide?".
- **Qué debe entenderse antes de pasar:** se parte de un compromiso ya conseguido (RCE en `webapp`), se ejecutan siempre los mismos 4 hitos y se cuantifican con 6 métricas comparables.

## Contenido visual

- Línea de tiempo horizontal: a la izquierda, en gris, la **cadena de acceso inicial** (recon → credenciales expuestas → panel → SSTI → RCE) marcada como "fuera de medición, idéntica en A y B"; una bandera marca el **inicio de la ventana** (reverse shell en `webapp`).
- A la derecha, los **4 hitos post-RCE**: (1) exfiltrar credenciales, (2) escanear la red, (3) acceder al backend, (4) volcar la base de datos.
- Debajo, 6 iconos-KPI: **G1** detección · **G2** profundidad · **G3** bloqueo · **E1** superficie visible · **E2** volumen exfiltrado · **E3** integridad del tráfico.

## Contenido de slide

- Punto de partida común: atacante con RCE en `webapp` ("assumed breach").
- Fuera de alcance: cómo se entra (idéntico en A y B).
- 4 hitos: credenciales · escaneo · backend · base de datos.
- 6 métricas (G1–G3, E1–E3).

## Notas del orador

Aquí está la clave metodológica. No mido cómo se entra, sino qué pasa una vez dentro. Asumo que el atacante ya ha comprometido el portal y tiene ejecución de comandos —lo que se llama *assumed breach*—; esa fase previa de entrada existe, es realista y usa fallos del OWASP Top 10, pero es idéntica en los dos escenarios, así que queda fuera de la medición. La ventana empieza justo cuando el atacante tiene su shell en `webapp`. A partir de ahí ejecuto siempre los mismos cuatro movimientos: robar credenciales del entorno, escanear la red interna, intentar llegar al backend y volcar la base de datos. Y todo eso lo traduzco a seis métricas comparables: si hubo detección, hasta dónde llegó el atacante, cuántos comandos se bloquearon, cuánta superficie interna vio, cuántos datos se llevó y si pudo leer el tráfico. Estas seis métricas son la vara con la que compararé las dos redes.

## Tiempo estimado

1:30

## Transición

"Con esa vara en la mano, veamos la primera red: el escenario perimetral, que hace de referencia."

---

# Slide 9 — Escenario A: red perimetral (la referencia)

## Objetivo

- **Por qué existe:** fijar el baseline "inseguro por diseño" contra el que se medirá la mejora.
- **Qué pregunta responde:** "¿cómo es la red que hoy se despliega por comodidad y qué la hace vulnerable por dentro?".
- **Qué debe entenderse antes de pasar:** dos redes con el perímetro como única barrera; `webapp` es pivote hacia el interior, las credenciales viajan en su entorno y el tráfico interno va en claro. No hay detección.

## Contenido visual

- Figura `img/cap04-topologia-perimetral.jpg`: `net_dmz` y `net_interna`, `nginx` como único punto expuesto, `webapp` a caballo entre ambas redes (pivote), `backend` y `db` en la interna.
- Tres "banderas rojas" señaladas sobre el diagrama: (1) `webapp` con `DB_PASSWORD` en su entorno; (2) tráfico interno en HTTP plano; (3) sin SIEM/IDS/WAF.

## Contenido de slide

- 2 redes; solo el perímetro separa.
- `webapp` = pivote hacia la red interna.
- Débil por diseño: credenciales en el entorno · tráfico en claro · sin detección.

## Notas del orador

El Escenario A reproduce lo que uno encuentra por defecto: dos redes, una zona expuesta y una interna, con el perímetro como única barrera. Pero fíjense en `webapp`: está en las dos redes a la vez, así que hace de puente hacia el interior. Y, a propósito, dejo tres debilidades típicas de una configuración heredada: la contraseña de la base de datos está en el entorno de `webapp`, el tráfico entre servicios va en texto claro, y no hay ningún sistema de detección. Quiero subrayar algo importante: este escenario *no pretende ser seguro*. Es la referencia, el "antes", contra el que voy a medir la mejora. Si aquí el atacante lo consigue todo, tendré una vara clara para valorar cuánto contiene el Escenario B.

## Tiempo estimado

1:00

## Transición

"Sobre esa misma aplicación, apliquemos ahora los principios de Zero Trust."

---

# Slide 10 — Escenario B: Zero Trust (microsegmentación + mTLS + observabilidad)

## Objetivo

- **Por qué existe:** mostrar cómo tres controles concretos cierran, uno a uno, las debilidades del Escenario A. Es la diapositiva de diseño de mayor peso.
- **Qué pregunta responde:** "¿qué se cambia exactamente y qué debilidad neutraliza cada cambio?".
- **Qué debe entenderse antes de pasar:** tres zonas aisladas (deny by default), mTLS en el canal crítico (estar en la red ≠ poder hablar) y Wazuh observando los comandos del atacante.

## Contenido visual

- Figura principal `img/cap04-topologia-zerotrust.jpg`: tres zonas (`web_zone`, `backend_zone`, `db_zone`); sin ruta directa `webapp → db`.
- Insertos pequeños (una idea cada uno, no saturar):
  - `img/cap04-mtls-handshake.jpg` → mTLS en `webapp → backend`.
  - `img/cap04-wazuh-zerotrust.jpg` → Wazuh (manager + agente) observando `webapp`.
- Tres etiquetas que emparejan control ↔ debilidad del A: microsegmentación ↔ pivote; secretos solo en `backend` ↔ credenciales en el entorno; mTLS ↔ tráfico en claro.

## Contenido de slide

- 3 zonas aisladas; denegado por defecto; sin ruta `webapp → db`.
- mTLS en `webapp → backend`: identidad, no solo cifrado.
- Secretos solo en `backend` (`webapp` sin `DB_PASSWORD`).
- Wazuh: detección de los comandos post-RCE.

## Notas del orador

El Escenario B es la misma aplicación, pero con la red rediseñada según Zero Trust, y prefiero contarlo como "cada cambio tapa una de las grietas de antes". Primero, microsegmentación: en lugar de dos redes, tres zonas aisladas, y solo se permite lo estrictamente necesario; todo lo demás, denegado por defecto. Como `webapp` ya no comparte red con la base de datos, el pivote de antes desaparece: no hay ruta hacia `db`. Segundo, identidad de servicio con mTLS en el canal hacia el backend: ahora los dos extremos presentan certificado, de modo que estar en la red ya no basta para que te atiendan; sin certificado válido, la petición se rechaza, y de paso el tráfico va cifrado. Tercero, saco las credenciales de la base de datos del entorno de `webapp`: viven solo en el backend, que es el único que las necesita. Y como capa extra añado observabilidad con Wazuh, que vigila los comandos que el atacante lanza desde la shell. Tres controles, tres grietas cerradas.

## Tiempo estimado

1:45

## Transición

"La teoría está clara; ahora vean lo que pasa cuando ataco las dos redes exactamente igual. Lo he grabado para mostrárselo lado a lado."

---

# Slide 11 — DEMO (vídeo): el mismo ataque, dos desenlaces

## Objetivo

- **Por qué existe:** aportar la prueba visceral y comparable del contraste A vs B, sin el riesgo de una demo en directo (la guía advierte que un fallo técnico proyecta improvisación).
- **Qué pregunta responde:** "¿de verdad pasa lo que dices? Enséñamelo."
- **Qué debe entenderse antes de pasar:** en A el atacante completa la cadena y roba datos; en B los mismos comandos fracasan y quedan registrados.

## Contenido visual

- **Vídeo pregrabado ~2:30**, pantalla partida: **izquierda = Escenario A**, **derecha = Escenario B**, ejecutando los mismos 4 hitos en paralelo.
- Rótulos sobreimpresos por hito para que el tribunal siga el hilo sin depender del audio.
- Fuentes de grabación disponibles en el repo: `tests/img/perimetral_sesion_*` y `tests/img/Fotos PRE RCE (webapp)*` (fase de entrada), sesión `tests/logs/zerotrust_sesion_20260609_130120/` (A vs B), figuras `cap06-*`.

## Guion del vídeo (rótulos + qué se ve)

1. **Punto de partida (0:00–0:20):** reverse shell operativa en `webapp` en ambos lados (entrada idéntica, ya conseguida).
2. **Hito 1 — Credenciales (0:20–0:45):** A: aparece `DB_PASSWORD` en el entorno. B: entorno sin credenciales (`creds.txt` vacío).
3. **Hito 2 — Escaneo interno (0:45–1:15):** A: `nmap` ve los 3 servicios. B: solo `nginx:80`; `db` no resuelve; `:5000` cerrado. En B salta la alerta de Wazuh (rótulo "detectado, 22 s").
4. **Hito 3 — Backend (1:15–1:45):** A: `GET /empleados` devuelve el JSON. B: HTTPS sin certificado → **400** (rechazado por mTLS).
5. **Hito 4 — Base de datos (1:45–2:10):** A: `psql` vuelca la tabla. B: `db` inalcanzable, `psql` falla.
6. **Cierre del vídeo (2:10–2:30):** captura `tcpdump`: A muestra JSON en claro; B solo tráfico TLS.

## Contenido de slide

- (La diapositiva es el propio vídeo; título breve arriba: "Mismo ataque, dos desenlaces".)

## Notas del orador

He preparado un vídeo para que lo vean con sus propios ojos, y lo he hecho a pantalla partida: a la izquierda el escenario perimetral, a la derecha el Zero Trust, ejecutando exactamente los mismos comandos al mismo tiempo. Fíjense en el paralelismo hito a hito. [Dejar respirar el vídeo; intervenir solo en los momentos clave.] A la izquierda todo funciona: aparecen las credenciales, el escaneo ve toda la red, el backend entrega los datos y la base de datos se vuelca entera. A la derecha, los mismos comandos van chocando contra un muro distinto cada vez: no hay credenciales, el escaneo se queda casi ciego, el backend rechaza la conexión por falta de certificado y la base de datos ni siquiera es alcanzable. Y, además, a la derecha Wazuh ha levantado la mano avisando del escaneo. Lo que acaban de ver de forma cualitativa es justo lo que ahora voy a ponerles en números.

## Tiempo estimado

2:30

## Transición

"Traduzcamos ese contraste a las seis métricas que definimos."

---

# Slide 12 — Resultados: la comparativa en seis métricas (clímax)

## Objetivo

- **Por qué existe:** es el pico persuasivo; concentra en una tabla la respuesta cuantitativa a la pregunta de investigación.
- **Qué pregunta responde:** "¿cuánto reduce el impacto Zero Trust, en cifras?".
- **Qué debe entenderse antes de pasar:** en todas las dimensiones medidas la contención mejora, con cifras memorables (profundidad −67 %, exfiltración a cero, tráfico protegido).

## Contenido visual

- **Tabla comparativa A vs B** con la columna de "mejora" resaltada (aparición progresiva fila a fila para guiar la lectura):

| Métrica | Escenario A | Escenario B | Mejora |
|---|---|---|---|
| G2 Profundidad del ataque | 3 nodos | **1 nodo** | **−67 %** |
| E1 Superficie interna visible | 3/3 | **1/3** | **−67 %** |
| E2 Volumen exfiltrado | ~766 B (3 reg. + 1 cred.) | **0 B** | **anulada** |
| E3 Integridad del tráfico | Texto claro | **Cifrado + rechazado** | mTLS + PEP |
| G3 Bloqueo de comandos | 0 % | **100 %** | contención total |
| G1 Detección | Inexistente | **Alerta a 22 s** | observabilidad activa |

- Dos números "titular" en grande: **3 nodos → 1** y **766 B → 0**.

## Contenido de slide

- Tabla A vs B (6 métricas).
- Titulares: profundidad −67 % · exfiltración a cero.
- (Ver nota sobre G1 en la siguiente diapositiva.)

## Notas del orador

Estas son las seis métricas, lado a lado. Empiezo por la que más me importa: la profundidad del ataque. En el perímetro, el atacante recorre los tres nodos de la red; en Zero Trust se queda en uno. Es una reducción del 67 % en alcance lateral: mantiene la shell en la puerta de entrada, pero no consigue avanzar. La superficie que llega a ver cae en la misma proporción, de tres servicios a uno. La exfiltración es quizá el dato más rotundo: pasa de unos setecientos sesenta y seis bytes —credenciales y datos de empleados— a cero bytes; no se lleva nada. El tráfico interno deja de ser legible: donde antes se leía el JSON en claro, ahora solo hay TLS y, sin certificado, un rechazo. En conjunto, de no bloquear ningún comando a bloquearlos todos. Y, además, aparece detección donde antes no había nada. Sobre esa última métrica quiero ser honesto, y lo explico en la siguiente diapositiva.

## Tiempo estimado

2:00

## Transición

"Antes de celebrar los números, conviene entender *por qué* salen así, y matizar uno de ellos."

---

# Slide 13 — Por qué ocurre: cada mejora, su mecanismo (y la aportación)

## Objetivo

- **Por qué existe:** convertir "números buenos" en "causalidad entendida" —lo que convence a un tribunal técnico de que no es casualidad— y declarar de forma explícita la contribución.
- **Qué pregunta responde:** "¿a qué se debe cada mejora y qué aporta este trabajo que no existía?".
- **Qué debe entenderse antes de pasar:** la contención no descansa en una sola barrera, sino en tres controles distintos; y la aportación es precisamente esta **medición comparable**, que la literatura no ofrecía.

## Contenido visual

- Tabla de atribución mejora → mecanismo (2 columnas):
  - Profundidad y superficie ↓ → **microsegmentación** + backend escuchando solo en loopback.
  - Exfiltración = 0 → **secretos aislados** en `backend`.
  - Tráfico protegido / backend inaccesible → **mTLS** (rechazo 400 sin certificado).
  - Detección → **Wazuh** (host-based).
- **Recuadro de contribución destacado** (estilo `tcolorbox`): *"La aportación no es una tecnología nueva, sino la medición controlada y comparable del impacto —el hueco de la slide 6, ahora cubierto con datos reproducibles."*
- Matiz honesto de G1 en pie: en A no hay SIEM por diseño; no se compara "quién detecta antes", sino que la capacidad de detección **solo existe** en B.

## Contenido de slide

- Profundidad/superficie ↓ ← microsegmentación.
- Exfiltración 0 ← secretos solo en `backend`.
- Tráfico ← mTLS (rechazo sin certificado).
- Detección ← Wazuh.
- **Aportación: la medición comparable, no la tecnología.**

## Notas del orador

Lo valioso no es solo que los números mejoren, sino poder atribuir cada mejora a un mecanismo concreto. La reducción de profundidad y de superficie viene de la microsegmentación y de que el backend solo escucha en su interfaz local. Que la exfiltración sea cero viene de haber aislado los secretos en el backend. Que el tráfico esté protegido y el backend sea inaccesible viene del mTLS, que rechaza cualquier petición sin certificado. Y la detección, de Wazuh. Es decir, la contención no depende de una única barrera: si una fallara, las otras siguen en pie. Un matiz honesto sobre la detección: en el escenario perimetral no hay SIEM por diseño, así que no estoy diciendo que Zero Trust "detecte antes"; estoy diciendo que la capacidad de detectar solo existe en él. Y aquí está la aportación de este trabajo: no he inventado ninguna tecnología nueva; lo que aporto es la medición controlada y comparable de estos mecanismos, exactamente el hueco que señalé al principio y que la literatura apenas cubría.

## Tiempo estimado

1:15

## Transición

"Con esto puedo volver a la pregunta con la que empecé y responderla."

---

# Slide 14 — Conclusiones: hipótesis confirmada

## Objetivo

- **Por qué existe:** cerrar el círculo respondiendo a la pregunta y confirmando la hipótesis y los objetivos.
- **Qué pregunta responde:** "¿se ha respondido a la pregunta de investigación?".
- **Qué debe entenderse antes de pasar:** sí; la hipótesis se confirma en lo esencial y los cuatro objetivos específicos se cumplieron.

## Contenido visual

- La **pregunta de investigación** (slide 6) reaparece arriba y, debajo, una respuesta en una línea con un check.
- Tres iconos-resultado: profundidad ↓, exfiltración = 0, tráfico protegido.
- Barra de "objetivos específicos": 4/4 cumplidos.

## Contenido de slide

- Hipótesis **confirmada**: menor profundidad, exfiltración anulada, tráfico protegido.
- 4/4 objetivos específicos cumplidos.
- Zero Trust contiene el daño post-explotación en contenedores.

## Notas del orador

Vuelvo a la pregunta del principio: en qué medida Zero Trust reduce el impacto de un ataque una vez dentro. La respuesta, con los datos en la mano, es que lo reduce de forma sustancial en todas las dimensiones que medí. La hipótesis se confirma: menor profundidad del compromiso, exfiltración anulada y tráfico interno protegido. Los cuatro objetivos específicos que me marqué se cumplieron: diseñé y desplegué las dos infraestructuras, definí y medí métricas comparables, ejecuté el mismo ataque reproducible en ambas y añadí una capa de detección. La conclusión de fondo es que una arquitectura Zero Trust basada en microsegmentación e identidad de servicio reduce de forma significativa el impacto de una intrusión en una infraestructura contenerizada.

## Tiempo estimado

1:00

## Transición

"Ahora bien, sería deshonesto presentar estos resultados sin sus límites."

---

# Slide 15 — Limitaciones y trabajo futuro

## Objetivo

- **Por qué existe:** demostrar rigor y autocrítica (muy valorado por un tribunal) y proyectar continuidad.
- **Qué pregunta responde:** "¿hasta dónde son válidos estos resultados y qué vendría después?".
- **Qué debe entenderse antes de pasar:** los resultados son ilustrativos (una sesión, laboratorio local, alcance post-explotación), y hay líneas claras de continuación (Kubernetes/service mesh, más sesiones, SOAR).

## Contenido visual

- Dos columnas enfrentadas: **Limitaciones** (izq.) ↔ **Trabajo futuro** (der.), emparejando cada límite con su línea de mejora.
  - Una sola sesión oficial → repetir con N sesiones (soporte estadístico).
  - Laboratorio Docker local → Kubernetes + service mesh (Istio/Envoy).
  - Alcance post-explotación → incluir más vectores.
  - Detección pasiva → respuesta automática (SOAR).

## Contenido de slide

- Limitaciones: 1 sesión · laboratorio local · alcance post-RCE · mTLS en un canal.
- Futuro: Kubernetes + malla de servicios · más sesiones · SOAR.

## Notas del orador

Estos resultados hay que leerlos con sus límites, y prefiero decirlos yo. El primero es el tamaño de la muestra: son valores de una sesión oficial por escenario, reproducibles y coherentes con lo esperado, pero no una media estadística; hay que leerlos como ilustrativos del comportamiento de cada arquitectura. El segundo es el alcance: mido lo que pasa *después* del compromiso, no cómo se previene la entrada. Y el tercero, el entorno: es un laboratorio Docker local, no un clúster en producción. Cada límite marca su continuación natural: repetir el experimento con muchas sesiones para dar soporte estadístico, llevar las mismas políticas a Kubernetes con una malla de servicios para validar a escala, y cerrar el ciclo detección-respuesta con automatización. Son líneas que dan continuidad al trabajo sin cambiar su tesis.

## Tiempo estimado

0:45

## Transición

"Y para terminar, por qué creo que esto importa más allá del ejercicio académico."

---

# Slide 16 — Cierre: impacto, ODS y gracias

## Objetivo

- **Por qué existe:** dejar una última idea memorable (valor práctico + impacto social) y abrir el turno de preguntas.
- **Qué pregunta responde:** "¿para qué sirve esto en el mundo real?".
- **Qué debe entenderse antes de pasar:** el trabajo aporta un criterio cuantitativo para priorizar inversiones en seguridad y contribuye a infraestructuras más resilientes (ODS 9 y 16).

## Contenido visual

- Una frase-ancla grande: *"Estar dentro de la red ya no basta para confiar en ti."*
- Logotipos ODS 9 e ODS 16 discretos.
- Datos de contacto y "¿Preguntas?".

## Contenido de slide

- Criterio cuantitativo para justificar microsegmentación e identidad de servicio.
- Redes que se degradan de forma controlada, no se hunden.
- ODS 9 (infraestructura resiliente) y ODS 16 (menos impacto de la ciberdelincuencia).
- Gracias · ¿Preguntas?

## Notas del orador

Termino con el porqué de todo esto. Muchas veces "adopta Zero Trust" se queda en una recomendación genérica. Este trabajo aporta un criterio cuantitativo: permite a un equipo de plataforma justificar con datos cuánto se reduce el alcance de una intrusión al invertir en microsegmentación e identidad de servicio. En el fondo se trata de que una red, cuando la comprometen, se degrade de forma controlada en lugar de caer entera. Eso conecta con dos Objetivos de Desarrollo Sostenible: el 9, por unas infraestructuras digitales más resilientes, y el 16, por reducir el daño que la ciberdelincuencia causa a personas e instituciones. Con esto concluyo. Muchas gracias por su atención; quedo a su disposición para las preguntas que quieran hacerme.

## Tiempo estimado

0:30

## Transición

(Fin de la exposición → turno de preguntas del tribunal.)

---

# Slides de backup (para el turno de preguntas)

> No cuentan en los 20 min. Se saltan en la exposición y se muestran solo si el tribunal pregunta. Cubren el detalle de implementación que se apartó del flujo principal (regla conceptual-no-implementación).

## B1 — Operacionalización de las 6 métricas

- **Cuándo usarla:** si preguntan cómo se define/mide cada KPI.
- **Visual:** tabla de la memoria §3.4 (código · nombre · definición · operacionalización), incl. las tuplas `(mecanismo_existe, valor)` de G1 y G3.
- **Idea:** cada métrica tiene una definición operacional cerrada y el mismo protocolo en A y B.

## B2 — Cadena de acceso inicial (fuera de la ventana de medición)

- **Cuándo usarla:** si preguntan cómo se entra o por qué es realista.
- **Visual:** capturas `cap05-pre-rce-*.jpg` (recon → `robots.txt` → `backup.txt` → panel → SSTI) o `tests/img/Fotos PRE RCE (webapp)*`.
- **Idea:** cadena OWASP realista con debilidades CWE (200, 522, 308, 1336) que termina en RCE; **idéntica en A y B**, por eso no entra en la comparación.

## B3 — Implementación de mTLS

- **Cuándo usarla:** si piden detalle de cómo se hace la autenticación mutua.
- **Visual:** `cap05-mtls-openssl.jpg` (CA/certificados), `cap05-mtls-nginx-conf.jpg` (`ssl_verify_client on`), `cap05-mtls-verificacion.jpg` (curl con cert → 200 / sin cert → 400).
- **Idea:** CA local con OpenSSL; nginx del backend como punto de aplicación de políticas; certificados montados como volúmenes (rotables sin reconstruir imagen).

## B4 — Reglas de detección Wazuh

- **Cuándo usarla:** si preguntan por la observabilidad o la alerta de 22 s.
- **Visual:** tabla de reglas 100100–100104 (nmap, curl→backend, tcpdump, psql, grep) + alerta JSON de la regla 100100 (memoria §6.3).
- **Idea:** HIDS que muestrea procesos en `webapp` cada 2 s (fuente `process-webapp`); reglas alineadas con los hitos.

## B5 — Justificación metodológica: una sola sesión oficial

- **Cuándo usarla:** si cuestionan la validez estadística.
- **Visual:** captura de la carpeta de evidencias de la sesión `zerotrust_sesion_20260609_130120` (logs, pcap, alertas).
- **Idea:** los valores son reproducibles vía scripts y coherentes con el comportamiento esperado de cada control; se presentan como **ilustrativos**, no como media poblacional (limitación reconocida; el trabajo futuro contempla N sesiones).

## B6 — Segmentación verificada / topología en compose

- **Cuándo usarla:** si piden evidencia de que la segmentación funciona a nivel de red.
- **Visual:** `cap05-zt-segmentacion-test.jpg` (intento `webapp → db` → timeout) y `cap05-zt-compose-networks.jpg`.
- **Idea:** `db` no es alcanzable ni por IP directa desde `webapp`; la microsegmentación elimina la ruta, no solo la resolución DNS.

## B7 — Decisión Wazuh vs Suricata

- **Cuándo usarla:** si preguntan por qué HIDS y no una sonda de red.
- **Idea:** los hitos son comandos dentro del contenedor (nmap, curl, psql, grep); Wazuh (host-based) ve el `cmdline`, Suricata (network-based) no lo sustituye. Suricata queda como línea futura complementaria.

---

# Checklist de validación final

- [x] **Duración:** suma ≈ 19:15 (≤ 20:00, con ~45 s de colchón para el directo). Verificar en ensayo cronometrado.
- [x] **Densidad:** una idea por diapositiva; ≤ 75 palabras por slide; prioridad al grafismo.
- [x] **Narrativa continua:** problema → fundamentos → hueco/pregunta → propuesta → método → escenarios → demo → resultados → porqué/contribución → conclusiones → cierre.
- [x] **Hueco/pregunta antes de la solución** (slide 6 antes de la 7).
- [x] **Método antes de los escenarios** (slide 8 antes de 9–10): rasero común primero.
- [x] **Clímax:** demo (11) → resultados (12) → atribución+contribución (13).
- [x] **Contribución visible:** enunciada en 6, demostrada en 11–12, declarada en recuadro en 13, reafirmada en 14 y 16.
- [x] **Nivel técnico:** flujo principal conceptual (`cap04-*`, `cap06-*`); implementación (`cap05-*`) y KPIs finos derivados a backup.
- [x] **Propósito por slide:** cada *Objetivo* responde por-qué-existe / qué-pregunta-responde / qué-entender-antes.
- [x] **Honestidad:** matiz de G1 (sin SIEM en A) y limitaciones explícitas (una sesión, laboratorio local, alcance post-RCE).
- [x] **Notas del orador:** amplían la slide, no la leen; ensayables.
- [x] **Guía ETSINF:** público = tribunal generalista; mini-índice de navegación; fuentes de imágenes citadas; control de tiempo previsto.

## Pendientes de producción (no bloquean el blueprint)

- [ ] **Grabar el vídeo demo** (~2:30, pantalla partida A vs B) según el guion de la slide 11.
- [ ] Maquetar las diapositivas (respetar 16:9 y 4:3 por si el proyector de sala es 4:3; llevar copia en PDF).
- [ ] Ensayo final cronometrado con el tutor; ajustar tiempos si algún bloque se desvía.
