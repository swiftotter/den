ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
ARG XDEBUG_TYPE="xdebug-stable"
ARG PHP_VERSION
USER root

RUN install-php-extensions ${XDEBUG_TYPE}

COPY xdebug3/etc/*.ini /usr/local/etc/php/
COPY xdebug3/etc/php.d/*.ini /usr/local/etc/php/conf.d/

RUN if [[ $(printf "8.0\n${PHP_VERSION}" | sort -h | head -n1) == "8.0" ]]; \
    then mv /etc/php.d/15-xdebug3.2.ini.template /etc/php.d/15-xdebug.ini; \
    else mv /etc/php.d/15-xdebug3.ini.template /etc/php.d/15-xdebug.ini; fi

USER www-data
