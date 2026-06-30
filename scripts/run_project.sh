#!/bin/bash

set -e



echo "===================================="
echo "Starting infrastructure services..."
echo "===================================="

docker compose up -d \
    zookeeper \
    kafka1 \
    kafka2 \
    kafka3 \
    elasticsearch \
    postgres \
    minio \
    kibana


echo
echo "===================================="
echo "Running initialization jobs..."
echo "===================================="

docker compose run --rm kafka-init

docker compose run --rm elasticsearch-init

docker compose run --rm kibana-init

docker compose run --rm minio-init


echo
echo "===================================="
echo "Starting Kafka UI..."
echo "===================================="

docker compose up -d kafka-ui


echo
echo "===================================="
echo "Starting Spark and Jupyter..."
echo "===================================="

docker compose up -d \
    spark-master \
    spark-worker \
    jupyter


echo
echo "Waiting for Jupyter..."

until docker exec jupyter ls >/dev/null 2>&1
do
    echo "Waiting for Jupyter container..."
    sleep 2
done

echo "Jupyter is ready."



echo
echo "===================================="
echo "Project Started Successfully!"
echo "===================================="

