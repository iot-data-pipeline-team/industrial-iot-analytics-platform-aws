#!/bin/bash

set -e

echo "Waiting for OpenSearch..."

until docker exec jupyter bash -c '
curl -f -k -s -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT" >/dev/null
'
do
    echo "Waiting..."
    sleep 5
done

echo "OpenSearch is ready."

############################################
# Machine Events
############################################

echo "Uploading machine template..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-H "Content-Type: application/json" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/_index_template/machine-template" \
-d @/home/jovyan/work/opensearch/templates/machine_template.json
'

echo "Creating machine-events index..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/machine-events"
'

############################################
# Machine Aggregates
############################################

echo "Uploading machine aggregates template..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-H "Content-Type: application/json" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/_index_template/machine-aggregates-template" \
-d @/home/jovyan/work/opensearch/templates/machine_aggregates_template.json
'

echo "Creating machine-aggregates index..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/machine-aggregates"
'

############################################
# Worker Events
############################################

echo "Uploading worker template..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-H "Content-Type: application/json" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/_index_template/worker-template" \
-d @/home/jovyan/work/opensearch/templates/worker_template.json
'

echo "Creating worker-events index..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/worker-events"
'

############################################
# Worker Safety
############################################

echo "Uploading worker safety template..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-H "Content-Type: application/json" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/_index_template/worker-safety-template" \
-d @/home/jovyan/work/opensearch/templates/worker_safety_template.json
'

echo "Creating worker-safety index..."

docker exec jupyter bash -c '
curl -f -k \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
-X PUT \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/worker-safety"
'

echo
echo "===================================="
echo "OpenSearch templates uploaded."
echo "OpenSearch indices created."
echo "===================================="