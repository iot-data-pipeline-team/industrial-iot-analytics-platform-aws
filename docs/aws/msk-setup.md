# Amazon MSK Serverless Setup Guide

**Project:** Industrial IoT Analytics Platform (AWS Migration)

**Purpose:** This document describes how to configure Amazon MSK Serverless and connect it to an Amazon EMR Spark cluster using IAM authentication.

---

# Architecture

```
Machine Producer
Worker Producer

        │
        ▼

Amazon MSK Serverless
(machine-events)
(worker-events)

        │
        ▼

Spark Structured Streaming (EMR)

        │
        ▼

Bronze
Silver
Gold

        │
        ├── Amazon S3
        ├── Amazon OpenSearch
        └── (Future) Amazon RDS / Redshift
```

---

# AWS Resources

## MSK Cluster

Cluster Name

```
industrial-iot-msk
```

Type

```
Serverless
```

Region

```
us-east-1
```

Authentication

```
IAM
```

Bootstrap Server

```
boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098
```

---

## EMR

Spark Version

```
Spark 4.0.2-amzn-0
```

Java

```
Amazon Corretto 17
```

Instance Profile

```
AmazonEMR-InstanceProfile-20260704T092750
```

---

# Networking

MSK and EMR must be deployed inside the same VPC.

Current VPC

```
vpc-0271ce060c544cf8c
```

MSK Security Group

```
sg-028b251e8448a6a4f
```

EMR Security Group

```
sg-054339d415bfcd11b
```

Required inbound rule on the MSK Security Group

| Type | Port | Source |
|------|------|--------|
| Custom TCP | 9098 | sg-054339d415bfcd11b |

Without this rule the Kafka client times out.

---

# Kafka CLI

Download

```bash
wget https://downloads.apache.org/kafka/3.9.1/kafka_2.13-3.9.1.tgz
```

Extract

```bash
tar -xzf kafka_2.13-3.9.1.tgz
```

---

# Java Requirement

The AWS IAM authentication library requires Java 17.

Check

```bash
java -version
```

Should return

```
openjdk version "17.x"
```

---

# MSK Environment

Run

```bash
source scripts/msk_env.sh
```

Equivalent to

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64

export PATH=$JAVA_HOME/bin:$PATH

export CLASSPATH=/usr/share/aws/aws-java-sdk-v2/aws-sdk-java-bundle-2.41.32.jar:/usr/lib/spark/jars/aws-msk-iam-auth-2.3.5.jar
```

Verify

```bash
java -version

echo $CLASSPATH
```

---

# Kafka Client Configuration

Create

```
~/client.properties
```

Contents

```properties
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
```

---

# Create Topics

Machine Events

```bash
./kafka_2.13-3.9.1/bin/kafka-topics.sh \
--bootstrap-server boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098 \
--command-config ~/client.properties \
--create \
--topic machine-events \
--partitions 1 \
--replication-factor 3
```

Worker Events

```bash
./kafka_2.13-3.9.1/bin/kafka-topics.sh \
--bootstrap-server boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098 \
--command-config ~/client.properties \
--create \
--topic worker-events \
--partitions 1 \
--replication-factor 3
```

---

# List Topics

```bash
./kafka_2.13-3.9.1/bin/kafka-topics.sh \
--bootstrap-server boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098 \
--command-config ~/client.properties \
--list
```

---

# Producer

```bash
./kafka_2.13-3.9.1/bin/kafka-console-producer.sh \
--bootstrap-server boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098 \
--producer.config ~/client.properties \
--topic machine-events
```

Example message

```json
{"machine_id":"M001","temperature":25.5}
```

---

# Consumer

```bash
./kafka_2.13-3.9.1/bin/kafka-console-consumer.sh \
--bootstrap-server boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098 \
--consumer.config ~/client.properties \
--topic machine-events \
--from-beginning
```

Expected output

```json
{"machine_id":"M001","temperature":25.5}
```

---

# Spark

Spark 4 already includes the Kafka connector.

No additional Kafka packages are required.

Use

```python
.format("kafka")
```

instead of

```python
.format("aws-kinesis")
```

---

# Troubleshooting

## Error

```
ClassNotFoundException:
IAMClientCallbackHandler
```

Cause

Java classpath missing

Solution

```
source scripts/msk_env.sh
```

---

## Error

```
UnsupportedClassVersionError
```

Cause

Running Java 8

Solution

Use Java 17

---

## Error

```
Timed out waiting for node assignment
```

Cause

Security Group missing port 9098

Solution

Allow EMR Security Group to access MSK Security Group on TCP 9098.

---

## Error

```
SaslAuthenticationException
Access denied
```

Cause

IAM permissions missing

Solution

Grant the EMR Instance Profile the required `kafka-cluster:*` permissions.

---

## Error

```
Number of partitions is below 1
```

Cause

Partitions not specified

Solution

```
--partitions 1
```

---

# Daily Startup

```bash
cd ~/industrial-iot-analytics-platform-aws

source scripts/msk_env.sh

./scripts/check_msk.sh
```

Start Spark

Run Producers

Verify data

Done.

---

# Current Status

- ✅ MSK Serverless configured
- ✅ IAM authentication working
- ✅ Java 17 configured
- ✅ Kafka CLI working
- ✅ Producer working
- ✅ Consumer working
- ✅ EMR connected successfully
- ⏳ Next step: Replace Kinesis source with Kafka in Spark and validate the full streaming pipeline.