ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
ARG XDEBUG_TYPE="xdebug-stable"
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

RUN install-php-extensions ${XDEBUG_TYPE}

COPY xdebug3/etc/*.ini /usr/local/etc/php/
COPY xdebug3/etc/php.d/*.ini /usr/local/etc/php/conf.d/

USER www-data
