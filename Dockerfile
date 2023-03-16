FROM alpine:3.17

ARG PUID=1000
ARG PGID=1000
ARG HOME="/backups"

RUN addgroup -g ${PGID} backups && \
    adduser -S -h ${HOME} -G backups -u ${PUID} backups

RUN apk update && \
    apk upgrade && \
    apk add -U --no-cache tzdata bash tar s3cmd postgresql-client \
                          gettext

RUN cp /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone

USER backups

WORKDIR /backups

COPY --chown=backups:backups ./backups.sh /backups/.
COPY --chown=backups:backups ./.s3cfg /backups/.s3cfg.sample

RUN chmod +x /backups/backups.sh

CMD bash -c /backups/backups.sh
