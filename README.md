
# 🚀 Industrial IoT Analytics Platform

> **Production-Style Real-Time Industrial IoT Analytics Platform**
>
> Built with **Apache Kafka**, **Apache Spark Structured Streaming**, **PostgreSQL**, **Elasticsearch**, **Amazon S3**, **Docker**, and **AWS** using the **Medallion Architecture (Bronze → Silver → Gold)**.

---


# 📸 Screenshots

## Kibana Dashboard

<img width="1920" height="1080" alt="Screenshot (2259)" src="https://github.com/user-attachments/assets/b5d17c79-572b-46df-8a34-24157f1fa616" />


## S3

<img width="1920" height="1080" alt="Screenshot (2265)" src="https://github.com/user-attachments/assets/d81ddfa2-c7ca-4040-a222-cca0bf334453" />
<img width="1920" height="1080" alt="Screenshot (2264)" src="https://github.com/user-attachments/assets/133006f1-bef6-41c2-a116-4a99927e8f95" />
<img width="1920" height="1080" alt="Screenshot (2263)" src="https://github.com/user-attachments/assets/8998f4b6-c475-4f14-9939-090e26aadb05" />



## 📌 Project Overview

This project simulates a production Industrial IoT platform that continuously ingests, processes, stores, and analyzes streaming sensor data from industrial machines and worker safety devices.

The platform demonstrates modern **Data Engineering** practices including:

- Real-time streaming
- Distributed messaging with Kafka
- Stream processing with Spark Structured Streaming
- Medallion Architecture
- Data quality and quarantine
- Cloud object storage with Amazon S3
- Elasticsearch indexing
- Kibana dashboards
- PostgreSQL analytics
- Dockerized deployment
- AWS deployment on EC2

---

# 🏗 Architecture

```text
Machine Producer          Worker Producer
       │                        │
       └────────────┬───────────┘
                    │
              Kafka Cluster
          (3 Broker Deployment)
                    │
                    ▼
      Spark Structured Streaming
                    │
     ┌──────────────┼──────────────┐
     ▼              ▼              ▼
 PostgreSQL     Amazon S3     Elasticsearch
                    │
                    ▼
          Bronze → Silver → Gold
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
     Kibana                 Power BI
```

---

# ✨ Features

- Real-time Machine Monitoring Pipeline
- Real-time Worker Safety Pipeline
- Kafka 3-Broker Cluster
- Spark Structured Streaming
- Medallion Architecture
- Bronze / Silver / Gold Layers
- Amazon S3 Parquet Storage
- PostgreSQL Storage
- Elasticsearch Indexing
- Kibana Dashboards
- Power BI Reporting
- Data Quality Validation
- Quarantine Tables
- Dockerized Deployment
- AWS Cloud Deployment

---

# 🧱 Tech Stack

| Category | Technologies |
|----------|--------------|
| Streaming | Apache Kafka |
| Processing | Apache Spark Structured Streaming |
| Programming | Python |
| Database | PostgreSQL |
| Search | Elasticsearch |
| Object Storage | Amazon S3 |
| Dashboard | Kibana |
| BI | Power BI |
| Containerization | Docker & Docker Compose |
| Cloud | AWS EC2, IAM, S3 |

---

# 🏭 Machine Monitoring Pipeline

The machine producer simulates industrial equipment including:

- CNC Machines
- Robot Arms
- Conveyor Belts
- Pumps

Generated metrics include:

- Temperature
- RPM
- Vibration
- Power
- Fault Status
- Error Code

Silver layer enrichments:

- Health Score
- Risk Score
- Anomaly Flag
- Running Flag
- Temperature Status
- Vibration Status
- Power Status
- Fault Category
- Event Date
- Event Hour
- Time Bucket

Gold layer KPIs include:

- Average Temperature
- Average RPM
- Average Power
- Average Health Score
- Average Risk Score
- Fault Percentage
- Uptime Percentage

---

# 👷 Worker Safety Pipeline

Simulated worker telemetry includes:

- Heart Rate
- Fatigue Score
- Location
- Safety Events

Silver layer:

- Worker Risk Level
- Alert Level
- Safety Violation Flag
- Heart Rate Status

Gold layer:

- Violations per Window
- Workers in Danger Zone
- Average Fatigue Score

---

# 🥉🥈🥇 Medallion Architecture

## Bronze

Raw streaming events stored without modification.

## Silver

Cleaned and enriched data with business logic.

## Gold

Aggregated KPIs for analytics and dashboards.

---

# 🛡 Data Quality

The platform never silently drops invalid records.

Invalid records are redirected into quarantine datasets for later inspection.

---

# ☁ AWS Deployment

Current cloud architecture:

- Ubuntu 24.04 EC2
- Docker Compose
- IAM Role Authentication
- Amazon S3
- Elastic IP
- VS Code Remote SSH

Completed migration:

✅ MinIO → Amazon S3

Planned migrations:

- Amazon OpenSearch
- Amazon RDS PostgreSQL
- Amazon MSK
- Amazon EMR

---

# 📂 Repository Structure

```text
.
├── producer/
├── scripts/
│   ├── setup.sh
│   ├── run_project.sh
│   ├── run_spark.sh
│   ├── run_machine_producer.sh
│   └── run_worker_producer.sh
├── jars/
├── postgres/
├── elasticsearch/
├── kibana/
├── docker-compose.yml
├── streaming_job.py
└── README.md
```

---

# ⚙ First-Time Setup

Clone the repository:

```bash
git clone <repository-url>
cd local-iot-data-pipeline
```

Run:

```bash
./scripts/setup.sh
```

---

# ▶ Running the Project

Start infrastructure:

```bash
./scripts/run_project.sh
```

Run Spark:

```bash
./scripts/run_spark.sh
```

Run Machine Producer:

```bash
./scripts/run_machine_producer.sh
```

Run Worker Producer:

```bash
./scripts/run_worker_producer.sh
```

---

# 🌐 Service URLs

Replace `<EC2-IP>` with your server IP.

| Service | URL |
|---------|-----|
| Kibana | http://<EC2-IP>:5601 |
| Kafka UI | http://<EC2-IP>:12000 |
| Jupyter | http://<EC2-IP>:8888 |

---

# 🪣 Amazon S3 Layout

```text
bronze/
    machine_bronze_data/
    worker_bronze_data/

silver/
    machine_silver_data/
    worker_silver_data/

gold/
    machine_gold_data/
    worker_gold_data/
```

---

# 📊 Screenshots

Suggested screenshots:

- AWS Architecture
- EC2 Instance
- Kafka UI
- Kibana Dashboard
- Amazon S3 Bucket
- Power BI Dashboard

---

# 🚀 Future Roadmap

- Amazon OpenSearch
- Amazon RDS
- Amazon MSK
- Amazon EMR
- CI/CD Pipeline
- Monitoring & Alerting

---

# 🧪 Troubleshooting

Useful commands:

```bash
docker ps
docker logs -f jupyter
docker logs -f kafka1
docker stats
free -h
aws s3 ls
```

---


Industrial IoT Analytics Platform

ITI Data Management Graduation Project

---

# 📄 License

This project is provided for educational and portfolio purposes.
