FROM python:3.11-slim
# curl y nmap instalados intencionalmente — realista (imágenes de producción suelen tenerlos)
# y necesario para el healthcheck y para que el atacante tenga herramientas tras RCE
RUN apt-get update && apt-get install -y curl nmap nginx && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["sh", "-c", "python app.py & nginx -g 'daemon off;'"]