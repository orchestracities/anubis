FROM python:3.9-slim as base

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

FROM base AS python-deps

RUN pip install pipenv
RUN apt-get update && apt-get install -y --no-install-recommends gcc

COPY anubis-management-api/Pipfile .
COPY anubis-management-api/Pipfile.lock .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

FROM base AS runtime

COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

RUN useradd --create-home apiuser && usermod -aG sudo apiuser
WORKDIR /home/apiuser
COPY ./anubis-management-api ./anubis-management-api
RUN chown -R apiuser:apiuser /home/apiuser
USER apiuser

WORKDIR ./anubis-management-api/src

EXPOSE 8000

ENTRYPOINT ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000", "--log-level", "debug", "--access-log"]
