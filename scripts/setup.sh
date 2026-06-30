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

echo
echo "Installing python3-venv..."

sudo apt update
sudo apt install -y python3-venv

echo
echo "Creating virtual environment..."

if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Virtual environment created."
else
    echo "Virtual environment already exists."
fi

echo
echo "Activating virtual environment..."

source venv/bin/activate

echo
echo "Installing Python dependencies..."

pip install --upgrade pip
pip install -r requirements.txt

echo
echo "Making scripts executable..."

chmod +x scripts/run_project.sh
chmod +x scripts/run_spark.sh
chmod +x scripts/run_machine_producer.sh
chmod +x scripts/run_worker_producer.sh


echo
echo "===================================="
echo "Setup completed successfully!"
echo "===================================="

echo
echo "Next step:"
echo "./scripts/run_project.sh"