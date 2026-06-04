# HOY — 2026-06-04 (jueves) · ⚠️ CHECKPOINT WAZUH 20:00

> **Situación:** Fases 1–4 del Escenario B completadas ayer (segmentación + secretos + mTLS verificado). El ADR de arquitectura Wazuh Opción B (manager + agent como contenedores Docker) ya está registrado en `admin/DECISIONS_LOG.md`. El stack de Wazuh está creado en `infra/zero_trust/wazuh/` y se está construyendo ahora mismo.
> Plan ID: `implementar_escenario_b`
> Fase: 2 de 4 · Semana 2 · **Checkpoint duro a las 20:00**

---

## OBJETIVO DEL DÍA

Tener `wazuh-manager` + `wazuh-agent` levantados y comunicándose, con **al menos 1 alerta activa** visible en los logs del manager. Eso desbloquea las reglas de los 4 hitos post-RCE mañana (05/06).

---

## SI SOLO HACES UNA COSA

Verifica que el manager recibe un evento del agente antes de las 20:00. Aunque sea la regla genérica `100110` (exec detectado en contenedor) disparando por cualquier `docker exec`. Con eso el checkpoint está superado.

---

## PENDIENTE INMEDIATO (antes de meterse con alertas)

Estos tres ítems venían de ayer y deben cerrarse primero:

- [ ] **Commit** del estado estable de las Fases 1–4:
  ```bash
  cd /mnt/c/Users/coryy/TFG/TFG-ZeroTrust
  git add infra/zero_trust/ docs/04_diario_laboratorio/ admin/DECISIONS_LOG.md
  git commit -m "Escenario B: segmentacion 3 zonas + secretos + mTLS webapp-backend verificado"
  ```
- [ ] **Verificar arranque limpio** del stack principal antes de trabajar con Wazuh:
  ```bash
  cd infra/zero_trust
  docker compose down && docker compose up --build -d
  docker compose ps   # todos healthy
  ```
- [ ] **Registrar ADR 2026-06-04** en `admin/DECISIONS_LOG.md` si aún no está — la decisión de Opción B (manager + agent en Docker) ya debería estar ahí; confirmar.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 1h · Levantar el stack Wazuh

El compose de Wazuh ya existe en `infra/zero_trust/wazuh/docker-compose.yaml` con:
- `wazuh-manager`: imagen oficial `wazuh/wazuh-manager:4.9.2`, puertos 1514/1515/55000
- `wazuh-agent`: imagen custom (Dockerfile en `wazuh/agent/`), socket Docker montado + `--pid=host`
- `local_rules.xml` con las 5 reglas custom del grupo `zerotrust,` montado en el manager

```bash
cd infra/zero_trust/wazuh
docker compose up --build
# Esperar a que wazuh-manager esté healthy (healthcheck: wazuh-control status)
# El agente espera al manager con depends_on condition: service_healthy
```

- [ ] Manager arranca y healthcheck pasa (puede tardar 2-3 min)
- [ ] Agente levanta y en sus logs aparece `Connected to the server`
- **Hecho cuando:** `docker compose ps` muestra ambos servicios Up y el agente sin reinicios continuos

---

### Bloque 2 — 2h · Verificar enrollment y primera alerta

Una vez los dos contenedores están Up:

**Verificar enrollment:**
```bash
# En el manager — listar agentes enrollados
docker exec wazuh-wazuh-manager-1 /var/ossec/bin/manage_agents -l
# Debe aparecer: zt-lab-agent
```

**Forzar la primera alerta (regla 100111 — exec en webapp):**
```bash
# El agente escucha eventos Docker vía socket. Un exec en webapp debe disparar la regla 100111.
# Desde otro terminal, mientras el agente corre:
docker exec zero_trust-webapp-1 echo "test"

# Verificar en los logs del manager que llegó el evento:
docker exec wazuh-wazuh-manager-1 tail -f /var/ossec/logs/alerts/alerts.json | grep -i "zerotrust\|100111\|webapp"
```

- [ ] `zt-lab-agent` aparece en `manage_agents -l` con estado `Active`
- [ ] Al menos 1 evento/alerta visible en `alerts.json` con origen en el agente
- **Hecho cuando:** hay ≥1 alerta activa. Este es el criterio del checkpoint de las 20:00.

