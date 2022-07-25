ARG PHP_VERSION
ARG NODE_VERSION

FROM golang:alpine AS mhs-builder
RUN go install github.com/mailhog/mhsendmail@latest

FROM node:${NODE_VERSION:-18}-alpine AS node
RUN npm install -g grunt-cli gulp

FROM php:${PHP_VERSION:-8.1}-fpm-alpine
USER root

ENV MAILHOG_HOST    mailhog
ENV MAILHOG_PORT    1025

# PHP Extension Installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Copy mhsendmail to PHP
COPY --from=mhs-builder /go/bin/mhsendmail /usr/local/bin/mhsendmail

# Copy Node to PHP
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/gulp/bin/gulp.js /usr/local/bin/gulp
RUN ln -s /usr/local/lib/node_modules/grunt-cli/bin/grunt /usr/local/bin/grunt

# Install PHP Extensions required by Magento OS, Adobe Commerce, and the UCT (pcntl)
RUN chmod +x /usr/local/bin/install-php-extensions && install-php-extensions \
    bcmath \
    gd \
    intl \
    imagick \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    sodium \
    xsl \
    zip

# Install Composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer1
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer2

# Install jq
RUN apk update && apk add jq bash patch pv vim mariadb-client

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
# Credit: davidalger
STOPSIGNAL SIGQUIT

USER www-data
EXPOSE 9000
CMD ["php-fpm"]