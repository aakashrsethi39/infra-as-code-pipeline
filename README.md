# Infrastructure as Code Pipeline

A production-ready Infrastructure as Code (IaC) project built using **Terraform**, **AWS ECS Fargate**, **Docker**, **Amazon ECR**, and **GitHub Actions**.

This project demonstrates a complete DevOps workflow by provisioning AWS infrastructure with Terraform modules, deploying a containerized application to Amazon ECS Fargate, automating CI/CD using GitHub Actions, and implementing automatic deployment rollback for high availability.

---

# Architecture

> <img width="1536" height="1024" alt="ChatGPT Image Jul 28, 2026, 06_02_11 PM" src="https://github.com/user-attachments/assets/285caf9d-ff25-436f-9848-bf4f4ae26c2b" />
---

# Project Overview

This project provisions an entire AWS infrastructure using Terraform and deploys a Dockerized web application to Amazon ECS Fargate.

The deployment pipeline automatically:

- Validates Terraform
- Builds Docker images
- Pushes images to Amazon ECR
- Deploys to Amazon ECS
- Waits for ECS service stability
- Automatically rolls back if deployment fails

The infrastructure supports multiple environments using Terraform Workspaces and Remote State stored in Amazon S3 with DynamoDB state locking.

---

# Project Features

- Infrastructure as Code (Terraform)
- Modular Terraform Design
- Remote Terraform Backend
- State Locking using DynamoDB
- Multiple Environments
- Terraform Workspaces
- Dockerized Application
- Amazon ECS Fargate Deployment
- Amazon ECR
- GitHub Actions CI/CD
- Automatic Rollback Strategy
- ECS Service Auto Scaling
- CloudWatch Logging
- Application Load Balancer
- IAM Roles
- Secure Credentials using GitHub Secrets
- Branch Based Deployments
- Infrastructure Monitoring

---

# Deliverables Completed

## ✔ Terraform Infrastructure

Provisioned using reusable Terraform modules.

Includes:

- VPC
- Public Subnets
- Internet Gateway
- Route Tables
- ECS Cluster
- ECS Fargate Service
- ECS Task Definition
- Amazon ECR
- Application Load Balancer
- Target Group
- Security Groups
- CloudWatch Log Groups
- IAM Roles
- Auto Scaling

---

## ✔ Multiple Environments

Implemented using Terraform Workspaces.

```
Staging

↓

Production
```

Same Terraform code with different configurations.

---

## ✔ CI/CD Pipeline

Implemented using GitHub Actions.

Pipeline Flow

```
Checkout

↓

Configure AWS

↓

Terraform Init

↓

Terraform Validate

↓

Terraform fmt

↓

TFLint

↓

Read Outputs

↓

Login ECR

↓

Build Docker Image

↓

Push Image

↓

Download Task Definition

↓

Render Task Definition

↓

Save Current Task Definition

↓

Deploy ECS

↓

Wait

↓

Health Check

↓

Rollback if needed

↓

Summary
```
---

# Technologies Used

| Category | Technology |
|-----------|------------|
| Cloud | AWS |
| IaC | Terraform |
| Container | Docker |
| Container Registry | Amazon ECR |
| Container Platform | ECS Fargate |
| CI/CD | GitHub Actions |
| Monitoring | CloudWatch |
| Networking | VPC, ALB |
| Security | IAM |

---

# AWS Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon VPC | Networking |
| ECS | Container Orchestration |
| ECS Fargate | Serverless Containers |
| Amazon ECR | Docker Image Repository |
| Application Load Balancer | Traffic Distribution |
| CloudWatch | Logging & Monitoring |
| IAM | Roles & Permissions |
| Amazon S3 | Terraform Backend |
| DynamoDB | Terraform State Locking |

---

# Repository Structure

```text
infra-as-code-pipeline/

│
├── app/
│
├── terraform/
│
│   ├── bootstrap/
│
│   ├── modules/
│   │
│   ├── networking/
│   ├── compute/
│   ├── security/
│   └── monitoring/
│
├── .github/
│
│   └── workflows/
│       ├── staging.yml
│       └── production.yml
│
└── README.md
```

---

# Project Phases

## Phase 1 - Clone Repository

```bash
git clone https://github.com/aakashrsethi39/infra-as-code-pipeline.git

cd infra-as-code-pipeline
```
---

## Phase 2 - Create the Bootstrap Infrastructure

Terraform cannot store its own state in an S3 bucket that does not yet exist.

A separate bootstrap directory is used to create:
- S3 Bucket
- DynamoDB Table

```bash
cd bootstrap

terraform init

terraform apply
```
Purpose

- Remote Terraform State
- State Locking
- Team Collaboration
---

## Phase 3 — Create Terraform Modules

Infrastructure is divided into reusable modules.
```bash
terraform/

modules/

    networking/

    security/

    compute/

    monitoring/
```


### Networking Module

Creates

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Route Tables


### Security Module

Creates
- Security Groups

For
- ECS
- ALB


### Compute Module

