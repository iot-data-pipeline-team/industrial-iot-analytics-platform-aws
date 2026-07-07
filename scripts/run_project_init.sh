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

echo
echo "Step 1/4 - Installing dependencies..."
./scripts/setup.sh

echo
echo "Step 2/4 - Preparing EMR..."
./scripts/bootstrap_emr.sh

echo
echo "Step 3/4 - Initializing OpenSearch..."
./scripts/opensearch_init.sh


echo
echo "Step 3.5/4 - Initializing Redshift..."
./scripts/redshift_init.sh


echo
echo "Step 4/4 - Starting Spark..."
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