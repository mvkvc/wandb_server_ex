FROM python:3.10-slim-bullseye

WORKDIR /opt

COPY sh/entrypoint.sh .
COPY src src/
COPY requirements.txt .

RUN pip install -r requirements.txt
RUN chmod +x entrypoint.sh

CMD ["/opt/entrypoint.sh"]
