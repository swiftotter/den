ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
ARG XDEBUG_TYPE="xdebug-stable"
USER root

RUN install-php-extensions ${XDEBUG_TYPE}

COPY debug/etc/*.ini /usr/local/etc/php/
COPY debug/etc/php.d/*.ini /usr/local/etc/php/conf.d/

USER www-data