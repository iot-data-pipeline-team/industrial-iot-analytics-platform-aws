#!/bin/bash

set -e

set -a
source .env
set +a

spark-submit \
--packages org.opensearch.client:opensearch-spark-40_2.13:2.0.0 \
streaming_job.py