FROM python:3.7.6-alpine3.11

ARG USER_IDENT

RUN apk update && apk add bash binutils libgcc

RUN adduser --uid $USER_IDENT -s /bin/bash -D -g '' user
USER user

RUN pip install --user jinja2 pygments prompt-toolkit pyinstaller

ENV PATH $PATH:/home/user/.local/bin

RUN mkdir -p /home/user/app
WORKDIR /home/user/app