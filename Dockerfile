FROM debian:buster-slim

RUN apt-get update && \ 
    apt-get install -y  git gcc make

RUN git clone https://github.com/RedisTimeSeries/RedisTimeSeries.git && \
    cd RedisTimeSeries && \
    git submodule init && \
    git submodule update && \
    cd src && \
    make all

FROM redis:5.0.5
RUN mkdir -p /usr/lib/redis/ && \
    mkdir -p /usr/lib/redis/modules && \
    mkdir -p /usr/lib/redis/config

COPY --from=0 /RedisTimeSeries/src/redistimeseries.so /usr/lib/redis/modules/
ADD redis.conf /usr/lib/redis/config/redis.conf

CMD ["redis-server" , "/usr/lib/redis/config/redis.conf"]