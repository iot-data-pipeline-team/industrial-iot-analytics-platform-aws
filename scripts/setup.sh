#!/bin/bash

set -e

echo "===================================="
echo "Industrial IoT Platform Setup"
echo "===================================="

echo
echo "Checking Python..."

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 is not installed."
    exit 1
fi

echo "✓ Python found."

echo
echo "Installing Python dependencies..."

python3 -m pip install --user --upgrade pip
python3 -m pip install --user -r requirements.txt

echo
echo "Making scripts executable..."

chmod +x scripts/*.sh

echo
echo "===================================="
echo "Setup completed successfully!"
echo "===================================="

echo
echo "Run:"
echo "./scripts/run_project.sh"