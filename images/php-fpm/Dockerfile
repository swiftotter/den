ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION

FROM golang:alpine AS mhs-builder
RUN go install github.com/mailhog/mhsendmail@latest

FROM ${ENV_SOURCE_IMAGE:-php}:${PHP_VERSION}-fpm-alpine
USER root
ARG PHP_VERSION

ENV MAILHOG_HOST    mailhog
ENV MAILHOG_PORT    1025

# PHP Extension Installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Copy mhsendmail to PHP
COPY --from=mhs-builder /go/bin/mhsendmail /usr/local/bin/mhsendmail

# Install PHP Extensions required by Magento OS, Adobe Commerce, and the UCT (pcntl)
RUN chmod +x /usr/local/bin/install-php-extensions && install-php-extensions \
    apcu \
    amqp \
    bcmath \
    calendar \
    exif \
    gd \
    intl \
    imagick \
    imap \
    mysqli \
    pcntl \
    pdo_mysql \
    redis \
    soap \
    sockets \
    sodium \
    xsl \
    zip

# Install helpful utilities
RUN apk --no-cache add \
    jq \
    bash \
    patch \
    pv \
    procps \
    nano \
    vim \
    mariadb-client \
    sudo \
    busybox-suid \
    gettext \
    ca-certificates \
    shadow \
    git \
    rsync \
    bash-completion \
    zsh \
    git-zsh-completion \
    fish \
    pwgen \
    openssh \
    make

# Add Cron
RUN apk --no-cache add busybox-openrc || apk --no-cache add busybox-initscripts

# Bring in the files
COPY docker-entrypoint /usr/local/bin/
COPY etc/profile.d/*.sh /etc/profile.d/
COPY etc/*.ini /usr/local/etc/php/
COPY etc/php.d/*.ini /usr/local/etc/php/conf.d/
COPY etc/php.d/05-additions.ini.template /usr/local/etc/php/conf.d/

# Install Composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer1
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer2lts
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer2

# If PHP < 8.2
RUN if [[ $(printf "8.2\n${PHP_VERSION}" | sort -g |head -n1) != "8.2" ]]; \
    then install-php-extensions mcrypt; fi

# If PHP < 7.2
RUN if [[ $(printf "7.2\n${PHP_VERSION}" | sort -g | head -n1) != "7.2" ]]; \
    then mv /usr/bin/composer2lts /usr/bin/composer2; fi

# If PHP >= 7.1
RUN if [[ $(printf "7.1\n${PHP_VERSION}" | sort -g | head -n1) == "7.1" ]]; \
    then apk --no-cache add mariadb-connector-c; fi

# If PHP >= 7.2
RUN if [[ $(printf "7.2\n${PHP_VERSION}" | sort -g | head -n1) == "7.2" ]]; \
    then apk --no-cache add composer-zsh-completion; fi

# Enable command completion in Zsh
RUN mkdir -p /etc/zsh/zshrc.d  \
    && echo "autoload -U compinit; compinit" > /etc/zsh/zshrc.d/completions.zsh \
    && ln -s /usr/bin/fish /bin/fish

# Install Oh My Zsh including the following Plugins: git, composer and n98-magerun
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -i 's/plugins=(git)/plugins=(git composer n98-magerun)/g' /root/.zshrc

# Configure www-data user as primary php-fpm user for better local dev experience
RUN groupmod -g 1000 www-data && usermod -u 1000 www-data \
    && chmod 0755 ~www-data \
    && mkdir -p /var/www/html \
    && chown www-data:www-data /var/www/html \
    && echo "www-data ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
# Credit: davidalger
STOPSIGNAL SIGQUIT

ENTRYPOINT ["docker-entrypoint"]
WORKDIR /var/www/html
USER www-data
EXPOSE 9000
CMD ["php-fpm"]