Creates

- ECS Cluster
- ECS Service
- ECS Task Definition
- ECR Repository
- ALB
- Target Group
- Listener


### Monitoring Module

Creates
- CloudWatch Log Groups
---

## Phase 4 - Deploy Staging Infrastructure 

```bash
cd terraform
terraform workspace new staging
terraform workspace list
terraform workspace select staging
terraform init
terraform plan
terraform apply
```
---
## Phase 5 - Deploy Production Infrastructure

```bash

terraform workspace new production
terraform workspace list
terraform workspace select production
terraform init
terraform plan
terraform apply
```
---

## Phase 6 – Build Docker Image

Containerized the Flask application .

Dockerfile

Build Image

```bash
docker build -t production-app .
```
---

## Phase 7 – Amazon ECR

Created separate ECR repositories for different environments.

Repositories

- ecommerce-staging
- ecommerce-production

Authentication

```bash
aws ecr get-login-password \
| docker login \
--username AWS \
--password-stdin ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com
```

Push Image

```bash
docker tag ecommerce-app:latest ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/ecommerce-default:latest

docker push ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/ecommerce-default:latest
```
---

## Phase 8 – Configure GitHub Secrets

Add

```bash

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION
```
GitHub automatically uses these during deployment.

---
## Phase 9 — Configure Production Environment Protection

GitHub

Settings

    ↓

Environments

    ↓

Production


Configure

- Required Reviewers
- Manual Approval

This ensures production deployments require approval.

---
## Phase 10 - Implement Branch-Based Deployment

```bash
Feature Branch

    ↓

Pull Request

    ↓

Staging Deployment

    ↓

Testing

    ↓

Merge to Main

    ↓

Production Deployment
```

---

## Phase 11 - Configure ECS Auto Scaling

Terraform creates
```bash
Minimum Tasks = 2

Maximum Tasks = 6
```

Scaling Policies

- CPU Utilization
- Memory Utilization

---

## Phase 12 - Deployment Rollback Strategy

The deployment automatically rolls back when

- ECS deployment becomes unhealthy
- ECS service does not reach a stable state

Rollback restores the previously running ECS Task Definition.

> <img width="1074" height="604" alt="image" src="https://github.com/user-attachments/assets/cd920821-811f-4262-ac8c-fcee3987bf38" />

Before deployment

```
Current Task Definition

    ↓

Save Task Definition

    ↓

Deploy New Revision

    ↓

Wait for ECS Stability

    ↓

Deployment Failed?

    ↓

   YES

    ↓

Rollback to Previous Stable Task Definition

    ↓

Deployment Restored

```

Rollback uses

```bash
aws ecs update-service
```
---

## Phase 13 - Application Load Balancer

Terraform provisions
- Application Load Balancer
- Listener
- Target Group

Traffic Flow

```bash
Internet

    ↓

   ALB

    ↓

Target Group

    ↓

Fargate Tasks

```

---

## Phase 14 - CloudWatch Monitoring

CloudWatch is used for

- Container Logs
- ECS Logs
- Deployment Monitoring
- Health Check Monitoring

---

## Phase 15 - Security

Implemented

- IAM Roles
- Security Groups
- GitHub Secrets
- Remote Backend Security
- Least Privilege Access

Secrets are never stored in source code.

---
# Terraform Commands Used
```

```bash
terraform init

terraform fmt

terraform validate

terraform workspace new staging

terraform workspace select production

terraform plan

terraform apply

terraform destroy
```

Terraform Quality Checks

- terraform fmt
- terraform validate
- TFLint

---

# Final Project Workflow

```
Create GitHub Repository
        │
        ▼
Create Bootstrap (S3 + DynamoDB)
        │
        ▼
Configure Remote Backend
        │
        ▼
Create Terraform Modules
        │
        ▼
Create Terraform Workspaces
        │
        ▼
Deploy Staging Infrastructure
        │
        ▼
Deploy Production Infrastructure
        │
        ▼
Develop & Dockerize Application
        │
        ▼
Create Feature Branch
        │
        ▼
Pull Request → Staging
        │
        ▼
staging.yml CI/CD Pipeline
        │
        ▼
Merge Staging → Main
        │
        ▼
Production Approval
        │
        ▼
production.yml CI/CD Pipeline
        │
        ▼
Build Image → Push to ECR
        │
        ▼
Deploy New ECS Task Definition
        │
        ▼
Wait for Stability + Health Checks
        │
        ├─────────────── Healthy ───────────────► Deployment Successful
        │
        └─────────────── Unhealthy ─────────────► Rollback to Previous Task Definition
```

---

# AWS CLI Commands Used

```bash
aws configure

aws ecs describe-services

aws ecs update-service

aws ecs describe-task-definition

aws ecs describe-tasks

aws ecs list-task-definitions

aws elbv2 describe-target-health

aws elbv2 describe-load-balancers

aws ecr list-images --repository-name application

aws ecr describe-repositories

aws elbv2 describe-target-groups

