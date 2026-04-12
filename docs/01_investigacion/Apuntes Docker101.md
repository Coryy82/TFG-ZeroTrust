# Docker 101 — Apuntes de Estudio

---

## 1. Conceptos Fundamentales

### ¿Qué es un contenedor?

Un **contenedor** es una unidad de software que empaqueta el código fuente y todas sus dependencias en un entorno aislado y reproducible. Se puede ejecutar en cualquier máquina sin preocuparse por el sistema operativo del host.

> **Analogía:** Un contenedor es como una *fiambrera hermética* con todo lo que necesitas para comer: plato, cubiertos y comida. No importa dónde la abras, siempre tienes lo mismo.

**Diferencia clave con las Máquinas Virtuales (VM):**

| Característica | Contenedor | VM |
|---|---|---|
| Sistema operativo | Comparte el del host | Sistema completo propio |
| Peso | Ligero (MB) | Pesado (GB) |
| Arranque | Segundos | Minutos |
| Aislamiento | Proceso | Completo |

---

### ¿Qué es Docker?

**Docker** es la herramienta (motor) que gestiona el ciclo de vida de los contenedores: crearlos, ejecutarlos, detenerlos y eliminarlos. Usa un programa en segundo plano llamado **Docker Daemon**.

```
Dockerfile  ──build──>  Imagen  ──run──>  Contenedor
```

---

### Dockerfile, Imagen y Contenedor

| Concepto | Descripción |
|---|---|
| **Dockerfile** | Fichero de instrucciones para construir una imagen |
| **Imagen** | Plantilla inmutable creada desde el Dockerfile |
| **Contenedor** | Instancia en ejecución creada desde una imagen |

> ⚠️ **Importante:** Las imágenes son **inmutables**. Si quieres modificar una imagen, debes editar el Dockerfile y volver a construirla.

**Ejemplo de Dockerfile básico:**

```dockerfile
FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /code

COPY . /code/

RUN pip install -r requirements.txt

CMD ["python", "run.py"]
```

| Instrucción | Qué hace |
|---|---|
| `FROM` | Imagen base de Docker Hub |
| `ENV` | Define variable de entorno |
| `WORKDIR` | Establece el directorio de trabajo |
| `COPY` | Copia archivos del host al contenedor |
| `RUN` | Ejecuta un comando durante la construcción |
| `CMD` | Comando por defecto al iniciar el contenedor |

**Construir y ejecutar:**

```bash
# Construir imagen con etiqueta
docker build -t mi-app .

# Ejecutar contenedor en modo detach
docker run -d --name mi-contenedor mi-app

# Ver contenedores en ejecución
docker ps

# Ver todos los contenedores (incluidos detenidos)
docker ps -a

# Ver logs
docker logs mi-contenedor

# Detener y eliminar
docker stop mi-contenedor
docker rm mi-contenedor
```

---

## 2. Docker Hub

**Docker Hub** (`hub.docker.com`) es el repositorio público de imágenes predefinidas. Contiene imágenes oficiales de bases de datos, servidores web, lenguajes, etc.

```bash
# Ejemplos de imágenes disponibles:
# nginx:alpine, postgres:15, python:3.11, busybox, mongo
```

---

## 3. Redes Docker — Driver Bridge

El **driver bridge** es el tipo de red más habitual en Docker. Crea una red virtual interna que permite a los contenedores comunicarse entre sí, manteniendo el aislamiento respecto al exterior.

```
┌─────────────────────── HOST ────────────────────────┐
│                                                      │
│   ┌─────── Docker Daemon ──────┐                    │
│   │                            │                    │
│   │  ┌── Red: bridge (def.) ─┐ │                    │
│   │  │  172.17.0.0/16        │ │                    │
│   │  │  [contenedor A]       │ │                    │
│   │  │  [contenedor B]       │ │                    │
│   │  └───────────────────────┘ │                    │
│   │                            │                    │
│   │  ┌── Red: myapp-net ─────┐ │                    │
│   │  │  172.18.0.0/16        │ │                    │
│   │  │  [app1: 172.18.0.2]   │ │                    │
│   │  │  [app2: 172.18.0.3]   │ │                    │
│   │  └───────────────────────┘ │                    │
│   └────────────────────────────┘                    │
└──────────────────────────────────────────────────────┘
```

