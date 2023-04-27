FROM python:3.10-slim-bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    ca-certificates \
    curl \
    git

WORKDIR /opt
COPY sh sh/
COPY src src/
COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN python -m pip install install -r requirements.txt
# COPY mitmproxy-ca-cert.pem mitmproxy-ca-cert.pem
# Append to certifi.where location
RUN chmod +x sh/entrypoint.sh

CMD ["/opt/sh/entrypoint.sh"]
