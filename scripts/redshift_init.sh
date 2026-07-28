#!/bin/bash

set -e

echo "===================================="
echo "Initializing Redshift"
echo "===================================="

mkdir -p ~/jdbc
cd ~/jdbc

if [ ! -f redshift-jdbc42-2.1.0.32.jar ]; then
    echo "Downloading Redshift JDBC driver..."

    wget \
    https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/2.1.0.32/redshift-jdbc42-2.1.0.32.jar
else
    echo "Redshift JDBC driver already exists."
fi

echo
echo "Installing PostgreSQL client..."

sudo dnf install -y postgresql15

echo
echo "Redshift initialization completed."