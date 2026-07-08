mkdir -p ~/jdbc
cd ~/jdbc

wget https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/2.1.0.32/redshift-jdbc42-2.1.0.32.jar


#!/bin/bash

set -e

echo "Installing PostgreSQL client..."

sudo dnf install -y postgresql15

echo "Done."