FROM nginx:alpine

ADD den_entrypoint /den_entrypoint
ADD index.html /usr/share/nginx/html/index.html
ADD img/Dnsmasq_icon.svg /usr/share/nginx/html/img/Dnsmasq_icon.svg

ENTRYPOINT [ "/den_entrypoint" ]
