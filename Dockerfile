FROM extvos/centos

MAINTAINER  "Mingcai SHEN <archsh@gmail.com>"

ENV REDIS_VERSION 3.0.3

RUN groupadd -r redis && useradd -r -g redis redis

RUN yum install -y ca-certificates \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
	&& chmod +x /usr/local/bin/gosu 

RUN cd /opt && curl http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz | tar zxv \
	&& yum groupinstall -y "Development tools" \
	&& make -C redis-${REDIS_VERSION} && make -C redis-${REDIS_VERSION} install \
	&& rm -rf redis-${REDIS_VERSION}\
	&& mkdir /data && chown redis:redis /data 

VOLUME /data
WORKDIR /data

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
CMD [ "redis-server" ]