```

---

# Common Failure Scenarios (Runbook)

| Issue | Resolution |
|--------|------------|
| Terraform Init Failed | Verify S3 Backend |
| Terraform Lock Error | Check DynamoDB Lock |
| Docker Build Failed | Verify Dockerfile |
| ECS Task Failed | Check CloudWatch Logs |
| ALB Health Check Failed | Verify `/health` endpoint |
| ECS Deployment Failed | Inspect ECS Events |
| Rollback Triggered | Previous Task Definition Restored |
| GitHub Secrets Missing | Configure Repository Secrets |

---

# Estimated AWS Monthly Cost

| Service | Estimated Cost |
|----------|----------------|
| ECS Fargate | Low |
| Amazon ECR | Low |
| Application Load Balancer | Low |
| CloudWatch | Low |
| Amazon S3 | Low |
| DynamoDB | Low |

> Costs depend on workload and region. AWS Free Tier or promotional credits can significantly reduce charges for learning environments.

---

# Learning Outcomes

Through this project I learned

- Infrastructure as Code
- Modular Terraform
- Terraform Modules
- Terraform Remote Backend
- Terraform Workspaces
- Docker
- Amazon ECS Fargate
- Amazon ECR
- GitHub Actions
- ECS Auto Scaling
- Application Load Balancer
- CloudWatch Monitoring
- IAM Roles
- Infrastructure Automation
- CI/CD Pipelines
- Deployment Rollback Strategy
- Terraform Validate
- Terraform Format
- TFLint
- Remote State Management
- DynamoDB State Locking
- Multiple Environment Deployments
- AWS CLI
- Branch Based Deployments
- Production Release Process

---

# Future Improvements

- Blue/Green Deployments
- Canary Deployments
- SonarQube Integration
- Trivy Security Scanning
- Slack Notifications
- Prometheus Monitoring
- Grafana Dashboards
- Cost Optimization
- Kubernetes Migration

---

# Project Requirements Completed

## Infrastructure

- Terraform Modules
- Remote Backend
- ECS Cluster
- Fargate
- IAM
- Security Groups
- CloudWatch
- ECR
- ALB

## CI/CD

- Terraform Validate
- Terraform fmt
- TFLint
- Docker Build
- Push to ECR
- ECS Deployment
- Manual Approval
- Production Deployment
- Automatic Rollback

## DevOps Best Practices

- Infrastructure as Code
- Modular Terraform
- Multiple Environments
- Secure Secrets
- Remote State
- State Locking
- Auto Scaling
- Health Checks
- Monitoring
- Logging
- Branch Based Workflow

---

# Author

**Aakash Sethi**

Output :- 

---

> <img width="1177" height="466" alt="image" src="https://github.com/user-attachments/assets/2e43b408-b569-4fb0-bdc8-13962bcedbd6" />

> <img width="1067" height="558" alt="image" src="https://github.com/user-attachments/assets/600118ce-8600-4a06-a6c0-0b2f8f3b56aa" />

> <img width="1057" height="594" alt="image" src="https://github.com/user-attachments/assets/53a35a2d-6b0b-4d2c-83ef-9a443d410c58" />

> <img width="1175" height="467" alt="image" src="https://github.com/user-attachments/assets/1561517a-d313-472b-b714-3cb24d204bcf" />

> <img width="1687" height="502" alt="image" src="https://github.com/user-attachments/assets/89ca3bbb-6da8-4ba6-ba7c-00d43c20df16" />

> <img width="1062" height="420" alt="image" src="https://github.com/user-attachments/assets/addc7dfd-1be7-49a4-8951-f25f399cbb90" />

> <img width="1615" height="767" alt="image" src="https://github.com/user-attachments/assets/b6e003e4-c8e9-4f54-ac84-ae5a3ae34b02" />

> <img width="1637" height="720" alt="image" src="https://github.com/user-attachments/assets/272d4613-d3c2-4036-ab44-acd5ef231973" />

> <img width="1380" height="746" alt="image" src="https://github.com/user-attachments/assets/5e92b471-fb48-4949-920f-9868a543de5d" />

> <img width="1530" height="671" alt="image" src="https://github.com/user-attachments/assets/860ddfde-9ffb-4cf0-8541-e0b8e1fac14e" />

> <img width="1128" height="327" alt="image" src="https://github.com/user-attachments/assets/94a03e62-c039-4d3e-977c-a3e772e420c5" />

> <img width="602" height="338" alt="image" src="https://github.com/user-attachments/assets/41af93ac-3fb7-42d7-9b8f-7beef36c6c4d" />

> <img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/bbf66689-4b4f-42f2-a092-5f93b86f0f8c" />

Push Code from staging branch to main branch and approve 

> <img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/8a02b420-7ecb-4d2b-a046-8cc032a6f953" />

> <img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/3f4e51e9-f691-4ec8-b19c-bcf6e8c403db" />

---

## DevOps Capstone Project
---

Terraform • AWS • Docker • ECS • GitHub Actions • Infrastructure as Code
