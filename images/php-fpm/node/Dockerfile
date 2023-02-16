ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION
ARG NODE_VERSION

FROM node:${NODE_VERSION}-alpine AS node
RUN npm install -g grunt-cli gulp

FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

# Copy Node to PHP
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Copy Yarn
COPY --from=node /opt /opt

# Alpine < 3.16 doesn't have libjxl, so only include libjxl if using alpine >= 3.16
RUN PACKAGES="ghostscript imagemagick gcc x265-libs libheif mariadb-client fish icu-libs libde265 libstdc++" \
    && VERS=$(cat /etc/*-release | grep -i '^[0-9.]\+$') \
    && COMPARISON=$(apk version -t "$VERS" "3.16") \
    && ( [[ "$COMPARISON" = ">" || "$COMPARISON" = "=" ]] && PACKAGES="${PACKAGES} libjxl" ) \
    ; apk del $PACKAGES && apk add --update --no-cache $PACKAGES

USER www-data
