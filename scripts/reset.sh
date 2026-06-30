#!/bin/bash

set -e

echo "===================================="
echo "Resetting Industrial IoT Platform..."
echo "===================================="

echo
echo "Removing Spark checkpoints..."

docker exec jupyter bash -c "rm -rf /home/jovyan/data/checkpoints/*" || true

echo "✓ Checkpoints removed."

echo
echo "Truncating PostgreSQL tables..."

docker exec postgres psql -U user -d db <<'EOF'
TRUNCATE TABLE
    machine_events_bronze,
    machine_events_silver,
    machine_aggregates_gold,
    machine_events_quarantine,
    worker_events_bronze,
    worker_events_silver,
    worker_safety_gold,
    worker_events_quarantine
RESTART IDENTITY CASCADE;
EOF

echo "✓ PostgreSQL tables truncated."

echo
echo "===================================="
echo "Reset completed successfully!"
echo "===================================="