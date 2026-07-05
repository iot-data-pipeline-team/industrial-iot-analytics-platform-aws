#!/bin/bash

set -e

############################################
# Industrial IoT Platform Reset
############################################

set -a
source .env
set +a

echo "===================================="
echo "Resetting Industrial IoT Platform..."
echo "===================================="

############################################
# Stop Running Spark Applications
############################################

echo
echo "Stopping running Spark applications..."

APP_IDS=$(yarn application -list 2>/dev/null \
    | grep SPARK \
    | awk '{print $1}' || true)

if [ -z "$APP_IDS" ]; then
    echo "✓ No Spark applications running."
else
    for APP in $APP_IDS
    do
        echo "Stopping $APP ..."
        yarn application -kill "$APP" || true
    done

    echo "✓ Spark applications stopped."
fi

############################################
# Clean Local Spark Temporary Files
############################################

echo
echo "Removing Spark temporary files..."

rm -rf /mnt/tmp/spark-* || true
rm -rf /mnt/tmp/temporary-* || true
rm -rf /mnt/tmp/artifacts-* || true

echo "✓ Local Spark temporary files removed."

############################################
# Remove Structured Streaming Checkpoints
############################################

echo
echo "Removing Spark checkpoints from S3..."

aws s3 rm \
    s3://iot-platform-malek/checkpoints/ \
    --recursive || true

echo "✓ Checkpoints removed."

############################################
# Optional Data Cleanup
############################################

read -p "Delete Bronze/Silver/Gold data from S3? (y/N): " ANSWER

if [[ "$ANSWER" =~ ^[Yy]$ ]]; then

    echo
    echo "Removing Bronze..."

    aws s3 rm \
        s3://iot-platform-malek/bronze/ \
        --recursive || true

    echo "Removing Silver..."

    aws s3 rm \
        s3://iot-platform-malek/silver/ \
        --recursive || true

    echo "Removing Gold..."

    aws s3 rm \
        s3://iot-platform-malek/gold/ \
        --recursive || true

    echo "✓ Data removed."

else
    echo "Keeping Bronze/Silver/Gold data."
fi

echo
echo "===================================="
echo "Reset completed successfully!"
echo "===================================="