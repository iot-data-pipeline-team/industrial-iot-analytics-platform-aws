# Industrial IoT Analytics Platform - Verification Commands

This document contains common commands to verify that each component of the AWS platform is working correctly.

---

# Load Project Environment

Run this in every new SSH terminal before using the commands below.

```bash
source scripts/load_env.sh
```

---

# OpenSearch

## Count documents in the Machine Events index

Verifies that Spark is continuously writing machine events into Amazon OpenSearch.

```bash
curl -k -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/machine-events/_count?pretty"
```

---

## Count documents in the Worker Events index

Verifies that Spark is writing worker events into Amazon OpenSearch.

```bash
curl -k -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/worker-events/_count?pretty"
```

---

## Count documents in the Machine Aggregates index

Verifies that the Gold aggregation pipeline is writing machine KPIs.

```bash
curl -k -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/machine-aggregates/_count?pretty"
```

---

## Count documents in the Worker Safety index

Verifies that worker safety analytics are reaching OpenSearch.

```bash
curl -k -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/worker-safety/_count?pretty"
```

---

## List all OpenSearch indices

Displays every index along with its document count and health status.

```bash
curl -k -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/_cat/indices?v"
```

---

# Amazon S3

## Count Bronze Machine files

Verifies that Spark is continuously writing Machine Bronze Parquet files.

```bash
aws s3 ls s3://iot-platform-malek/bronze/machine_bronze_data/ \
--recursive | wc -l
```

---

## Count Bronze Worker files

Verifies that Spark is continuously writing Worker Bronze Parquet files.

```bash
aws s3 ls s3://iot-platform-malek/bronze/worker_bronze_data/ \
--recursive | wc -l
```

---

## Count Silver Machine files

```bash
aws s3 ls s3://iot-platform-malek/silver/machine_silver_data/ \
--recursive | wc -l
```

---

## Count Silver Worker files

```bash
aws s3 ls s3://iot-platform-malek/silver/worker_silver_data/ \
--recursive | wc -l
```

---

## Count Gold Machine Aggregate files

```bash
aws s3 ls s3://iot-platform-malek/gold/machine_gold_data/ \
--recursive | wc -l
```

---

## Check if Spark is producing new files

Run the same command every few seconds.

If the count keeps increasing, the streaming pipeline is healthy.

---

# Expected Healthy Pipeline

Machine Producer
        ↓
Amazon MSK
        ↓
Spark Structured Streaming
        ↓
Bronze → Silver → Gold
        ↓
Amazon S3
        ↓
Amazon OpenSearch
        ↓
Amazon Managed Grafana