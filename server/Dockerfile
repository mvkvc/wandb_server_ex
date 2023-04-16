FROM python:3.10-slim-bullseye

WORKDIR /opt

COPY sh sh/
COPY src src/
COPY requirements.txt .

RUN pip install -r requirements.txt
RUN chmod +x sh/entrypoint.sh

CMD ["/opt/sh/entrypoint.sh"]
