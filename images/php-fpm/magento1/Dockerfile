ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

ADD https://files.magerun.net/n98-magerun.phar /usr/local/bin/n98-magerun
RUN chmod +x /usr/local/bin/n98-magerun \
    && ln -s /usr/local/bin/n98-magerun /usr/local/bin/n98-magerun \
    && ln -s /usr/local/bin/n98-magerun /usr/local/bin/magerun \
    && ln -s /usr/local/bin/n98-magerun /usr/local/bin/mr

ADD https://raw.githubusercontent.com/netz98/n98-magerun/master/res/autocompletion/bash/n98-magerun.phar.bash /etc/bash_completion.d/n98-magerun.phar

USER www-data
