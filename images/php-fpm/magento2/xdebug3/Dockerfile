ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

RUN install-php-extensions xdebug-stable

COPY xdebug3/etc/*.ini /etc/
COPY xdebug3/etc/php.d/*.ini /etc/php.d/

USER www-data
