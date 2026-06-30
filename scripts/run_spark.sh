#!/bin/bash

set -e


docker exec -it jupyter spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0,org.opensearch.client:opensearch-spark-35_2.12:2.0.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262 --jars /home/jovyan/jars/postgresql-42.6.2.jar     /home/jovyan/work/streaming_job.py