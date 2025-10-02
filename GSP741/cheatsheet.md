# GSP741 Confluent: Developing a Streaming Microservices Application

_last modified: 2020-11-06_

## Persist events

```bash
git clone https://github.com/confluentinc/examples
git clone https://github.com/confluentinc/kafka-streams-examples.git
cd ~/kafka-streams-examples/ # change directory and change to 5.5.1-post branch
git checkout 5.5.1-post
cd ~/examples/microservices-orders/exercises # change directory and change to 5.5.1-post branch
git checkout 5.5.1-post
rm OrdersService.java
wget https://raw.githubusercontent.com/chriskyfung/GSP741/main/OrdersService.java

# Copy your exercise client application to the project
cp ~/examples/microservices-orders/exercises/OrdersService.java ~/kafka-streams-examples/src/main/java/io/confluent/examples/streams/microservices/.

# Compile the project and resolve any compilation errors
mvn clean compile -DskipTests -f ~/kafka-streams-examples/pom.xml

# Run the test and validate that it passes
mvn compile -Dtest=io.confluent.examples.streams.microservices.OrdersServiceTest test -f ~/kafka-streams-examples/pom.xml

```

## Event-driven applications

```bash
cd ~/examples/microservices-orders/exercises
rm OrderDetailsService.java
wget https://raw.githubusercontent.com/chriskyfung/GSP741/main/OrderDetailsService.java
# Copy your exercise client application to the project
cp ~/examples/microservices-orders/exercises/OrderDetailsService.java ~/kafka-streams-examples/src/main/java/io/confluent/examples/streams/microservices/.

# Compile the project and resolve any compilation errors
mvn clean compile -DskipTests -f ~/kafka-streams-examples/pom.xml

# Run the test and validate that it passes
mvn compile -Dtest=io.confluent.examples.streams.microservices.OrderDetailsServiceTest test -f ~/kafka-streams-examples/pom.xml
```

## Enriching streams with joins

```bash
cd ~/examples/microservices-orders/exercises
rm EmailService.java
wget https://raw.githubusercontent.com/chriskyfung/GSP741/main/EmailService.java
# Copy your exercise client application to the project
cp ~/examples/microservices-orders/exercises/EmailService.java ~/kafka-streams-examples/src/main/java/io/confluent/examples/streams/microservices/.

# Compile the project and resolve any compilation errors
mvn clean compile -DskipTests -f ~/kafka-streams-examples/pom.xml

# Run the test and validate that it passes
mvn compile -Dtest=io.confluent.examples.streams.microservices.EmailServiceTest test -f ~/kafka-streams-examples/pom.xml

```

## Filtering and branching

```bash
cd ~/examples/microservices-orders/exercises
rm FraudService.java
wget https://raw.githubusercontent.com/chriskyfung/GSP741/main/FraudService.java
# Copy your exercise client application to the project
cp ~/examples/microservices-orders/exercises/FraudService.java ~/kafka-streams-examples/src/main/java/io/confluent/examples/streams/microservices/.

# Compile the project and resolve any compilation errors
mvn clean compile -DskipTests -f ~/kafka-streams-examples/pom.xml

# Run the test and validate that it passes
mvn compile -Dtest=io.confluent.examples.streams.microservices.FraudServiceTest test -f ~/kafka-streams-examples/pom.xml

```

## Stateful operations

```bash
cd ~/examples/microservices-orders/exercises
rm ValidationsAggregatorService.java
wget https://raw.githubusercontent.com/chriskyfung/GSP741/main/ValidationsAggregatorService.java
# Copy your exercise client application to the project
cp ~/examples/microservices-orders/exercises/ValidationsAggregatorService.java ~/kafka-streams-examples/src/main/java/io/confluent/examples/streams/microservices/.

# Compile the project and resolve any compilation errors
mvn clean compile -DskipTests -f ~/kafka-streams-examples/pom.xml

# Run the test and validate that it passes
mvn compile -Dtest=io.confluent.examples.streams.microservices.ValidationsAggregatorServiceTest test -f ~/kafka-streams-examples/pom.xml

```

