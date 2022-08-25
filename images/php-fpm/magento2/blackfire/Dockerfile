ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

RUN install-php-extensions blackfire
    
# Install the Blackfire Client to provide access to the CLI tool
COPY --from=blackfire/blackfire:latest /usr/local/bin/blackfire /usr/local/bin/blackfire

COPY blackfire/etc/php.d/*.ini /usr/local/etc/php/conf.d/

USER www-data
