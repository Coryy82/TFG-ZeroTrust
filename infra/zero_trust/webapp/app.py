import os
from functools import wraps

import requests
from flask import (
    Flask,
    redirect,
    render_template,
    render_template_string,
    request,
    send_from_directory,
    session,
    url_for,
)

app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET", "empresa-portal-dev-secret")

BACKEND_URL = os.environ.get("BACKEND_URL", "http://backend:5000")
PORTAL_VERSION = "Empresa-Portal/1.4.2"

# PUNTO DEBIL INTENCIONAL: credenciales del panel admin hardcodeadas.
# El atacante las recupera desde /backup.txt (CWE-200 Information Exposure).
ADMIN_USER = "admin"
ADMIN_PASSWORD = "Empresa2026!"


@app.after_request
def add_fingerprint_header(response):
    # PUNTO DEBIL INTENCIONAL: divulga la version del software, util para fingerprint.
    response.headers["X-Powered-By"] = PORTAL_VERSION
    return response


def login_required(view):
    @wraps(view)
    def wrapper(*args, **kwargs):
        if not session.get("authenticated"):
            return redirect(url_for("admin_login"))
        return view(*args, **kwargs)
    return wrapper


@app.route("/")
def portal():
    try:
        resp = requests.get(
            os.environ["BACKEND_URL"],                      # https://backend:443/empleados
            cert=("/certs/client.crt", "/certs/client.key"),  # presenta identidad
            verify="/certs/ca.crt",                          # valida al servidor
            timeout=3,
        )
        empleados = resp.json()  
    except Exception:
        empleados = []
    return render_template("portal.html", empleados=empleados)


# Recon assets servidos como ficheros planos desde static/.
# Aparentan ser ficheros olvidados en el webroot, no rutas Flask.
@app.route("/robots.txt")
def robots():
    return send_from_directory("static", "robots.txt", mimetype="text/plain")


@app.route("/backup.txt")
def backup():
    # PUNTO DEBIL INTENCIONAL: backup del sysadmin con credenciales accesible publicamente.
    return send_from_directory("static", "backup.txt", mimetype="text/plain")


@app.route("/admin", methods=["GET"])
def admin_index():
    if session.get("authenticated"):
        return redirect(url_for("admin_dashboard"))
    return redirect(url_for("admin_login"))


@app.route("/admin/login", methods=["GET", "POST"])
def admin_login():
    if request.method == "GET":
        if session.get("authenticated"):
            return redirect(url_for("admin_dashboard"))
        return render_template("login.html", error=None)

    username = request.form.get("username", "")
    password = request.form.get("password", "")

    # PUNTO DEBIL INTENCIONAL: mensajes de error diferenciados (CWE-204 user enumeration).
    if username != ADMIN_USER:
        return render_template("login.html", error="Usuario no encontrado.", username=username)
    if password != ADMIN_PASSWORD:
        return render_template("login.html", error="Contrasena incorrecta.", username=username)

    session["authenticated"] = True
    session["usuario"] = username
    return redirect(url_for("admin_dashboard"))


@app.route("/admin/logout")
def admin_logout():
    session.clear()
    return redirect(url_for("portal"))


@app.route("/admin/dashboard")
@login_required
def admin_dashboard():
    return render_template("dashboard.html", usuario=session.get("usuario", "admin"))


# VULNERABILIDAD SSTI INTENCIONAL (CWE-1336 / CWE-94)
# El parametro `host` se concatena en una plantilla y se renderiza con
# render_template_string. Cualquier expresion Jinja2 inyectada se evalua
# en el contexto del proceso Flask, lo que permite RCE indirecta.
#
# Vector tipo HTB Academy:
#   GET /admin/diagnostico?host={{ self.__init__.__globals__.__builtins__.__import__('os').popen('id').read() }}
@app.route("/admin/diagnostico")
@login_required
def admin_diagnostico():
    host = request.args.get("host", "")
    resultado = None
    if host:
        plantilla = (
            "Resolviendo " + host + "...\n"
            "PING " + host + " (auto): salida simulada del comando de diagnostico.\n"
            "--- " + host + " ping statistics ---\n"
            "1 packets transmitted, 1 received, 0% packet loss"
        )
        resultado = render_template_string(plantilla)
    return render_template("diagnostico.html", host=host, resultado=resultado)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
