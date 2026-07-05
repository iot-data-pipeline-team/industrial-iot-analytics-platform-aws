# Amazon OpenSearch Configuration

## Purpose

Amazon OpenSearch is used as the search and analytics engine for the **Silver Layer** of the Industrial IoT Analytics Platform.

Spark writes enriched IoT events to OpenSearch, where they are visualized through Grafana dashboards.

---

# Domain Information

Domain Name

```
iot-platform-os-domain
```

Engine

```
OpenSearch 3.1
```

Deployment Type

```
Development and Testing
```

Region

```
us-east-1
```

---

# Networking

Network

```
VPC
```

VPC

```
vpc-0271ce060c544cf8c
```

Subnets

```
subnet-025d8d4db494fb48f
subnet-0852aec05d4035377
subnet-0a6c17286e34d1e36
```

Security Group

```
sg-028b251e8448a6a4f
```

Required inbound access

| Source | Port |
|---------|------|
| EMR Security Group | 443 |

---

# Cluster Configuration

Data Nodes

```
1
```

Instance Type

```
t3.small.search
```

Dedicated Master

```
Disabled
```

Multi-AZ

```
Disabled
```

Standby

```
Disabled
```

Auto-Tune

```
Enabled
```

---

# Storage

EBS

```
Enabled
```

Volume Type

```
gp3
```

Volume Size

```
10 GiB
```

---

# Security

Encryption at Rest

```
Enabled
```

Node-to-Node Encryption

```
Enabled
```

HTTPS

```
Enabled
```

Fine-Grained Access Control

```
Disabled
```

IAM Authentication

```
Enabled
```

Access Policy

```
Allow access only from resources inside the VPC.
```

---

# Endpoint

Save after domain creation.

Example

```
https://xxxxxxxx.us-east-1.es.amazonaws.com
```

Update

```
.env
```

with

```
OPENSEARCH_HOST=<endpoint>
```

---

# Spark Configuration

Spark writes **Silver Layer** events into

```
machine-events
```

Future worker stream

```
worker-events
```

Connector

```
org.opensearch.spark.sql
```

---

# Expected Indices

```
machine-events

worker-events
```

Verify

```bash
curl -X GET \
"https://<endpoint>/_cat/indices?v"
```

---

# Expected Mapping

Important fields

```
timestamp

machine_id

temperature

rpm

vibration

power_consumption

is_fault

health_score

temperature_status

vibration_status

fault_flag

event_date

event_hour
```

---

# Grafana

Datasource

```
OpenSearch
```

Index

```
machine-events
```

Time Field

```
timestamp
```

---

# Verification

Verify OpenSearch is reachable

```bash
curl https://<endpoint>
```

Verify indices

```bash
curl https://<endpoint>/_cat/indices?v
```

Verify documents

```bash
curl https://<endpoint>/machine-events/_search?pretty
```

---

# Common Issues

## Connection Refused

Check

- Security Groups
- VPC
- Endpoint

---

## Authentication Failure

Check

- IAM Role
- Access Policy

---

## No Documents

Check

- Spark Streaming
- OpenSearch Sink
- Index Name

---

## Grafana Shows No Data

Check

- Index Pattern
- Time Field
- Time Range
- Data Source Configuration

---

# Cost Optimization

Current configuration is intended only for

```
Development and Testing
```

To reduce AWS costs

- Delete the domain after finishing development.
- Recreate it using this document.
- Spark automatically recreates indices when writing data.

---

# Recovery Checklist

- [ ] Create OpenSearch Domain
- [ ] Enable HTTPS
- [ ] Enable Encryption at Rest
- [ ] Enable Node-to-Node Encryption
- [ ] Configure VPC
- [ ] Configure Security Group
- [ ] Save Endpoint
- [ ] Update `.env`
- [ ] Verify Connectivity
- [ ] Run Spark
- [ ] Verify Indices
- [ ] Verify Documents
- [ ] Connect Grafana

---

# Current Status

- ✅ OpenSearch domain successfully deployed.
- ✅ Spark integration tested.
- ✅ Grafana datasource configured.
- ✅ Ready to receive Silver Layer documents from Spark after the Kafka migration is completed.