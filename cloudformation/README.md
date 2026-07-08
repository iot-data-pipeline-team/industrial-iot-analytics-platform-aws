# Industrial IoT Analytics Platform - Infrastructure as Code

## Overview

This repository contains the Infrastructure as Code (IaC) used to deploy the cloud infrastructure for the Industrial IoT Analytics Platform.

The project streams real-time industrial sensor data through Amazon MSK, processes it using Apache Spark on Amazon EMR, stores data in Amazon S3, Amazon Redshift Serverless, and Amazon OpenSearch Service, visualizes data with Amazon Managed Grafana, and monitors the platform using Amazon CloudWatch.

---

# Architecture

```
Machine Producer
        │
        ▼
Amazon MSK Serverless
        │
        ▼
Apache Spark Structured Streaming (Amazon EMR)
        │
        ├──────────────┐
        │              │
        ▼              ▼
Amazon S3      Amazon OpenSearch
        │              │
        ▼              ▼
Amazon Redshift   Amazon Managed Grafana
        │
        ▼
Amazon CloudWatch
```

---

# Repository Structure

```
cloudformation/

generated/
    industrial-iot-platform-infrastructure.yaml

opensearch.yaml

emr.yaml

grafana.yaml

cloudwatch.yaml

README.md
```

---

# Generated Template

The generated CloudFormation template was created using the AWS IaC Generator.

It contains the existing infrastructure discovered in the AWS account including:

- Amazon S3
- Amazon MSK Serverless
- Amazon Redshift Serverless
- IAM Roles
- IAM Policies
- VPC
- Subnets
- Security Groups

Resources that were not exported by the IaC Generator are managed manually.

---

# Manual Templates

## opensearch.yaml

Creates:

- Amazon OpenSearch Service
- Encryption
- Fine-grained access control
- VPC networking
- HTTPS
- EBS configuration
- Outputs

---

## emr.yaml

Creates:

- Amazon EMR Cluster
- Spark
- Livy
- Jupyter Enterprise Gateway
- Bootstrap Actions
- Managed Scaling
- Auto Termination
- Outputs

---

## grafana.yaml

Creates:

- Amazon Managed Grafana Workspace
- IAM Role
- CloudWatch permissions
- OpenSearch permissions
- Redshift permissions

---

## cloudwatch.yaml

Creates:

- SNS Topic
- Email Subscription
- CloudWatch Dashboard
- EMR Memory Alarm
- EMR Idle Alarm

---

# Deployment Order

Deploy resources in the following order:

1. generated/industrial-iot-platform-infrastructure.yaml

2. opensearch.yaml

3. emr.yaml

4. grafana.yaml

5. cloudwatch.yaml

---

# Example Deployment

Deploy OpenSearch

```bash
aws cloudformation deploy \
    --template-file cloudformation/opensearch.yaml \
    --stack-name opensearch-stack \
    --capabilities CAPABILITY_NAMED_IAM
```

Deploy EMR

```bash
aws cloudformation deploy \
    --template-file cloudformation/emr.yaml \
    --stack-name emr-stack \
    --capabilities CAPABILITY_NAMED_IAM
```

Deploy Grafana

```bash
aws cloudformation deploy \
    --template-file cloudformation/grafana.yaml \
    --stack-name grafana-stack \
    --capabilities CAPABILITY_NAMED_IAM
```

Deploy CloudWatch

```bash
aws cloudformation deploy \
    --template-file cloudformation/cloudwatch.yaml \
    --stack-name monitoring-stack \
    --capabilities CAPABILITY_NAMED_IAM
```

---

# Technologies

- Amazon MSK Serverless
- Amazon EMR
- Apache Spark Structured Streaming
- Amazon OpenSearch Service
- Amazon Redshift Serverless
- Amazon S3
- Amazon Managed Grafana
- Amazon CloudWatch
- AWS CloudFormation
- Python
- PySpark

---

# Author

Abdelrahman Malek

Computer Engineer

Industrial IoT Analytics Platform

AWS Data Engineering Portfolio Project