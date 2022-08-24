FROM golang:alpine as builder
ARG WEBPROC_VERSION=0.4.0
RUN apk --no-cache add --virtual build-dependencies \
    git \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go install github.com/jpillora/webproc@v${WEBPROC_VERSION}

FROM alpine:3

# fetch dnsmasq and webproc binary
RUN apk update \
	&& apk --no-cache add dnsmasq

COPY --from=builder /root/gocode/bin/webproc /usr/local/bin/

#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
#run!
ENTRYPOINT ["webproc","--configuration-file","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]