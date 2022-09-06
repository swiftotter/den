ARG PHP_VERSION
ARG NODE_VERSION

FROM node:${NODE_VERSION:-18}-alpine AS node
RUN npm install -g grunt-cli gulp

ARG ENV_SOURCE_IMAGE
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION:-8.1}
USER root

# Copy Node to PHP
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/gulp/bin/gulp.js /usr/local/bin/gulp
RUN ln -s /usr/local/lib/node_modules/grunt-cli/bin/grunt /usr/local/bin/grunt

USER www-data