### 3.1 Red bridge por defecto vs. red bridge personalizada

Cuando instalas Docker se crean tres redes automáticamente: `bridge`, `host` y `none`. La red `bridge` es la red por defecto donde se conectan los contenedores si no se especifica otra.

| Característica | Bridge por defecto (`bridge`) | Bridge personalizada |
|---|---|---|
| Resolución DNS por nombre | ❌ No disponible | ✅ Automática |
| Comunicación entre contenedores | Solo por IP | Por IP **y** por nombre |
| Aislamiento | Compartida con todos | Aislada al grupo |
| Recomendada para producción | ❌ | ✅ |

> ⚠️ **Error común:** En la red bridge por defecto los contenedores **no pueden** comunicarse por nombre (solo por IP). Usa siempre redes personalizadas para poder usar `ping app1` en lugar de `ping 172.17.0.3`.

---

### 3.2 Redes bridge personalizadas

Al crear una red bridge personalizada, Docker incluye un **servidor DNS interno** que resuelve automáticamente los nombres de contenedor a su IP.

```bash
# Crear una red bridge personalizada
docker network create myapp-net

# Arrancar contenedores en esa red
docker run -d --name app1 --network myapp-net nginx:alpine
docker run -d --name app2 --network myapp-net busybox sleep 3600

# app2 puede alcanzar a app1 simplemente por nombre:
docker exec app2 ping app1
```

**Diagrama de comunicación interna:**

```
┌─────── myapp-net (bridge) ──────────────────────────┐
│                                                      │
│   [app1: 172.18.0.2]  <──── DNS: "app1" ────>       │
│   [app2: 172.18.0.3]  <──── DNS: "app2" ────>       │
│                                                      │
│   app2 → ping app1 → DNS resuelve 172.18.0.2 ✅     │
└──────────────────────────────────────────────────────┘
```

---

### 3.3 Aislamiento entre redes

Los contenedores en redes distintas **no pueden comunicarse entre sí** a menos que se conecten explícitamente. Esto es clave para la seguridad.

```
Red net1: [contenedor_A] ──┐
                            │ ← SIN comunicación entre sí ✅
Red net2: [contenedor_B] ──┘
```

Para probar:

```bash
# Desde contenedor_B en net2, intentar acceder a contenedor_A en net1:
docker exec contenedor_B ping contenedor_A
# → Error: no se puede resolver el nombre. ✅ Aislamiento funcionando.
```

---

## 4. Comandos de Gestión de Redes

```bash
# Listar redes disponibles
docker network ls

# Crear red bridge (tipo por defecto)
docker network create myapp-net

# Crear red especificando driver explícitamente
docker network create --driver bridge myapp-net

# Inspeccionar una red (ver contenedores conectados, IPs, etc.)
docker network inspect myapp-net

# Conectar un contenedor en ejecución a una red
docker network connect myapp-net mi-contenedor

# Desconectar un contenedor de una red
docker network disconnect myapp-net mi-contenedor

# Eliminar una red
docker network rm myapp-net

# Ver la red asignada a un contenedor
docker inspect mi-contenedor
```

> **Truco:** Un mismo contenedor puede estar conectado a **múltiples redes** simultáneamente usando `docker network connect`.

---

## 5. Publicación de Puertos (Port Binding)

Por defecto, los contenedores están aislados del host. Para acceder a un servicio dentro de un contenedor desde el exterior, debes **publicar el puerto** con el flag `-p`.

**Sintaxis:** `-p <puerto_host>:<puerto_contenedor>`

```bash
# Acceder al nginx del contenedor desde el host en el puerto 8080
docker run -d --name web -p 8080:80 nginx:alpine
```

**Cómo funciona (NAT):**

```
HOST (127.0.0.1:8080)
       │
       │  NAT (iptables)
       ▼
CONTENEDOR (172.17.0.2:80)
```

```bash
# Puedes mapear cualquier puerto del host al del contenedor:
docker run -d --name db -p 5432:5432 postgres:15
docker run -d --name db -p 9999:5432 postgres:15  # puerto distinto en el host
```

> ⚠️ **Regla importante:** El puerto de la **izquierda** es siempre del host; el de la **derecha**, del contenedor.

