# Diagnóstico de estado al 9 de mayo

## Lo que ya está cerrado

- Escenario A perimetral **funcionalmente completo**: 4 contenedores arrancan, healthcheck verde, cadena de ataque HTB-style validada end-to-end (recon → backup.txt → login → SSTI → RCE → lateral).
- Documentación de proceso al día: doc de sesión del refactor + apuntes técnicos SSTI + DECISIONS_LOG actualizado.

## Deuda pendiente

| Tipo | Tarea | Estimación | Bloqueante de |
|---|---|---|---|
| **D2 sub-tareas** | Capturas gráficas del navegador para la memoria | ~1.5h | T4, capítulo "Pruebas" |
| **D2 sub-tareas** | Cronometrar KPIs nuevos (sec. 7 del doc de refactor) | ~1h | Comparativa con Escenario B |
| **TODO T4** | Documentar flujo de ataque completo con capturas | ~2h | Capítulo "Pruebas" |
| **TODO T5** | Borrador "Estado del Arte" (NIST, IEEE, NIST 800-207, OWASP) | ~10-15h | Capítulo 2 de la memoria |
| **TODO T6** | Investigación Wazuh / Zero Trust | ~5-8h | Todo el Escenario B |

# Lo siguiente que tienes que hacer — recomendación

## Próximo paso inmediato: **cerrar el "antes" del Escenario A**

El roadmap pide entrar en mayo en **Escenario B (Zero Trust + Wazuh)**, pero **avanzar a ZT sin capturas/KPIs medidos del baseline perimetral te deja sin comparativa**, que es el corazón del TFG.

Concretamente, en este orden:

### 1. Capturas + cronometraje del ataque actual (~2.5h, hoy/mañana)

Ejecuta la cadena completa con el navegador en una sola sesión y captura:

| Captura | Qué muestra | KPI asociado |
|---|---|---|
| Portal `/` | UI corporativa benigna | T0 (inicio) |
| `curl -I` | header `X-Powered-By` | T_recon_http |
| `/robots.txt` | rutas señuelo | T_recon_rutas |
| `/backup.txt` | credenciales filtradas | T_disclosure |
| `/admin/login` form | Bootstrap card login | — |
| Dashboard tras login | Cookie de sesión activa | T_auth |
| `?host={{7*7}}` → `49` | confirmación SSTI | T_ssti_detect |
| `?host={{...popen('id')...}}` → `uid=0(root)` | RCE confirmada | T_rce |
| `?host={{...popen('env')...}}` → `DB_PASSWORD` | exfiltración credencial | T_exfil_creds |
| `?host={{...popen('curl backend')...}}` → JSON empleados | movimiento lateral | T_lateral |
| `psql -h db` desde `webapp` | dump completo de la DB | T_objetivo |

Guarda los tiempos en una tabla. Esa tabla **es** el "antes" del experimento principal.

Esto cierra D2, T2, T3 y T4 de una vez.

### 2. Decidir entre dos caminos en paralelo (próxima semana)

A partir de aquí tienes **dos vías de trabajo de naturaleza distinta** que puedes alternar para no estancarte:

#### Vía técnica → empezar Escenario B (T6 → Wazuh + Zero Trust)
- Investigar Wazuh (~3h): ¿qué es, cómo se despliega, qué reglas vienen out-of-the-box?
- Investigar Zero Trust práctico para Docker Compose (~3h): mTLS entre servicios, microsegmentación con redes Docker, secretos vía vault/Docker secrets, identidad con SPIFFE/OIDC.
- Diseñar `infra/zerotrust/docker-compose.yaml` siguiendo la misma estructura de 4 servicios pero con controles ZT sobre cada paso de la cadena de ataque que ya tienes documentada.

#### Vía académica → empezar T5 (Estado del Arte)
- Esqueleto del capítulo (~2h): introducción, secciones, índice.
- Revisión bibliográfica con las fuentes que ya tienes en `Apuntes_SSTI_Jinja2.md` sección 10 + las del prototipo perimetral.
- Redacción inicial: comparativa modelo perimetral vs Zero Trust, bases NIST 800-207, BeyondCorp Google, John Kindervag Forrester.

**Mi sugerencia operativa**: alterna las dos vías por bloques de 2-3h. La técnica te empuja el roadmap; la académica te paga la deuda del Cap 2 y queda lista cuando llegue julio (redacción intensiva).

### 3. Antes de tocar Wazuh: definir las políticas Zero Trust contra tu cadena

La sección 8 del [docs/01_investigacion/20260509b_Apuntes_SSTI_Jinja2.md](docs/01_investigacion/20260509b_Apuntes_SSTI_Jinja2.md) ya tiene la tabla mapeando cada paso del ataque a un control Zero Trust. Esa tabla **es la especificación de tu Escenario B**. Antes de instalar Wazuh, formaliza esa tabla en un nuevo `docs/01_investigacion/YYYYMMDD_Prototipo_ZeroTrust.md` (siguiendo la convención que acabamos de fijar).

# Riesgos a vigilar esta semana

| Riesgo | Mitigación |
|---|---|
| **Parálisis por exceso de detalle en capturas** | Timebox: 2.5h máximo. Si no terminas, mueve lo que falte a un nuevo D3 y sigue. |
| **Saltar al Escenario B sin medir el A** | Bloquea la fase Wazuh hasta tener la tabla de KPIs llena. |
| **Estado del Arte sigue posponiendo** | Reserva mínimo 2h/semana. Mejor empezar mal que no empezar. |
| **Mayo casi terminado y Escenario B sin tocar** | El roadmap acepta retraso del Escenario A si compensas con prototipo ZT mínimo viable antes de fin de mes. |

# Resumen ejecutivo

> **Esta semana:** capturas + KPIs del ataque actual (cierra D2 + T2-T4). 
> **Semana siguiente:** prototipo Escenario B en paralelo a borrador Estado del Arte.
> **Próximas 2 semanas:** Wazuh acoplado + medir ataque en Escenario B → comparativa lista para junio.