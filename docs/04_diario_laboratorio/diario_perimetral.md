# Diario de Trabajo TFG - Sesiones enfocadas en investigación, implementación y prueba de red perimetral

## 2026-05-03 - Empezar a montar red perimetral
Hoy 3 de mayo he estado montando la red perimetral, he estado montando el docker-compose, el cual me ha costado un poco. La red perimetral todavía no levanta, me falta: 
1. completar las imagenes del front y el back además de completar el código fuente de ambas
2. completar el config de nginx
3. completar el init.sql

## 2026-05-09 - Acabar montaje de red perimetral y probar ataque
Hoy, con la red perimetral ya montada y levantada he refactorizado la app para que se viese más realista, el flujo de ataque aumenta un poco en complejidad y realismo pero sigue siendo simple para ser adecuado al no ser el enfoque principal del TFG.
También he aprendido sobre la vunerabilidad SSTI

## 2026-05-10 - Preparación metodológica: KPIs, métricas y contexto académico

Sesión dedicada íntegramente a trabajo administrativo, documental y de planificación antes de ejecutar las capturas del ataque. No se ha tocado código ni infraestructura.

### Qué se ha hecho

**Contexto del tutor:**
- Se ha volcado y analizado el timeline completo de correos con el tutor Héctor (2025-11-19 → 2026-04-20), identificando las directrices clave y los patrones de comunicación.
- Creado `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md` con los 14 correos verbatim como material primario inmutable.
- Ampliado `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md` con dos secciones nuevas: §5 Metodología de Trabajo en Laboratorio y §6 Comunicación con el Tutor.
- Actualizado `admin/STATE.md` con el título oficial aprobado y la fecha de oficialización en EBRON.

**Métricas y KPIs:**
- Auditadas las 6 métricas validadas por el tutor contra el estado actual del Escenario A (cadena HTB-style del 09/05): 4 medibles directamente, 2 (G1 y G3) sin mecanismo en el modelo perimetral, 1 (E3) que requiere añadir un paso de tcpdump.
- Decidido el esquema de **doble dimensión** para G1 y G3: `(mecanismo_existe: bool, valor)` → en perimetral resultan `(false, ∞)` y `(false, 0%)`. Esto convierte la ausencia del mecanismo en evidencia estructural ("ausencia documentada"), no en omisión metodológica.
- Decidido mantener E3 añadiendo captura `tcpdump` durante el movimiento lateral para obtener el `.pcap` con tráfico HTTP en claro (evidencia directa del MITM).

**Artefactos generados:**
- `docs/04_diario_laboratorio/20260510a_Sesion_Analisis_KPI_Aplicabilidad.md` — análisis completo con alternativas descartadas y redacción sugerida para la memoria.
- `tests/00_PLANTILLA_KPI.md` — plantilla rellenable para la sesión de captura (Esc. A, Esc. B, cuadro comparativo final).
- Dos entradas nuevas en `admin/DECISIONS_LOG.md`: esquema doble dimensión para G1/G3 y tcpdump para E3.

### Qué NO se ha hecho todavía

- `docker compose up --build` no se ha ejecutado en esta sesión (T2 pendiente).
- No se han tomado capturas del ataque (D2 y T3 pendientes).
- No se han medido KPIs reales (toda la plantilla sigue en blanco).

---

### Próximos pasos para retomar la sesión

Ejecutar en este orden:

#### 1. Arrancar el entorno y guardar el log (T2)

```powershell
cd c:\Users\Pau\Documents\TFG\TFG-ZeroTrust\infra\perimetral
docker compose up --build 2>&1 | Tee-Object -FilePath "..\..\tests\logs\20260510_docker_compose_up.log"
```

Esperar a que los 4 contenedores estén en estado healthy antes de continuar.

#### 2. Ejecutar la cadena de ataque con capturas (D2 + T3)

Seguir el orden de la plantilla `tests/00_PLANTILLA_KPI.md` §1.2. Para cada paso:
- Anotar la hora absoluta (`HH:MM:SS`) y calcular Δ respecto a T0.
- Hacer captura de pantalla del navegador o terminal.
- Guardar la captura en `tests/logs/` con el patrón `YYYYMMDD_perimetral_<paso>.png`.

Pasos de la cadena por orden:

| T0 | Abrir `http://localhost/` en el navegador |
|---|---|
| T_recon_http | `curl -I http://localhost/` → header `X-Powered-By` |
| T_recon_rutas | `http://localhost/robots.txt` → 4 rutas Disallow |
| T_disclosure | `http://localhost/backup.txt` → `admin:Empresa2026!` |
| T_auth | POST login → dashboard + cookie |
| T_ssti_detect | `?host={{7*7}}` → `49` en `<pre>` |
| T_rce | Payload SSTI `popen('id')` → `uid=0(root)` |
| T_exfil_creds | Payload `popen('env')` → `DB_PASSWORD=supersecret` |
| T_lateral | Payload `popen('curl -s http://backend:5000/empleados')` → JSON Ana/Luis/Sara |
| T_objetivo | `psql -h db` desde webapp → dump completo |

#### 3. Captura tcpdump para E3 (durante T_lateral)

Antes de ejecutar el payload de movimiento lateral, abrir una segunda terminal:

```powershell
docker compose exec webapp sh -c "tcpdump -i any -w /tmp/lateral.pcap -c 50 host backend"
```

Después de lanzar el payload:

```powershell
docker compose cp webapp:/tmp/lateral.pcap tests/logs/20260510_lateral_perimetral.pcap
```

Abrir en Wireshark y verificar que el JSON de empleados es legible en texto claro.

#### 4. Rellenar la plantilla y cerrar tareas del sprint

- Rellenar `tests/00_PLANTILLA_KPI.md` §1 con todos los valores medidos.
- En `admin/STATE.md`: mover D2 a DONE, mover T2 y T3 a DONE, añadir entrada de sesión en el diario.
- Añadir entrada en este diario con los resultados obtenidos.