## State stores

```bash
cd ~/examples/microservices-orders/exercises
rm InventoryService.java
wget https://raw.githubusercontent.com/chriskyfung/GSP741/main/InventoryService.java
# Copy your exercise client application to the project
cp ~/examples/microservices-orders/exercises/InventoryService.java ~/kafka-streams-examples/src/main/java/io/confluent/examples/streams/microservices/.

# Compile the project and resolve any compilation errors
mvn clean compile -DskipTests -f ~/kafka-streams-examples/pom.xml

# Run the test and validate that it passes
mvn compile -Dtest=io.confluent.examples.streams.microservices.InventoryServiceTest test -f ~/kafka-streams-examples/pom.xml

```

## Enrichment with ksqlDB

In the Cloud Console, from the Navigation menu, navigate to Compute Engine > VM Instances > SSH.

```bash
wget https://raw.githubusercontent.com/GoogleCloudPlatform/training-data-analyst/master/quests/confluent/bootstrap_vm.sh
chmod +x bootstrap_vm.sh
./bootstrap_vm.sh
exit

```

Restart SSH session

```bash
git clone https://github.com/confluentinc/examples
cd ~/examples/microservices-orders/exercises # change directory and change to 5.5.1-post branch
git checkout 5.5.1-post
sudo chmod -R 777 ~/examples/microservices-orders/
cd ~/examples/microservices-orders
export LD_LIBRARY_PATH='/usr/bin/openssl'
sudo sysctl -w vm.max_map_count=262144
docker-compose up -d --build
docker-compose ps

```

_This may take up to 5 minutes to start up._

```bash
docker-compose exec ksqldb-cli ksql http://ksqldb-server:8088

```

```sql
SHOW TOPICS;

```

```sql
CREATE STREAM my_orders WITH (kafka_topic='orders', value_format='AVRO');

--Next 3 steps are required to create a TABLE with keys of String type

--1. Create a stream
CREATE STREAM my_customers_with_wrong_format_key WITH (kafka_topic='customers', value_format='AVRO');

--2. Derive a new stream with the required key changes.
--The CAST statement converts the key to the required format.
--The PARTITION BY clause re-partitions the stream based on the new, converted key.
CREATE STREAM my_customers_with_proper_key WITH (KAFKA_TOPIC='my_customers-with-proper-key') AS SELECT CAST(id as BIGINT) as customerid, firstname, lastname, email, address, level FROM my_customers_with_wrong_format_key PARTITION BY CAST(id as BIGINT);

--3. Create the table on the properly keyed stream
CREATE TABLE my_customers_table (rowkey bigint KEY, customerid bigint, firstname varchar, lastname varchar, email varchar, address varchar, level varchar) WITH (KAFKA_TOPIC='my_customers-with-proper-key', VALUE_FORMAT='AVRO', KEY='customerid');

--Join customer information based on customer id
CREATE STREAM my_orders_cust1_joined AS SELECT my_customers_table.customerid AS customerid, firstname, lastname, state, product, quantity, price FROM my_orders LEFT JOIN my_customers_table ON my_orders.customerid = my_customers_table.customerid;

```

```sql
--Fraud alert if a customer submits more than 2 orders in a 30 second time window
CREATE TABLE MY_FRAUD_ORDER AS SELECT CUSTOMERID, LASTNAME, FIRSTNAME, COUNT(*) AS COUNTS FROM my_orders_cust1_joined WINDOW TUMBLING (SIZE 30 SECONDS) GROUP BY CUSTOMERID, LASTNAME, FIRSTNAME HAVING COUNT(*)>2;

```

```sql
-- Visualize frauds
SELECT * FROM MY_FRAUD_ORDER EMIT CHANGES;

```

