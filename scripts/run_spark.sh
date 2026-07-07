#!/bin/bash

set -e

set -a
source .env
set +a

spark-submit \
  --jars ~/jdbc/redshift-jdbc42-2.1.0.32.jar \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.13:4.0.2,org.opensearch.client:opensearch-spark-40_2.13:2.0.0 \
  streaming_job.py