# HOY — 2026-06-05 (viernes) · 📬 RECUPERAR EMAIL TUTOR

> **Situación:** Checkpoint Wazuh del 04/06 **SUPERADO**. Stack completo operativo: microsegmentación + mTLS + Wazuh manager+agent + reglas MITRE T1046/T1552.004 verificadas end-to-end. La línea técnica va **por delante** de la agenda (~1 día de margen). Hoy aprovechamos ese margen para recuperar el hito vencido del correo al tutor.
> Plan IDs: `estudiar_otros_tfgs` → `redactar_borrador_indice_anotado` → `email_tutor_31_05`
> Fase: 2 de 4 · Semana 2 · **Sin deadline duro hoy**, pero el email debe salir antes de cerrar la sesión.

---

## OBJETIVO DEL DÍA

Enviar al tutor el borrador "razonablemente decente" que pidió en el correo del 24/05: **índice de los 8 capítulos + 2-3 frases por sección** describiendo qué se trata y con qué objetivo. Para llegar ahí hay que estudiar primero cómo lo hacen otros TFGs.

Las tareas técnicas del 05/06 (2 reglas Wazuh pendientes: `env | grep DB_` y `db:5432`) quedan como **bloque secundario** si queda tiempo por la tarde.

---

## SI SOLO HACES UNA COSA

Envía el email al tutor con el índice anotado antes de cerrar el ordenador. Aunque el §2.7 del EdA siga con `[TODO]`, el índice anotado + el estado técnico real es suficientemente decente para enviarlo ahora.

---

## CONTEXTO: QUÉ PIDIÓ EL TUTOR

Del correo **2026-05-24 (§16)** en `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md`:

> *"La idea sería que tuvieras un borrador lo antes posible sobre qué cosas vas a tratar en cada parte del TFG. Para ello tienes que hacer un trabajo de ver otros TFGs como lo hacen etc."*

Dos pasos obligatorios en ese orden:
1. Ver cómo estructuran la memoria otros TFGs similares.
2. Redactar el índice anotado (8 caps, 2-3 frases por cap).
3. Enviar con el estado real del proyecto.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 1.5h · Estudiar otros TFGs de referencia (`estudiar_otros_tfgs`)

