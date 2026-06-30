#!/bin/bash

set -e

source venv/bin/activate

echo "===================================="
echo "Starting Machine Producer..."
echo "===================================="

venv/bin/python producer/ahmed_producer.py 

