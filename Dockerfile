FROM alpine:3.2

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# install common packages
RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.2/main/" > /etc/apk/repositories
RUN apk update && apk upgrade
RUN apk add --update-cache curl bash sudo \
	&& rm -rf /var/cache/apk/*

# install etcdctl
RUN curl -sSL -o /usr/local/bin/etcdctl http://sinacloud.net/hehe/etcd/etcdctl-v0.4.9 \
	&& chmod +x /usr/local/bin/etcdctl

ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config.yml
ENV SETTINGS_FLAVOR deis

# define the execution environment
WORKDIR /app
CMD ["/app/bin/boot"]
EXPOSE 5000

ADD build.sh /app/build.sh

RUN DOCKER_BUILD=true /app/build.sh

ADD . /app

ENV DEIS_RELEASE 1.13.0-single
