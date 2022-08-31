ARG VARNISH_VERSION=7.1
FROM varnish:${VARNISH_VERSION}-alpine

USER root

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      256m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600 \
    -p feature=+esi_ignore_https -p feature=+esi_disable_xml_check

COPY default.vcl /etc/varnish/default.vcl.template
RUN apk add --no-cache gettext
RUN chown -R varnish:varnish /etc/varnish

ENV BACKEND_HOST    nginx
ENV BACKEND_PORT    80
ENV ACL_PURGE_HOST  0.0.0.0/0

USER varnish
EXPOSE 	80
CMD envsubst '${BACKEND_HOST} ${BACKEND_PORT} ${ACL_PURGE_HOST}' \
        < /etc/varnish/default.vcl.template > /etc/varnish/default.vcl \
    && varnishd -F -f $VCL_CONFIG -s malloc,$CACHE_SIZE $VARNISHD_PARAMS
