ARG DEN_VERSION="main (development)"

FROM nginx:alpine
ARG DEN_VERSION

ENV DEN_VERSION=${DEN_VERSION}

ADD index.html /usr/share/nginx/html/index.html
ADD img/Dnsmasq_icon.svg /usr/share/nginx/html/img/Dnsmasq_icon.svg

RUN sed -ie "s/{{DEN_VERSION}}/${DEN_VERSION}/g" /usr/share/nginx/html/index.html