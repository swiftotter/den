ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

# Magerun
ADD https://files.magerun.net/n98-magerun2.phar /usr/local/bin/n98-magerun2
RUN chmod +rx /usr/local/bin/n98-magerun2 \
    && ln -s /usr/local/bin/n98-magerun2 /usr/local/bin/n98-magerun \
    && ln -s /usr/local/bin/n98-magerun2 /usr/local/bin/magerun2 \
    && ln -s /usr/local/bin/n98-magerun2 /usr/local/bin/magerun \
    && ln -s /usr/local/bin/n98-magerun2 /usr/local/bin/mr

# Magerun Auto-complete
ADD https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash /etc/bash_completion.d/n98-magerun2.phar
RUN chmod +r /etc/bash_completion.d/n98-magerun2.phar

# Mage2 TV Cache
RUN mkdir /home/www-data/mage-cache-clean \
    && cd /home/www-data/mage-cache-clean \
    && composer2 require mage2tv/magento-cache-clean \
    && ln -s /home/www-data/mage-cache-clean/vendor/bin/cache-clean.js /usr/local/bin/cache-clean.js \
    && ln -s /home/www-data/mage-cache-clean/vendor/bin/cache-clean.js /usr/local/bin/cache-clean \
    && chmod +rx -R /home/www-data/mage-cache-clean

USER www-data