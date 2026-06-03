FROM python:3.11-slim
# curl, nmap, tcpdump y postgresql-client: realismo post-RCE + reproducibilidad de captura KPI
RUN apt-get update && apt-get install -y \
    curl nmap tcpdump postgresql-client tzdata \
    && rm -rf /var/lib/apt/lists/*
ENV TZ=Europe/Madrid
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
COPY templates/ ./templates/
COPY static/ ./static/
CMD ["python", "app.py"]