> ⚠️ **Buena práctica DevSecOps:** Expón al host **solo los puertos necesarios**. Si un contenedor solo habla con otros contenedores (ej. una base de datos), **no expongas su puerto**; comunícalo a través de la red interna.

---

## 6. Sintaxis YAML

YAML es el formato de texto plano que usa Docker Compose para definir servicios, redes, volúmenes y variables de entorno.

**Archivos válidos:**
- `docker-compose.yaml` / `docker-compose.yml`
- `compose.yaml` / `compose.yml`

**Reglas clave:**

```yaml
# Clave: valor
nombre: "mi-app"

# Lista (guión + espacio)
puertos:
  - "8080:80"
  - "443:443"

# Anidamiento por indentación (2 espacios)
servicios:
  web:
    imagen: nginx
```

### Estructura típica de un docker-compose.yaml

```yaml
docker-compose.yaml
  ├── version          # Versión del formato (opcional en versiones recientes)
  ├── services
  │     ├── servicio1
  │     │     ├── image / build
  │     │     ├── ports
  │     │     ├── environment
  │     │     ├── networks
  │     │     ├── depends_on
  │     │     └── volumes
  │     └── servicio2
  ├── networks
  │     └── red1
  └── volumes
        └── volumen1
```

---

## 7. Docker Compose

**Docker Compose** es la herramienta para definir y ejecutar aplicaciones **multi-contenedor** con un único fichero YAML.

### Ejemplo completo

```yaml
version: "3.8"

services:
  frontend:
    build:
      context: ./frontend
    ports:
      - "80:80"
    networks:
      - appnet
    depends_on:
      backend:
        condition: service_healthy

  backend:
    build:
      context: ./backend
    ports:
      - "8080:8080"
    networks:
      - appnet
    depends_on:
      - database
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/ping"]
      interval: 5s
      retries: 5

  database:
    image: postgres:15
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secreto
    networks:
      - appnet
    volumes:
      - db_data:/var/lib/postgresql/data
    # ⚠️ No se expone puerto al host: la BD solo es accesible internamente

networks:
  appnet:
    driver: bridge

volumes:
  db_data:
```

**Equivalencia CLI ↔ Compose:**

| Comando CLI | Equivalente en Compose |
|---|---|
| `docker network create appnet` | `networks: appnet:` |
| `docker run --network appnet --name web nginx` | `services: web: image: nginx` |
| `docker run -p 80:80` | `ports: - "80:80"` |
| `docker run -e VAR=valor` | `environment: VAR: valor` |

### Comandos principales de Compose

```bash
# Construir imágenes y levantar contenedores
docker compose up --build

# Levantar en segundo plano
docker compose up -d

# Detener y eliminar contenedores (conserva volúmenes y redes)
docker compose down

# Detener y eliminar TODO (incluyendo volúmenes)
docker compose down -v

# Ver logs de todos los servicios
docker compose logs -f

# Ver estado de los servicios
docker compose ps
```

### DNS en Docker Compose

Al usar `docker compose up`, Docker crea automáticamente una red bridge para el proyecto. **Cada servicio es accesible por su nombre** dentro de esa red, sin configuración adicional.

```
# En el backend, la cadena de conexión a la BD puede ser:
postgresql://admin:secreto@database:5432/mi_bd
#                           ^^^^^^^^
#                     Nombre del servicio = hostname DNS
```

### depends_on y orden de arranque

```yaml
frontend:
  depends_on:
    backend:
      condition: service_healthy  # Espera a que el healthcheck sea OK

backend:
  depends_on:
    - database  # Espera solo a que el contenedor esté iniciado
```

---

## 8. Docker Volumes

Los **volúmenes** permiten persistir datos más allá del ciclo de vida de un contenedor. Sin volúmenes, todos los datos se pierden cuando el contenedor se elimina.

> **Analogía:** Un volumen es como un **USB externo** conectado a tu ordenador: aunque lo apagues, los datos siguen ahí.

### Tipos de montaje

| Tipo | Sintaxis `-v` | Cuándo usarlo |
|---|---|---|
| **Named volume** | `-v nombre_vol:/ruta/contenedor` | Persistencia de datos (BD, logs) |
| **Bind mount** | `-v /ruta/host:/ruta/contenedor` | Desarrollo (sincronizar código) |

