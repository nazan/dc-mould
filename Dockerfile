#FROM python:3.7.6-alpine3.11

FROM composer:1.9.3

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ARG USER_IDENT

RUN apk update && apk add bash binutils libgcc

RUN adduser --uid $USER_IDENT -s /bin/bash -D -g '' user
USER user

RUN pip install --user jinja2 pygments prompt-toolkit

ENV PATH $PATH:/home/user/.local/bin

RUN mkdir -p /home/user/dist

RUN mkdir -p /home/user/app
WORKDIR /home/user/app