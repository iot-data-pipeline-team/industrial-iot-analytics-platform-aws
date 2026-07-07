#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo
echo "===================================="
echo "Bootstrapping EMR Environment"
echo "===================================="

############################################
# Kafka CLI
############################################

if [ ! -d "kafka_2.13-3.9.1" ]; then
    echo
    echo "Downloading Kafka 3.9.1..."

    wget --show-progress \
    https://archive.apache.org/dist/kafka/3.9.1/kafka_2.13-3.9.1.tgz

    echo "Extracting Kafka..."

    tar -xzf kafka_2.13-3.9.1.tgz

    rm kafka_2.13-3.9.1.tgz
else
    echo
    echo "Kafka already installed."
fi

############################################
# Load MSK Environment
############################################

source scripts/msk_env.sh

############################################
# Verification
############################################

echo
echo "Checking Kafka CLI..."

./kafka_2.13-3.9.1/bin/kafka-topics.sh --version

echo
echo "Checking client.properties..."

cat ~/client.properties

echo
echo "===================================="
echo "EMR Bootstrap Complete"
echo "===================================="
echo
echo "Next:"
echo "1) Verify MSK topics"
echo "2) Start Spark"
echo "3) Start Producers"
echo