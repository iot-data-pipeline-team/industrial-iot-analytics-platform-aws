# QUICK_START.md

# Install Git (Amazon Linux 2023)
sudo dnf install git -y

# Clone the AWS migration branch
git clone -b aws-cloud-migration-malek https://github.com/iot-data-pipeline-team/industrial-iot-analytics-platform-aws.git


# Connect to the EMR master node
ssh -i "D:\iot-platform-key.pem" hadoop@ec2-44-200-208-66.compute-1.amazonaws.com


# Install the requirements for the project
python3 -m pip install -r requirements.txt

# Configure Git (run once per new machine)
git config --global user.name "Abdelrahman Malek"
git config --global user.email "amm2592000@gmail.com"


# To access Redshift
 PGPASSWORD='xZVDyDih9psf::v' psql -h iot-platform-workgroup.533267199028.us-east-1.redshift-serverless.amazonaws.com -p 5439 -U admin -d dev

 # To truncate Redshift Table
TRUNCATE TABLE machine_events_bronze;
TRUNCATE TABLE machine_events_bronze;
TRUNCATE TABLE machine_events_silver;
TRUNCATE TABLE machine_aggregates_gold;

TRUNCATE TABLE worker_events_bronze;
TRUNCATE TABLE worker_events_silver;
TRUNCATE TABLE worker_safety_gold;

TRUNCATE TABLE machine_events_quarantine;
TRUNCATE TABLE worker_events_quarantine;