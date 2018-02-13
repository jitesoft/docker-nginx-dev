# !/usr/bin/sh

CERT_NAME=${SERVER_NAME}.crt
KEY_NAME=${SERVER_NAME}.key

SSL_PATH="/etc/ssl"
CERT_PATH="${SSL_PATH}/${CERT_NAME}"
KEY_PATH="${SSL_PATH}/${KEY_NAME}"

if [[ -e "${KEY_PATH}" ]]; then
    if [[ $(find "${KEY_PATH}" -mtime +360 -print) ]]; then
        echo "Found certificate, but the certificate was outdated."
        echo "Removing old certificate and key..."
        rm "${KEY_PATH}"
        rm "${CERT_PATH}"
    fi
fi

if [[ ! -e ${KEY_PATH} ]]; then
    echo "Generating new TLS certificate and key."
    if [[ ! -d "${SSL_PATH}" ]]; then
        echo "Creating directory for certificate."
        mkdir -p ${SSL_PATH}
    fi

    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${SERVER_NAME}" -keyout ${KEY_PATH} -out ${CERT_PATH}
    echo "Setting permissions for keys."
    chmod 640 ${KEY_PATH}
    chmod 644 ${CERT_PATH}
    echo "Certificate and key created successfully."

fi

export KEY_PATH=${KEY_PATH}
export CERT_PATH=${CERT_PATH}

envsubst '$FPM_PORT $FPM_CONTAINER $SERVER_NAME $SERVER_ROOT $MAX_BODY_SIZE $CERT_PATH $KEY_PATH' < /tmp/conf.template > /etc/nginx/conf.d/default.conf

unset KEY_PATH
unset CERT_PATH

echo "Awaiting FPM container..."
while ! nc -z ${FPM_CONTAINER} 9000; do sleep 5; done
echo "FPM container is up. Starting nginx."
nginx -g 'daemon off;'