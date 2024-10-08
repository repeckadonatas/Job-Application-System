FROM python:3.11.4

ENV POETRY_VERSION=1.8.2
ENV POETRY_HOME=/usr/local
ENV POETRY_VIRTUALENVS_CREATE=false

RUN apt-get update && \
    apt-get install -y --no-install-recommends && \
    apt-get install -y postgresql-client

RUN mkdir -p /app/logs

COPY /sql/init.sql /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/init.sql

RUN curl -sSL https://install.python-poetry.org | python3 - --version=$POETRY_VERSION

WORKDIR /app

RUN python3 -m venv /venv

COPY ../../poetry.lock pyproject.toml ./

RUN poetry install --no-root

COPY ../.. .

EXPOSE 5432
EXPOSE 5433

CMD ["echo", "Hello, World", "\n", "This is the database backup app."]