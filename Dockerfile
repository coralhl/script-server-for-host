FROM python:3.11-alpine

ARG VERSION=1.17.1
ARG UID=1000
ARG GID=1000
ENV UID=${UID}
ENV GID=${GID}

LABEL build_version="Script-server for host version:- ${VERSION}"
LABEL maintainer="coral@xciii.ru"

RUN apk add --update curl bash && \
    rm -rf /var/cache/apk/*

RUN addgroup -g $GID runner \
    && adduser -u $UID -G runner -s /bin/sh -D runner

COPY --chown=runner:runner app /tmp

RUN mkdir /app && \
    chown runner:runner /app && \
    wget -O /app/tmp.zip https://github.com/bugy/script-server/releases/download/${VERSION}/script-server.zip && \
    unzip /app/tmp.zip -d /app && \
    rm /app/tmp.zip

WORKDIR /app
RUN pip install -r requirements.txt

USER runner

VOLUME [ "/app/conf", "/app/scripts", "/pipes" ]
EXPOSE 5000

ENTRYPOINT ["/tmp/docker-run.sh"]
CMD [ "python3", "launcher.py" ]
