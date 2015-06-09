FROM mongo:2.6.4

RUN apt-get update && apt-get install -y wget

RUN mkdir -p /data/lucid_prod /data/local /logs /mongodb

EXPOSE 27017 28017

ADD mongo.conf /mongo.conf
ADD rs-initiate.sh /rs-initiate.sh
RUN /rs-initiate.sh

CMD ["mongod", "-f", "/mongo.conf"]
