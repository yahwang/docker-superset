FROM python:3.6-slim

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Superset version
ARG SUPERSET_VERSION=0.28.1

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Configure environment
ENV SUPERSET_VERSION ${SUPERSET_VERSION}
ENV SUPERSET_REPO apache/incubator-superset
ENV SUPERSET_HOME /home/superset
ENV PYTHONPATH /home/superset:$PYTHONPATH
ENV FLASK_APP=superset:app

# Create superset user & install dependencies
RUN mkdir ${SUPERSET_HOME} && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        build-essential \
        libffi-dev \
        libldap2-dev \
        libpq-dev \
        libsasl2-dev \
        libxi-dev \
        default-libmysqlclient-dev \
        freetds-bin \
        freetds-dev \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libssl1.0

# Install extra useful tool for development
RUN apt-get install -y \
        less \
        redis-tools \
        curl \
        procps \
        vim && \
    apt-get clean

RUN curl https://raw.githubusercontent.com/${SUPERSET_REPO}/${SUPERSET_VERSION}/requirements.txt -o requirements.txt && \
    pip install -U pip setuptools wheel && \
    pip install -r requirements.txt && \
    rm requirements.txt && \
    pip install redis==3.2.1 && \
    pip install psycopg2-binary==2.8.3 && \
    pip install gevent==1.4.0 && \     
    pip install superset==${SUPERSET_VERSION} && \
    rm -rf \
        /var/lib/apt/lists/* \
        /root/.cache/pip/* \
        /tmp/* \
        /var/tmp/*

# Configure Filesystem
COPY script/docker-init.sh /superset-init.sh
COPY script/docker-entrypoint.sh /entrypoint.sh

WORKDIR ${SUPERSET_HOME}

# Deploy application
ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]

EXPOSE 8088
