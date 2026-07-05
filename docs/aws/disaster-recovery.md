# Disaster Recovery Guide

**Project:** Industrial IoT Analytics Platform (AWS)

**Purpose**

This document describes how to rebuild the entire AWS infrastructure from scratch after deleting all cloud resources.

---

# Target Architecture

```
Machine Producer
Worker Producer

        │
        ▼

Amazon MSK Serverless

        │
        ▼

Spark Structured Streaming
(Amazon EMR)

        │
        ▼

Bronze
Silver
Gold

        │
        ├── Amazon S3
        ├── Amazon OpenSearch
        ├── Grafana
        └── (Future)
            Amazon RDS
            Amazon Redshift
```

---

# Step 1 — Create S3 Bucket

Bucket Name

```
iot-platform-malek
```

Region

```
us-east-1
```

Purpose

```
Bronze
Silver
Gold
```

Verify

```bash
aws s3 ls
```

---

# Step 2 — Create MSK Serverless

Cluster Name

```
industrial-iot-msk
```

Authentication

```
IAM
```

Networking

Use the same VPC as EMR.

Security Group

Allow TCP

```
9098
```

from the EMR Security Group.

Save

- Bootstrap Server
- Cluster ARN

---

# Step 3 — Create OpenSearch

Domain

```
iot-platform-os-domain
```

Version

```
OpenSearch 3.x
```

Deployment

```
Development and Testing
```

Nodes

```
1
```

Storage

```
10 GiB gp3
```

Network

```
VPC
```

Save

- Endpoint
- Security Group
- Domain ARN

---

# Step 4 — Create EMR

Version

```
EMR 7.x
```

Spark

```
Spark 4
```

Applications

- Spark

Attach

```
AmazonEMR-InstanceProfile-20260704T092750
```

Verify

```bash
java -version
```

---

# Step 5 — SSH into EMR

```bash
ssh -i key.pem hadoop@<EMR-Master-Public-IP>
```

---

# Step 6 — Clone Repository

```bash
git clone <repository-url>

cd industrial-iot-analytics-platform-aws
```

---

# Step 7 — Configure Environment

```bash
source scripts/msk_env.sh
```

Verify

```bash
java -version

echo $CLASSPATH
```

Expected

- Java 17
- MSK IAM Authentication JAR
- AWS SDK Bundle

---

# Step 8 — Kafka Client

Verify

```bash
cat ~/client.properties
```

Contents

```properties
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
```

---

# Step 9 — Verify MSK

```bash
./scripts/check_msk.sh
```

Expected

```
machine-events

worker-events
```

---

# Step 10 — Create Topics

If they do not exist

```bash
./kafka_2.13-3.9.1/bin/kafka-topics.sh \
--bootstrap-server <bootstrap-server> \
--command-config ~/client.properties \
--create \
--topic machine-events \
--partitions 1 \
--replication-factor 3
```

Repeat for

```
worker-events
```

---

# Step 11 — Producer Test

```bash
./kafka_2.13-3.9.1/bin/kafka-console-producer.sh \
--bootstrap-server <bootstrap-server> \
--producer.config ~/client.properties \
--topic machine-events
```

Example

```json
{"machine_id":"M001","temperature":25.5}
```

---

# Step 12 — Consumer Test

```bash
./kafka_2.13-3.9.1/bin/kafka-console-consumer.sh \
--bootstrap-server <bootstrap-server> \
--consumer.config ~/client.properties \
--topic machine-events \
--from-beginning
```

Expected

```json
{"machine_id":"M001","temperature":25.5}
```

---

# Step 13 — Run Spark

Start the streaming application.

Verify

Spark reads

```
machine-events
```

Spark writes

```
Bronze

↓

Silver

↓

Gold
```

---

# Step 14 — Verify S3

Check

```
bronze/

silver/

gold/
```

inside

```
iot-platform-malek
```

---

# Step 15 — Verify OpenSearch

Expected indices

```
machine-events

worker-events
```

---

# Step 16 — Verify Grafana

Datasource

```
OpenSearch
```

Index

```
machine-events
```

Verify dashboards load correctly.

---

# Recovery Checklist

## Infrastructure

- [ ] S3
- [ ] MSK
- [ ] OpenSearch
- [ ] EMR

## Networking

- [ ] Same VPC
- [ ] Same Subnets
- [ ] Security Groups configured
- [ ] Port 9098 open

## IAM

- [ ] EMR Instance Profile attached
- [ ] Kafka permissions
- [ ] S3 permissions

## Kafka

- [ ] Topics exist
- [ ] Producer works
- [ ] Consumer works

## Spark

- [ ] Streaming starts
- [ ] Reads Kafka
- [ ] Writes S3
- [ ] Writes OpenSearch

## Visualization

- [ ] Grafana datasource
- [ ] Dashboards working

---

# Common Issues

## Java 8

Symptoms

```
UnsupportedClassVersionError
```

Fix

```bash
source scripts/msk_env.sh
```

---

## IAM Callback Handler Missing

Symptoms

```
ClassNotFoundException
```

Fix

Load

- aws-msk-iam-auth
- aws-sdk-java-bundle

---

## Timeout

Symptoms

```
Timed out waiting for node assignment
```

Fix

Check

- Security Groups
- Port 9098
- Same VPC

---

## Access Denied

Symptoms

```
SaslAuthenticationException
```

Fix

Verify

- EMR IAM Role
- Kafka IAM permissions

---

# Estimated Recovery Time

| Task | Time |
|------|------:|
| Create S3 | 2 min |
| Create MSK | 10 min |
| Create OpenSearch | 15–20 min |
| Create EMR | 10–15 min |
| Clone Repository | 2 min |
| Configure Environment | 2 min |
| Verify Kafka | 5 min |
| Run Spark | 5 min |
| Validate Pipeline | 5 min |

**Total:** Approximately **45–60 minutes**.

---

# Project Status (Current)

- ✅ AWS migration from Kinesis to MSK Serverless completed.
- ✅ EMR successfully authenticates to MSK using IAM.
- ✅ Kafka topics created.
- ✅ Producer and consumer verified.
- ✅ Java 17 and IAM authentication environment documented.
- ⏳ Remaining work: update Spark to use Kafka as the source, restore Bronze → Silver → Gold processing, and validate writes to S3 and OpenSearch.