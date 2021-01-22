FROM java:openjdk-8-jre

ENV KAFKA_VERSION 2.6.1
ENV SCALA_VERSION 2.12
ENV ZOOKEEPER_VERSION 3.6.2

COPY apache-zookeeper-"$ZOOKEEPER_VERSION"-bin.tar.gz /tmp/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin.tgz
COPY kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

RUN tar xfz /tmp/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin.tgz -C /opt && \
	cp /opt/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin/conf/zoo_sample.cfg /opt/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin/conf/zoo.cfg && \
	rm /tmp/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin.tgz && \
	tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
	rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
	echo "\n"advertised.listeners=PLAINTEXT://127.0.0.1:9092 >> /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/config/server.properties

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

ENTRYPOINT /opt/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin/bin/zkServer.sh start & \
until /opt/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin/bin/zkServer.sh status ; do echo "Waiting for upcoming Zookeeper" ; sleep 5 ; done ; \
/opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/bin/kafka-server-start.sh /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/config/server.properties
