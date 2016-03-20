FROM alpine:3.2

# install common packages
RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.2/main/" > /etc/apk/repositories
RUN apk add --update-cache curl bash sudo && rm -rf /var/cache/apk/*
RUN apk update && \
		apk upgrade && \
		apk add --update-cache docker-registry

# install etcdctl
RUN curl -sSL -o /usr/local/bin/etcdctl http://sinacloud.net/hehe/etcd/etcdctl-v0.4.9 \
	&& chmod +x /usr/local/bin/etcdctl

# install confd
# RUN curl -sSL -o /usr/local/bin/confd http://sinacloud.net/hehe/confd/confd-0.11.0-linux-amd64 \
#	&& chmod +x /usr/local/bin/confd

ADD . /app

# define the execution environment
ENV DEIS_RELEASE 1.13.0-single
WORKDIR /app
CMD ["/app/bin/boot"]
EXPOSE 5000
