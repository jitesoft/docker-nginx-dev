FROM nginx:alpine
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>"

ENV FPM_CONTAINER="fpm" \
    FPM_PORT="9000" \
    SERVER_NAME="localhost" \
    SERVER_ROOT="/var/www/html" \
    MAX_BODY_SIZE="20M"

COPY ./conf.template /tmp
COPY ./startup.sh /startup

RUN apk add --no-cache openssl \
    && chmod +x /startup

EXPOSE 80 443

CMD ./startup