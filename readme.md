# Development container with alpine linux and NGINX for PHP-fpm

A container - built from the nginx:alpine container - which automatically generates certificates and have a nginx configuration set up for a FPM fast-cgi container.

## Observe

This container should not be used as a production container, it's strictly made to quickly set up a nginx container with a self signed tls cert and connect to a fpm container.

## Run

```
docker pull jitesoft/nginx-dev
docker run --name whatever -p 80:80 -p 443:443 -e FPM_CONTAINER=myfpmcontainer -e SERVER_ROOT=/var/www/html/public -e SERVER_NAME=localhost
```

## Env variables

`FPM_CONTAINER` name of the FPM container in the network.  
`FPM_PORT` port that the FPM container exposes (defaults to 9000).  
`SERVER_ROOT` the server root from which the nginx server should serve data.  
`SERVER_NAME` server name (localhost should do fine in a local environment)  
`MAX_BODY_SIZE` max request body size, defaults to 20M.  