---

### Bloque 3 — 2h · Probar las reglas de los 4 hitos (si el tiempo lo permite)

Si el enrollment y la primera alerta están funcionando antes de las 18:00, avanzar con las reglas del día de mañana:

**Regla 100100 — nmap (T1046, reconocimiento interno):**
```bash
docker exec zero_trust-webapp-1 nmap -p 80,443,5000,5432 backend
# Buscar en alerts.json: "nmap" + level 12
```

**Regla 100101 — curl hacia backend (T1041):**
```bash
docker exec zero_trust-webapp-1 curl -sk https://backend/empleados
# Buscar en alerts.json: "curl.*backend" + level 10
```

**Regla 100111 — exec general en webapp:**
```bash
docker exec zero_trust-webapp-1 env | grep -i db
# Buscar en alerts.json: level 12, campo docker.Actor.Attributes.name = webapp
```

- [ ] Cada regla disparada genera una entrada en `alerts.json` (no necesita estar completo hoy)
- **Hecho cuando:** ≥3 reglas distintas disparan alerta (bonus, no obligatorio para el checkpoint)

---

### Bloque 4 — 1h · Documentar y commit

- [ ] Abrir `docs/04_diario_laboratorio/20260604_Sesion_Wazuh_Docker.md` y registrar:
  - Comandos exactos usados para levantar el stack
  - Output de `manage_agents -l`
  - Fragmento del `alerts.json` con la primera alerta
  - Errores encontrados y soluciones aplicadas
- [ ] Commit de todo:
  ```bash
  git add infra/zero_trust/wazuh/ docs/04_diario_laboratorio/20260604_Sesion_Wazuh_Docker.md
  git commit -m "Wazuh Fase 5: manager+agent Docker, primera alerta activa"
  ```

---

## DECISIÓN A LAS 20:00 — BINARIA, SIN APLAZAMIENTO

| Condición a las 20:00 | Acción |
|---|---|
| `zt-lab-agent` enrolled + ≥1 alerta en `alerts.json` | ✅ Continuar mañana con reglas completas (05/06) |
| Sin enrollment o sin alerta | ❌ Activar Falco — ver protocolo en ADR 2026-05-24 de `admin/DECISIONS_LOG.md` |

**Si activas Falco:**
```bash
git stash  # o rama separada
mkdir infra/zero_trust/falco/
# Ver ADR 2026-05-24 para los pasos exactos (3-4h de reconversión estimadas)
```

---

## NO HACER HOY

- No toques `infra/zero_trust/docker-compose.yaml` (el stack principal ya está verificado)
- No intentes instalar Wazuh como servicio nativo en WSL2 — eso es Opción A, descartada en el ADR del día
- No empieces a redactar el diario hasta tener la primera alerta confirmada
- No abras la plantilla KPI v2 §2 hasta mañana (la captura formal de KPIs es del 06-08/06)
- No pierdas más de 30 min en cualquier error que no sea el enrollment; si a las 16:00 no hay agente enrollado, revisar `ossec.conf` y los logs del contenedor agente directamente

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

El día es exitoso si al terminar puedes marcar esto:

- [ ] Stack `infra/zero_trust/` principal levanta healthy (prerequisito de ayer cerrado)
- [ ] `wazuh-manager` + `wazuh-agent` Up en `infra/zero_trust/wazuh/`
- [ ] `zt-lab-agent` aparece como `Active` en `manage_agents -l`
- [ ] ≥1 alerta visible en `alerts.json` antes de las 20:00
- [ ] Commit con el estado de Wazuh

---

## CIERRE

Al terminar:
1. Registra la decisión del checkpoint (continuar Wazuh o activar Falco) en `admin/STATE.md` y en `admin/DECISIONS_LOG.md` si aplica.
2. Si Wazuh pasó el checkpoint: copia el bloque `### 2026-06-05` de `admin/AGENDA_SPRINT_DIARIA.md` en este archivo para mañana.
3. Si activaste Falco: el objetivo de mañana cambia — 3 reglas Falco equivalentes a las Wazuh previstas.
4. **Hito del 09/06 en 5 días:** Escenario B funcional + KPIs §2/§3 cerrados. Wazuh/Falco tiene que estar estable antes del 06/06 para las pruebas A/B.
