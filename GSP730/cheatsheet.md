# GSP730 Creating a Streaming Data Pipeline With Apache Kafka

_last modified: 2020-11-06_

### Configure the Kafka VM instance

```bash
export PROJECT_ID=$(gcloud config get-value project)
gsutil cp gs://cloud-training/gsp285/binary/cps-kafka-connector.jar .
sudo mkdir -p /opt/kafka/connectors
sudo mv ./cps-kafka-connector.jar /opt/kafka/connectors/
sudo chmod +x /opt/kafka/connectors/cps-kafka-connector.jar
cd /opt/kafka/config
sudo tee -a cps-sink-connector.properties <<EOF
name=CPSSinkConnector
connector.class=com.google.pubsub.kafka.sink.CloudPubSubSinkConnector
tasks.max=10
topics=to-pubsub
cps.topic=from-kafka
cps.project=$PROJECT_ID
EOF
sudo tee -a cps-source-connector.properties <<EOF
name=CPSSourceConnector
connector.class=com.google.pubsub.kafka.source.CloudPubSubSourceConnector
tasks.max=10
kafka.topic=from-pubsub
cps.subscription=to-kafka-sub
cps.project=$PROJECT_ID
EOF
kafka-topics.sh --create \
    --zookeeper localhost:2181 \
    --replication-factor 1 \
    --partitions 1 \
    --topic streams-plaintext-input
kafka-topics.sh --create \
    --zookeeper localhost:2181 \
    --replication-factor 1 \
    --partitions 1 \
    --topic streams-wordcount-output
echo -e "all streams lead to kafka\nhello kafka streams\njoin kafka summit" > /tmp/file-input.txt
cat /tmp/file-input.txt | kafka-console-producer.sh --broker-list localhost:9092 --topic streams-plaintext-input
```

## Process the input data with Kafka Streams

Create another SSH connection to the VM

```bash
kafka-run-class.sh org.apache.kafka.streams.examples.wordcount.WordCountDemo
```

## Inspect the output data

Go back to **SSH Window A**

```bash
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic streams-wordcount-output \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer
```