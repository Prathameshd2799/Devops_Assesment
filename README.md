# Devops_Assesment# DevOps Assessment

## Project Overview

This project demonstrates a production-style DevOps setup using:

- Terraform
- AWS Infrastructure
- Docker Compose
- PostgreSQL
- GitHub Actions
- Shell Scripting

---

## Project Structure

```
devops-assessment/
├── .github/
├── database/
├── infra/
├── scripts/
├── docker-compose.yml
├── README.md
└── .gitignore
```

---

## Terraform

Infrastructure includes:

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Route Tables
- ECS Cluster
- ECS Task Definition
- ECS Service
- Application Load Balancer
- PostgreSQL RDS

Environments:

- Dev
- Prod

---

## Terraform Commands

Move to the environment folder:

```bash
cd infra/envs/dev
```

Initialize Terraform:

```bash
terraform init
```

Format:

```bash
terraform fmt
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan
```

---

## Start Database

```bash
docker compose up -d
```

Verify:

```bash
docker ps
```

---

## Seed Data

```bash
docker exec -i postgres-db psql -U postgres -d hotel < database/seed/seed.sql
```

---

## Database Backup

```bash
./scripts/backup.sh
```

---

## Database Restore

```bash
./scripts/restore.sh
```

---

## Verify Restore

Connect to PostgreSQL:

```bash
docker exec -it postgres-db psql -U postgres -d hotel
```

Run:

```sql
SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```


If records are displayed, restore was successful.

---

## Query Optimization

Indexes were created for:

- city
- created_at
- org_id
- status

This improves filtering and aggregation performance for the required reporting query.

---

## Technologies

- Terraform
- AWS
- ECS Fargate
- Application Load Balancer
- PostgreSQL
- Docker Compose
- GitHub Actions
- Bash