### Named Volume

```bash
# Docker gestiona dónde se almacena físicamente
docker run -d --name app   -v python_data:/app/logs   mi-imagen
```

> ⚠️ Si el volumen no existe, Docker lo crea automáticamente.

### Bind Mount

```bash
# Apunta directamente a un directorio del host
docker run -d --name app   -v /home/usuario/proyecto:/app   mi-imagen
```

> ℹ️ El bind mount **no crea un volumen** (`docker volume ls` no lo mostrará).

### Compartir volumen entre contenedores

```bash
# Dos contenedores comparten el mismo volumen
docker run -d --name logs1 -v datos_compartidos:/app/logs mi-imagen
docker run -d --name logs2 -v datos_compartidos:/app/logs mi-imagen
```

### Comandos de gestión de volúmenes

```bash
# Crear volumen
docker volume create mi-volumen

# Listar volúmenes
docker volume ls

# Inspeccionar volumen
docker volume inspect mi-volumen

# Eliminar volumen
docker volume rm mi-volumen

# Eliminar volúmenes no utilizados
# ⚠️ Un contenedor DETENIDO (no eliminado) sigue "usando" el volumen
docker volume prune -a
```

> ⚠️ **Error común:** `docker volume prune` no elimina un volumen si hay un contenedor (aunque esté detenido) que lo referencia. Debes eliminar el contenedor primero con `docker rm`.

---

## 9. Aplicaciones para el TFG

1. **Redes bridge personalizadas** → permiten resolver los contenedores por nombre de servicio (DNS automático), sin necesidad de gestionar IPs manualmente.
2. **Docker Hub** → fuente de imágenes oficiales predefinidas (BBDD, servidores web, lenguajes). Ejemplo: `postgres:15`, `nginx:alpine`.
3. **Dockerfile** → instala las dependencias de la aplicación dentro de la imagen. No es necesario tenerlas instaladas en el host.
   - Ejemplo: un script que usa una herramienta externa → el Dockerfile la instala y luego ejecuta el script.
4. **Imágenes inmutables** → cada vez que se modifica el Dockerfile hay que reconstruir la imagen (`docker build`).
5. **Docker Compose** → orquesta múltiples contenedores con un único fichero. Útil para levantar frontend + backend + BD en un solo `docker compose up`.
6. **Volúmenes** → imprescindibles para persistir datos de bases de datos entre reinicios.
7. **No exponer puertos innecesarios** → las bases de datos solo deben ser accesibles internamente a través de la red bridge, no desde el host.

---

## Referencia Rápida de Comandos

```bash
# ─── Imágenes ───────────────────────────────────────────────
docker build -t nombre:tag .        # Construir imagen
docker images                        # Listar imágenes
docker rmi nombre:tag                # Eliminar imagen

# ─── Contenedores ───────────────────────────────────────────
docker run -d --name c1 imagen       # Ejecutar en segundo plano
docker run -it imagen /bin/bash      # Ejecutar interactivo
docker ps / docker ps -a             # Listar contenedores
docker stop c1 && docker rm c1       # Detener y eliminar
docker logs c1                       # Ver logs
docker exec -it c1 /bin/bash         # Entrar al contenedor

# ─── Redes ──────────────────────────────────────────────────
docker network ls                    # Listar redes
docker network create mi-red         # Crear red bridge
docker network inspect mi-red        # Inspeccionar
docker network connect mi-red c1     # Conectar contenedor
docker network disconnect mi-red c1  # Desconectar
docker network rm mi-red             # Eliminar red

# ─── Volúmenes ──────────────────────────────────────────────
docker volume create vol1            # Crear volumen
docker volume ls                     # Listar
docker volume inspect vol1           # Inspeccionar
docker volume rm vol1                # Eliminar
docker volume prune -a               # Limpiar sin uso

# ─── Docker Compose ─────────────────────────────────────────
docker compose up --build            # Construir y levantar
docker compose up -d                 # En segundo plano
docker compose down                  # Detener y limpiar
docker compose down -v               # Limpiar también volúmenes
docker compose logs -f               # Seguir logs
docker compose ps                    # Estado de servicios
```
