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
    # Solo loopback: el PEP mTLS (Nginx :443) es el unico punto de entrada desde backend_zone.
    app.run(host="127.0.0.1", port=5000)