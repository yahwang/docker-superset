FROM python:3.6-slim

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Superset version
ARG SUPERSET_VERSION=0.28.1

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Configure environment
ENV GUNICORN_BIND=0.0.0.0:8088 \
    GUNICORN_LIMIT_REQUEST_FIELD_SIZE=0 \
    GUNICORN_LIMIT_REQUEST_LINE=0 \
    GUNICORN_TIMEOUT=60 \
    GUNICORN_WORKERS=2
ENV GUNICORN_CMD_ARGS="-k gevent --workers ${GUNICORN_WORKERS} --timeout ${GUNICORN_TIMEOUT} --bind ${GUNICORN_BIND} --limit-request-line ${GUNICORN_LIMIT_REQUEST_LINE} --limit-request-field_size ${GUNICORN_LIMIT_REQUEST_FIELD_SIZE}"

ENV SUPERSET_VERSION ${SUPERSET_VERSION}
ENV SUPERSET_REPO apache/incubator-superset
ENV SUPERSET_HOME /home/superset
ENV PYTHONPATH /home/superset:$PYTHONPATH
    


# Create superset user & install dependencies
RUN mkdir ${SUPERSET_HOME} && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        procps \
        default-libmysqlclient-dev \
        freetds-bin \
        freetds-dev \
        libffi-dev \
        libldap2-dev \
        libpq-dev \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libssl1.0 && \
    apt-get clean && \
    curl https://raw.githubusercontent.com/${SUPERSET_REPO}/${SUPERSET_VERSION}/requirements.txt -o requirements.txt && \
    pip install -U pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt && \
    pip install --no-cache-dir psycopg2-binary==2.8.3 && \
    pip install --no-cache-dir gevent==1.4.0 && \     
    pip install --no-cache-dir superset==${SUPERSET_VERSION} && \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Configure Filesystem
COPY script/superset-init.sh /superset-init.sh

WORKDIR ${SUPERSET_HOME}

# Deploy application
EXPOSE 8088
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]
CMD ["gunicorn", "superset:app"]
