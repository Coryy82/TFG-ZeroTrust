FROM ubuntu:22.04

ARG WAZUH_VERSION=4.9.2

RUN apt-get update && apt-get install -y \
    curl gnupg python3 python3-pip netcat-openbsd docker.io \
    && pip3 install docker \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH \
    | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] \
    https://packages.wazuh.com/4.x/apt/ stable main" \
    > /etc/apt/sources.list.d/wazuh.list

RUN apt-get update && apt-get install -y wazuh-agent=${WAZUH_VERSION}-1 \
    && rm -rf /var/lib/apt/lists/*

COPY ossec.conf /var/ossec/etc/ossec.conf
COPY process-webapp.sh /var/ossec/scripts/process-webapp.sh
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh /var/ossec/scripts/process-webapp.sh \
    && chmod +x /entrypoint.sh /var/ossec/scripts/process-webapp.sh

ENTRYPOINT ["/entrypoint.sh"]