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

RUN apk update --no-cache \
  && PACKAGES="ghostscript imagemagick gcc mariadb-client fish icu-libs libstdc++" \
  && VERS=$(cat /etc/*-release | grep -i '^[0-9.]\+$') \
  && COMPARISON=$(apk version -t "$VERS" "3.9") \
  && if [ "$COMPARISON" = ">" ] || [ "$COMPARISON" = ">" ]; then PACKAGES="${PACKAGES} x265-libs"; fi \
  && COMPARISON=$(apk version -t "$VERS" "3.10") \
  && if [ "$COMPARISON" = ">" ] || [ "$COMPARISON" = ">" ]; then PACKAGES="${PACKAGES} libheif libde265"; fi \
  && COMPARISON=$(apk version -t "$VERS" "3.16") \
  && if [ "$COMPARISON" = "=" ] || [ "$COMPARISON" = ">" ]; then PACKAGES="${PACKAGES} libjxl"; fi \
  && echo "Packages: $PACKAGES" \
  && echo "Removing packages" \
  && apk del --no-cache $PACKAGES \
  && echo "Installing packages" \
  && apk add --no-cache $PACKAGES

USER www-data
