# QUICK_START.md

# Install Git (Amazon Linux 2023)
sudo dnf install git -y

# Clone the AWS migration branch
git clone -b aws-cloud-migration-malek https://github.com/iot-data-pipeline-team/industrial-iot-analytics-platform-aws.git


# Connect to the EMR master node
ssh -i "D:\iot-platform-key.pem" hadoop@ec2-44-200-208-66.compute-1.amazonaws.com