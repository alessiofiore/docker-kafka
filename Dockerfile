# Kafka and Zookeeper

FROM java:openjdk-8-jre

ENV KAFKA_VERSION 1.1.0
ENV SCALA_VERSION 2.12
ENV ZOOKEEPER_VERSION 3.4.12

COPY zookeeper-"$ZOOKEEPER_VERSION".tar.gz /tmp/zookeeper-"$ZOOKEEPER_VERSION".tgz
COPY kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

RUN tar xfz /tmp/zookeeper-"$ZOOKEEPER_VERSION".tgz -C /opt && \
	cp /opt/zookeeper-"$ZOOKEEPER_VERSION"/conf/zoo_sample.cfg /opt/zookeeper-"$ZOOKEEPER_VERSION"/conf/zoo.cfg && \
	rm /tmp/zookeeper-"$ZOOKEEPER_VERSION".tgz && \	
	tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
	rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
	echo "\n"advertised.listeners=PLAINTEXT://127.0.0.1:9092 >> /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/config/server.properties
	
# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

ENTRYPOINT /opt/zookeeper-"$ZOOKEEPER_VERSION"/bin/zkServer.sh start & \
until /opt/zookeeper-"$ZOOKEEPER_VERSION"/bin/zkServer.sh status ; do echo "Waiting for upcoming Zookeeper" ; sleep 5 ; done ; \
/opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/bin/kafka-server-start.sh /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/config/server.properties

