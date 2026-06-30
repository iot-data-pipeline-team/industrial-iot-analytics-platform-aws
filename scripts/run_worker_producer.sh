#!/bin/bash

set -e

source venv/bin/activate



echo "===================================="
echo "Starting Worker Producer..."
echo "===================================="

venv/bin/python producer/worker_producer.py 



