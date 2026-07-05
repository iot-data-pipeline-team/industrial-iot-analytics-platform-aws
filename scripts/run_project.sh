#!/bin/bash

set -e

############################################
# Load Environment Variables
############################################

set -a
source .env
set +a

echo "===================================="
echo "Industrial IoT Analytics Platform"
echo "AWS Cloud Version"
echo "===================================="

############################################
# Initialize OpenSearch
############################################

echo
echo "Initializing OpenSearch..."


chmod +x scripts/*.sh


./scripts/opensearch_init.sh

############################################
# Start Spark
############################################

echo
echo "Starting Spark Streaming..."

./scripts/run_spark.sh

echo
echo "===================================="
echo "Platform Started Successfully!"
echo "===================================="

echo
echo "Open two new terminals and run:"
echo
echo "  ./scripts/run_machine_producer.sh"
echo "  ./scripts/run_worker_producer.sh"
echo
echo "Then verify:"
echo "  • S3"
echo "  • OpenSearch"
echo "  • Grafana"