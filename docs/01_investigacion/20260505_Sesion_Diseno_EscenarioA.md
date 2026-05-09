# Sesión de diseño — Escenario A (Red Perimetral)

> **Periodo:** 19 de abril – 5 de mayo de 2026
> **Propósito de este documento:** Registro cronológico de las decisiones técnicas,
> correcciones y razonamiento tomados durante el diseño e implementación del Escenario A
> del TFG. Escrito para poder retomarlo semanas después sin fricción.

---

## Índice

1. [Punto de partida](#1-punto-de-partida)
2. [Fase 1 — Diseño inicial de la arquitectura](#2-fase-1--diseño-inicial-de-la-arquitectura)
3. [Fase 2 — Primera corrección: ¿una red o dos?](#3-fase-2--primera-corrección-una-red-o-dos)
4. [Fase 3 — Documentación del diseño](#4-fase-3--documentación-del-diseño)
5. [Fase 4 — Primera implementación y errores encontrados](#5-fase-4--primera-implementación-y-errores-encontrados)
6. [Fase 5 — Segunda corrección: ¿Docker Hub o app propia?](#6-fase-5--segunda-corrección-docker-hub-o-app-propia)
7. [Estado final — Diseño consolidado](#7-estado-final--diseño-consolidado)

---

## 1. Punto de partida

El objetivo era diseñar el **Escenario A** del TFG: una red perimetral con Docker que sirva como *baseline* para comparar con Zero Trust en el Escenario B.

El requisito del tutor (Héctor) era claro: el documento debe leerse como un **análisis de seguridad**, no como un manual de Docker. El foco es qué se ataca, qué se mide y por qué Zero Trust mejora la defensa.

El modelo de amenaza fijado era:
- **Atacante:** externo, no privilegiado, con RCE en el servicio web.
- **Activos a proteger:** base de datos y variables de entorno con credenciales.
- **Amenazas en alcance:** movimiento lateral, interceptación de tráfico interno, exfiltración de datos.

---

## 2. Fase 1 — Diseño inicial de la arquitectura

### Propuesta inicial

Se propuso una arquitectura de 4 servicios con 2 redes Docker:

```
[Host :80]
    │
  nginx          → net_dmz
    │
  webapp         → net_dmz + net_interna  (pivot)
    │
  backend        → net_interna
    │
  db             → net_interna
```

**Servicios:**

| Servicio | Imagen base | Rol de seguridad |
|---|---|---|
| `nginx` | `nginx:alpine` | Único punto de entrada. Define el perímetro. |
| `webapp` | `python:3.11-slim` | App con RCE intencional. **Pivot del ataque.** |
| `backend` | `python:3.11-slim` | API interna sin autenticación. Superficie de movimiento lateral. |
| `db` | `postgres:15-alpine` | Activo a proteger. Datos sensibles de prueba. |
| `attacker` | `kalilinux/kali-rolling` | Contenedor de ataque (solo con `--profile attack`). |

**Puntos débiles intencionales identificados (los 6 que se medirán):**

1. Confianza implícita en la red interna (sin autenticación entre servicios).
2. Segmentación agotada en el perímetro (una vez dentro, acceso total).
3. Movimiento lateral sin fricción (`webapp → db` en un salto).
4. Credenciales en texto plano (`env | grep PASSWORD` tras RCE).
5. Tráfico interno no cifrado (visible con `tcpdump`).
6. Perímetro como único control (una vulnerabilidad en `webapp` lo anula todo).

### Flujo de ataque planificado (6 pasos)

El ataque parte de RCE ya obtenida en `webapp` (asunción del modelo de amenaza):

```bash
# Paso 1: Reconocimiento — descubrir hosts en red interna
nmap -sn 172.20.0.0/24

# Paso 2: Identificar servicios
nmap -sV <IP_db>

# Paso 3: Extraer credenciales del entorno del proceso
env | grep -i password

# Paso 4: Acceder a la DB directamente
psql -h db -U postgres -d empresa_db -c "SELECT * FROM usuarios;"

# Paso 5: Movimiento lateral al backend
curl http://backend:5000/empleados

# Paso 6 (opcional): Capturar tráfico interno en claro
tcpdump -i eth0 -w /tmp/captura.pcap
```

---

## 3. Fase 2 — Primera corrección: ¿una red o dos?

### La duda

Surgió la pregunta: si el modelo perimetral es una "red plana", ¿no debería todo estar en la misma red Docker en lugar de separar DMZ e interna?

### El razonamiento

Se evaluaron dos opciones:

**Opción A — Red única (`net_unica`)**
Todo en una sola red. El argumento que produce es: *"sin segmentación hay vulnerabilidad"*. Válido, pero cualquier tribunal lo esperaría. Es el peor caso teórico, no un escenario realista.

**Opción B — Dos redes (DMZ + interna) ← elegida**
Reproduce cómo las organizaciones reales implementan el modelo perimetral: firewall exterior, DMZ con servidores web, red interna "protegida". La debilidad no es la ausencia de segmentación, sino que **esa segmentación se agota en el perímetro**. `webapp` actúa de pivot legítimo porque tiene acceso a ambas redes por diseño, y ese acceso no tiene ningún control interno.

**Argumento académico resultante:** *"Incluso con una arquitectura DMZ estándar de la industria, el modelo perimetral falla porque no hay microsegmentación ni autenticación dentro del perímetro."* Este argumento conecta directamente con la justificación de Zero Trust y es más difícil de rebatir ante el tribunal.

> **TODO para la memoria:** Buscar literatura sobre limitaciones del modelo DMZ.
> Referencias candidatas: NIST SP 800-207, John Kindervag (Forrester 2010), BeyondCorp (Google 2014).
> Incluir en "Estado del Arte" para justificar la elección arquitectónica.

---

## 4. Fase 3 — Documentación del diseño

Se creó el fichero de referencia técnica del Escenario A:

**`docs/01_investigacion/Prototipo Red perimetral.md`**

Contiene: modelo de amenaza, diagrama Mermaid de la topología, tabla de servicios, decisión de diseño razonada, estructura de ficheros, esqueleto del `docker-compose.yml` con comentarios de seguridad, flujo de ataque completo, tabla de KPIs y lista de puntos débiles.

Este documento es la **especificación técnica** del escenario. El código fuente real va en `infra/perimetral/`.

---

## 5. Fase 4 — Primera implementación y errores encontrados

### Estado al crear los ficheros

Se creó la estructura `infra/perimetral/` con el `docker-compose.yaml`, pero los ficheros de código fuente quedaron vacíos. Al intentar levantar el entorno con `docker compose up --build`, **no funcionaría**. Se identificaron 4 problemas:

**Problema 1 — Dockerfiles y código fuente vacíos (bloqueante)**
`webapp/Dockerfile`, `webapp/app.py`, `webapp/requirements.txt`, `backend/Dockerfile`, `backend/app.py` están vacíos. Docker falla en el paso `build` sin nada que construir.

**Problema 2 — Typo en `docker-compose.yaml` (bloqueante)**
En la sección `networks`, `net_interna` tenía `drive: bridge` en lugar de `driver: bridge`. Este error fue corregido posteriormente en el fichero.

**Problema 3 — `nginx/nginx.conf` vacío (bloqueante)**
nginx monta el fichero como volumen. Con contenido vacío, nginx arranca con configuración inválida y el contenedor muere. Necesita al mínimo:

```nginx
events {}
http {
    server {
        listen 80;
        location / {
            proxy_pass http://webapp:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

**Problema 4 — `db/init.sql` vacío (no bloqueante)**
PostgreSQL arranca igualmente, pero la tabla de datos sensibles no existirá. El flujo de ataque no tendrá nada que exfiltrar.

### Acción tomada

Se añadieron comentarios `TODO` en el `docker-compose.yaml` marcando exactamente qué fichero vacío corresponde a cada servicio y qué debe contener. El `STATE.md` se actualizó con `D1` en `DOING` y las sub-tareas anidadas para retomarlas al día siguiente.

---

## 6. Fase 5 — Segunda corrección: ¿Docker Hub o app propia?

### La duda

¿Tiene sentido usar imágenes prefabricadas de Docker Hub (DVWA para webapp, `traefik/whoami` para backend) en lugar de escribir código propio?

### Evaluación inicial

Se evaluaron las opciones:

| | Flask custom | DVWA + whoami |
|---|---|---|
| Esfuerzo | ~2 horas | 30 minutos |
| RCE demostrable | Sí (endpoint `/ping`) | Sí (Command Injection) |
| Credibilidad académica | Media | Alta (DVWA es referencia estándar) |
| Compatibilidad DB | PostgreSQL | DVWA requiere MariaDB |
| Coherencia de la app | Alta | Baja (servicios inconexos) |

### Decisión final: app propia

**Razón principal:** el Escenario B (Zero Trust) requiere proteger **flujos de tráfico legítimos**. Zero Trust funciona definiendo qué comunicaciones deben existir (`webapp → backend → db`) y bloqueando todo lo demás.

Con DVWA + whoami no hay flujos legítimos coherentes entre los servicios. Cuando en el Escenario B se diseñen las políticas ZT, no habrá una aplicación que justifique los permisos. La comparativa se debilita en su parte más importante.

Con una app propia de 3 capas, la historia del ataque es: *"el atacante comprometió el portal web corporativo, descubrió la API interna de RRHH mediante escaneo de red, y extrajo la tabla de empleados sin credenciales adicionales."* Ese relato es coherente, reproducible y defendible ante el tribunal.

Las ~2 horas de implementación protegen la solidez del experimento completo.

---

## 7. Estado final — Diseño consolidado

### Arquitectura definitiva

```
[Host :80]
    │
  nginx (net_dmz)
    │  reverse proxy
  webapp (net_dmz + net_interna)
    │  GET /empleados → HTTP interno
  backend (net_interna)
    │  psycopg2 SQL
  db — postgres (net_interna)
```

### Código fuente de la app (diseño final de la sesión)

#### `db/init.sql`

```sql
CREATE TABLE IF NOT EXISTS empleados (
    id       SERIAL PRIMARY KEY,
    nombre   VARCHAR(100),
    email    VARCHAR(100),
    rol      VARCHAR(50),
    salario  INTEGER
);

INSERT INTO empleados (nombre, email, rol, salario) VALUES
    ('Ana García',    'ana.garcia@empresa.local',    'Directora IT',  85000),
    ('Luis Martínez', 'luis.martinez@empresa.local', 'Desarrollador', 52000),
    ('Sara López',    'sara.lopez@empresa.local',    'RRHH',          48000);
```

#### `backend/app.py`

```python
import os, psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

def get_db():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        dbname="empresa_db",
        user="postgres",
        password=os.environ["DB_PASSWORD"]
    )

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

# PUNTO DÉBIL INTENCIONAL: sin autenticación — cualquier contenedor en net_interna puede llamar aquí
@app.route("/empleados")
def empleados():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT nombre, email, rol, salario FROM empleados;")
    rows = cur.fetchall()
    return jsonify([{"nombre": r[0], "email": r[1], "rol": r[2], "salario": r[3]} for r in rows])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

#### `backend/requirements.txt`

```
flask==3.0.3
psycopg2-binary==2.9.9
```

#### `webapp/app.py`

```python
import os, requests
from flask import Flask, request, render_template_string

app = Flask(__name__)
BACKEND_URL = os.environ.get("BACKEND_URL", "http://backend:5000")

TEMPLATE = """
<h1>Portal Empresa</h1>
<h2>Directorio de empleados</h2>
<ul>{% for e in empleados %}<li>{{ e.nombre }} — {{ e.rol }}</li>{% endfor %}</ul>
<hr>
<h2>Diagnóstico de red (admin)</h2>
<form method="get" action="/diagnostico">
    Host: <input name="host" value="{{ host }}">
    <button type="submit">Ping</button>
</form>
<pre>{{ resultado }}</pre>
"""

# FLUJO LEGÍTIMO: webapp → backend → db
@app.route("/")
def index():
    try:
        resp = requests.get(f"{BACKEND_URL}/empleados", timeout=3)
        empleados = resp.json()
    except Exception:
        empleados = []
    return render_template_string(TEMPLATE, empleados=empleados, host="", resultado="")

# VULNERABILIDAD RCE INTENCIONAL — vector: GET /diagnostico?host=8.8.8.8;cat /etc/passwd
@app.route("/diagnostico")
def diagnostico():
    host = request.args.get("host", "")
    resultado = os.popen(f"ping -c 1 {host}").read()   # os.popen sin sanitizar
    return render_template_string(TEMPLATE, empleados=[], host=host, resultado=resultado)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

#### `webapp/requirements.txt`

```
flask==3.0.3
requests==2.31.0
```

#### `webapp/Dockerfile` y `backend/Dockerfile` (idénticos)

```dockerfile
FROM python:3.11-slim
# curl y nmap instalados intencionalmente — realista (imágenes de producción suelen tenerlos)
# y necesario para el healthcheck y para que el atacante tenga herramientas tras RCE
RUN apt-get update && apt-get install -y curl nmap && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```

### Ficheros pendientes de escribir al reanudar

Consultar `admin/STATE.md` → columna `DOING` → tarea `D1` → sub-casillas sin marcar.

Orden recomendado:
1. `db/init.sql`
2. `backend/Dockerfile` + `backend/app.py` + `backend/requirements.txt`
3. `webapp/Dockerfile` + `webapp/app.py` + `webapp/requirements.txt`
4. `nginx/nginx.conf`
5. `docker compose up --build` y verificar que los 4 servicios arrancan

### Fuentes de referencia para la implementación

| Recurso | URL | Para qué |
|---|---|---|
| Flask Quickstart | [flask.palletsprojects.com](https://flask.palletsprojects.com/en/3.0.x/quickstart/) | Rutas, `request`, `render_template_string` |
| Docker Python guide | [docs.docker.com/language/python](https://docs.docker.com/language/python/containerize/) | Dockerfile para apps Python |
| psycopg2 docs | [psycopg.org/docs/usage.html](https://www.psycopg.org/docs/usage.html) | Conexión Python → PostgreSQL |
| OWASP Command Injection | [owasp.org/www-community/attacks/Command_Injection](https://owasp.org/www-community/attacks/Command_Injection) | Referencia académica de la vulnerabilidad RCE |
| CWE-78 | [cwe.mitre.org/data/definitions/78.html](https://cwe.mitre.org/data/definitions/78.html) | Identificador oficial para citar en la memoria |
| NIST SP 800-207 | [nvlpubs.nist.gov](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf) | Marco ZTA — sección comparativa perimetral vs ZT |