**Dónde buscar:**
- [RiuNet UPV](https://riunet.upv.es/) — buscar "Zero Trust", "pentesting", "microsegmentación", "seguridad contenedores", "Docker seguridad"
- [TDX (repositorio TFG/TFM España)](https://www.tdx.cat/) — términos similares
- Google Scholar: `"trabajo fin de grado" "zero trust" OR "pentesting" filetype:pdf`

**Qué anotar de cada uno (3-5 trabajos):**
- Estructura de capítulos: ¿cuántos?, ¿qué orden?, ¿cómo nombran Diseño vs Implementación?
- Cómo plantean los objetivos y el alcance en Cap. 1 y Cap. 3
- Cómo presentan las pruebas: ¿tablas de métricas?, ¿capturas?, ¿escenarios concretos?
- Extensión aproximada por capítulo

- [ ] Localizar 3-5 TFGs/TFMs similares en los repositorios anteriores — 30 min
- [ ] Anotar estructura, profundidad y formato de cada uno — 40 min
- [ ] Consolidar patrones en `docs/02_reuniones_tutor/referencias_tfgs.md` — 20 min

**Hecho cuando:** tienes anotado cómo ≥3 TFGs estructuran su memoria y con qué profundidad tratan cada parte.

---

### Bloque 2 — 1.5h · Redactar el índice anotado (`redactar_borrador_indice_anotado`)

El esqueleto ya existe en `docs/03_memoria_tfg/`. El índice oficial del ROADMAP v2 es:

```
00_resumen.md
01_intro.md                → Motivación, objetivos, estructura
02_estado_arte.md          → Contenedores, ZT, NIST 800-207, BeyondCorp, OWASP
03_analisis_problema.md    → Modelo de amenazas v2 (validado), requisitos F/NF
04_diseno.md               → Arquitecturas A y B, tecnología, Wazuh vs Suricata
05_desarrollo_implantacion.md → IaC, decisiones implementación, diarios como fuente
06_pruebas.md              → Tablas KPI v2 §3, comparativa A vs B (corazón del TFG)
07_conclusiones.md         → Resultados, limitaciones, trabajo futuro
99_bibliografia.md
```

Para cada capítulo escribe:
- **Qué contiene:** 1-2 frases concretas sobre el contenido real (no genérico).
- **Objetivo:** qué pregunta o necesidad responde ese capítulo en el conjunto del TFG.
- **Estado actual:** si hay contenido ya redactado, en qué fase está.

Fuentes a combinar: esqueleto de `docs/03_memoria_tfg/`, spec `docs/01_investigacion/20260603_Prototipo_ZeroTrust.md`, modelo de amenazas v2 (correo 2026-03-17), título oficial.

- [ ] Redactar el índice anotado (8 capítulos × 2-3 frases) — 1h
- [ ] Alinear con modelo de amenazas v2 y título oficial: *"Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas"* — 20 min
- [ ] Marcar con `[REVISAR]` lo que aún no esté cerrado, no bloquearse — 10 min

**Hecho cuando:** tienes un documento / bloque de texto que podrías pegar directamente en un correo y que el tutor entienda de un vistazo qué hay en cada parte.

---

### Bloque 3 — 45 min · Componer y enviar el email (`email_tutor_31_05`)

**Estructura del email** (ver plantilla en `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md §7`):

1. **Asunto:** `TFG — Borrador de índice anotado + estado de implementación (jun 2026)`
2. **Apertura breve:** disculpa por el retraso (hito era el 31/05) + una frase de contexto.
3. **Cuerpo principal:** el índice anotado directamente en el cuerpo del correo (sin adjunto si es posible).
4. **Estado técnico actual:** mencionar que el Escenario B ya está implementado y verificado (Wazuh incluido), que las pruebas A/B formales son el 06-07/06, y que el objetivo es tener los caps. 3-6 en borrador antes del 14/06.
5. **Pregunta de validación:** ¿Le parece razonablemente decente el planteamiento para continuar hacia el 21/06?

- [ ] Componer email con índice anotado + estado real + plan hacia el 21/06 — 25 min
- [ ] **ENVIAR antes de las 20:00** — 5 min
- [ ] Registrar envío en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` con fecha y resumen del contenido — 15 min

**Hecho cuando:** el email está enviado y la bitácora actualizada.

---

### Bloque 4 (opcional, tarde) — 2h · Completar las 2 reglas Wazuh pendientes

Si el correo está enviado antes de las 17:00, aprovechar el tiempo restante para cerrar las 2 reglas del 05/06 que quedaban pendientes:

**Regla: lectura de variables de entorno con credenciales DB:**
```bash
# Disparar desde webapp:
docker exec zero_trust-webapp-1 env | grep -i db

# Verificar en manager:
docker exec wazuh-wazuh-manager-1 tail -50 /var/ossec/logs/alerts/alerts.json | grep -i "env\|DB_\|credential"
```

**Regla: bloqueo de conexión directa webapp → db:5432:**
```bash
# Intentar conexión directa desde webapp (debe fallar por microsegmentación):
docker exec zero_trust-webapp-1 nc -zv db 5432

# Verificar que el intento no llega — la segmentación de red lo debe bloquear
```

- [ ] Verificar/crear regla para `env | grep DB_` en `manager/local_rules.xml`
- [ ] Confirmar que webapp→db:5432 está bloqueado por microsegmentación (no necesita regla, solo evidencia)
- [ ] Documentar ambas verificaciones en `docs/04_diario_laboratorio/20260605_Sesion_ZT_Reglas.md`

---

## NO HACER HOY

- No empezar a redactar capítulos de la memoria (eso es Fase 3, semana del 08/06).
- No abrir la plantilla KPI v2 §2/§3 (captura formal de KPIs es el 06-07/06).
- No modificar el stack técnico (`infra/zero_trust/`) — está estable y verificado.
- No perfeccionar el EdA v0 hoy por el `[TODO]` de §2.7 — marcar con `[REVISAR]` y continuar.
- No esperar al tutor para avanzar: si no responde en 48h, se sigue según el plan (regla de no-bloqueo del ROADMAP v2).

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

El día es exitoso si al terminar puedes marcar esto:

- [ ] ≥3 TFGs de referencia revisados y anotados en `referencias_tfgs.md`
- [ ] Índice anotado redactado (8 capítulos × 2-3 frases)
- [ ] Email enviado al tutor con índice anotado + estado del proyecto
- [ ] Envío registrado en `BITACORA_REUNIONES.md`

---

## CIERRE

Al terminar:
1. Registra el envío en `BITACORA_REUNIONES.md` si no lo has hecho ya.
2. Marca `email_tutor_31_05` como DONE en `admin/STATE.md` (muévela de DOING a DONE).
3. Si completaste el Bloque 4: añade las 2 reglas a la documentación y actualiza `STATE.md`.
4. **Hito del 09/06 en 4 días:** Escenario B funcional + KPIs §2/§3 cerrados. Las pruebas A/B formales son el 06-07/06 — asegúrate de tener el entorno levantable limpio.
5. Mañana (06/06): copiar el bloque `### 2026-06-06` de `AGENDA_SPRINT_DIARIA.md` en este archivo.
