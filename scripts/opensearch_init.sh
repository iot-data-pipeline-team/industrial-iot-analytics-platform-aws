#!/bin/bash

set -e

echo "Waiting for OpenSearch..."

until docker exec jupyter bash -c '
curl -f -k -s \
-u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
"https://$OPENSEARCH_HOST:$OPENSEARCH_PORT" >/dev/null
'
do
    echo "Waiting..."
    sleep 5
done

echo "OpenSearch is ready."

############################################
# Helper Functions
############################################

upload_template() {
    local template_name=$1
    local template_file=$2

    echo "Uploading template: $template_name..."

    docker exec jupyter bash -c "
    curl -f -k \
    -u \"\$OPENSEARCH_USER:\$OPENSEARCH_PASSWORD\" \
    -H 'Content-Type: application/json' \
    -X PUT \
    \"https://\$OPENSEARCH_HOST:\$OPENSEARCH_PORT/_index_template/$template_name\" \
    -d @$template_file
    "
}

create_index_if_missing() {
    local index_name=$1

    echo "Checking index: $index_name..."

    status=$(docker exec jupyter bash -c "
    curl -k -s -o /dev/null -w '%{http_code}' \
    -u \"\$OPENSEARCH_USER:\$OPENSEARCH_PASSWORD\" \
    https://\$OPENSEARCH_HOST:\$OPENSEARCH_PORT/$index_name
    ")

    if [ "$status" = "200" ]; then
        echo "✓ $index_name already exists. Skipping."
    else
        echo "Creating index: $index_name..."

        docker exec jupyter bash -c "
        curl -f -k \
        -u \"\$OPENSEARCH_USER:\$OPENSEARCH_PASSWORD\" \
        -X PUT \
        https://\$OPENSEARCH_HOST:\$OPENSEARCH_PORT/$index_name
        "

        echo "✓ $index_name created."
    fi
}

############################################
# Machine Events
############################################

upload_template \
    "machine-template" \
    "/home/jovyan/work/opensearch/templates/machine_template.json"

create_index_if_missing "machine-events"

############################################
# Machine Aggregates
############################################

upload_template \
    "machine-aggregates-template" \
    "/home/jovyan/work/opensearch/templates/machine_aggregates_template.json"

create_index_if_missing "machine-aggregates"

############################################
# Worker Events
############################################

upload_template \
    "worker-template" \
    "/home/jovyan/work/opensearch/templates/worker_template.json"

create_index_if_missing "worker-events"

############################################
# Worker Safety
############################################

upload_template \
    "worker-safety-template" \
    "/home/jovyan/work/opensearch/templates/worker_safety_template.json"

create_index_if_missing "worker-safety"

echo
echo "===================================="
echo "OpenSearch templates uploaded."
echo "OpenSearch indices are ready."
echo "===================================="