#!/bin/bash

set -e

############################################
# Load Environment Variables
############################################

set -a
source .env
set +a

echo "===================================="
echo "Amazon OpenSearch Initialization"
echo "===================================="

echo
echo "Waiting for OpenSearch..."

until curl -f -k -s \
    -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
    "https://$OPENSEARCH_HOST:$OPENSEARCH_PORT" >/dev/null
do
    echo "Waiting..."
    sleep 5
done

echo
echo "✓ OpenSearch is ready."

############################################
# Helper Functions
############################################

upload_template() {

    local template_name=$1
    local template_file=$2

    echo
    echo "Uploading template: $template_name"

    curl -f -k \
        -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
        -H "Content-Type: application/json" \
        -X PUT \
        "https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/_index_template/$template_name" \
        -d @"$template_file"

    echo
    echo "✓ Template uploaded."
}

create_index_if_missing() {

    local index_name=$1

    echo
    echo "Checking index: $index_name"

    status=$(curl -k -s \
        -o /dev/null \
        -w "%{http_code}" \
        -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
        "https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/$index_name")

    case "$status" in

        200)
            echo "✓ Index already exists."
            ;;

        404)
            echo "Creating index..."

            curl -f -k \
                -u "$OPENSEARCH_USER:$OPENSEARCH_PASSWORD" \
                -X PUT \
                "https://$OPENSEARCH_HOST:$OPENSEARCH_PORT/$index_name"

            echo "✓ Index created."
            ;;

        *)
            echo "Unexpected response while checking $index_name"
            echo "HTTP Status: $status"
            exit 1
            ;;
    esac
}

############################################
# Upload Templates
############################################

upload_template \
    "machine-template" \
    "opensearch/templates/machine_template.json"

upload_template \
    "machine-aggregates-template" \
    "opensearch/templates/machine_aggregates_template.json"

upload_template \
    "worker-template" \
    "opensearch/templates/worker_template.json"

upload_template \
    "worker-safety-template" \
    "opensearch/templates/worker_safety_template.json"

############################################
# Create Indices
############################################

create_index_if_missing "machine-events"

create_index_if_missing "machine-aggregates"

create_index_if_missing "worker-events"

create_index_if_missing "worker-safety"

echo
echo "===================================="
echo "OpenSearch initialization completed."
echo "===================================="
echo
echo "Templates uploaded successfully."
echo "Indices verified successfully."
echo