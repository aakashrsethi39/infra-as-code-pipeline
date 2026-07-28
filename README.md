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
Development

↓

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
Terraform Checks

↓

Docker Build

↓

Push Image to Amazon ECR

↓

Deploy to Staging

↓

Manual Approval

↓

Deploy to Production

↓

Wait for ECS Stability

↓

Automatic Rollback (if deployment fails)
```

> 📷 **Paste your GitHub Actions Pipeline Screenshot here**

---

## ✔ Automatic Rollback

The deployment automatically rolls back when

- ECS deployment becomes unhealthy
- ECS service does not reach a stable state

Rollback restores the previously running ECS Task Definition.

---

## ✔ Documentation

Included:

- Architecture Diagram
- Pipeline Flow
- Setup Guide
- Deployment Process
- Runbook
- AWS Cost Estimate

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
│   ├── backend/
│
│   ├── modules/
│   │
│   ├── networking/
│   ├── compute/
│   ├── security/
│   └── monitoring/
│
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── production.tfvars
│
├── .github/
│
│   └── workflows/
│       ├── terraform.yml
│       ├── staging.yml
│       └── production.yml
│
└── README.md
```

---

# Terraform Modules

## Networking Module

Creates

- VPC
- Public Subnets
- Route Tables
- Internet Gateway

---

## Compute Module

Creates

- ECS Cluster
- ECS Service
- ECS Task Definition

---

## Security Module

Creates

- IAM Roles
- Security Groups

---

## Monitoring Module

Creates

- CloudWatch Log Groups

---

# Terraform Backend

Remote backend configured using

- Amazon S3
- DynamoDB

Benefits

- Shared state
- Team collaboration
- State locking
- Prevents concurrent deployments

---

# Terraform Commands Used

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

# CI/CD Workflow

The GitHub Actions workflow performs:

```
Checkout Repository

↓

Configure AWS Credentials

↓

Terraform Init

↓

Terraform Format Check

↓

Terraform Validate

↓

TFLint

↓

Read Terraform Outputs

↓

Login to Amazon ECR

↓

Build Docker Image

↓

Push Docker Image

↓

Download ECS Task Definition

↓

Render Task Definition

↓

Deploy to ECS

↓

Wait for ECS Service Stability

↓

Rollback if Required

↓

Deployment Summary
```

> 📷 **Paste Pipeline Flow Diagram here**

---

# Branch Strategy

```
feature/*

↓

Pull Request

↓

Deploy to Staging

↓

Review

↓

Merge to Main

↓

Production Deployment
```

---

# Deployment Rollback Strategy

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

to restore the previous task definition automatically.

---

# ECS Auto Scaling

Configured Auto Scaling

Minimum Tasks

```
2
```

Maximum Tasks

```
6
```

Scaling Policies

- CPU Utilization
- Memory Utilization

---

# Application Load Balancer

Configured with

- Health Checks
- Target Groups
- Listener Rules

---

# CloudWatch Monitoring

CloudWatch is used for

- Container Logs
- ECS Logs
- Deployment Monitoring
- Health Check Monitoring

> 📷 **Paste CloudWatch Screenshot here**

---

# Security

Implemented

- IAM Roles
- Security Groups
- GitHub Secrets
- Remote Backend Security
- Least Privilege Access

Secrets are never stored in source code.

---

# Docker

Docker was used to

- Containerize the application
- Build images
- Push images to Amazon ECR
- Deploy immutable containers

Commands

```bash
docker build

docker tag

docker push
```

---

# AWS CLI Commands Used

```bash
aws configure

aws ecs describe-services

aws ecs describe-task-definition

aws ecs describe-tasks

aws ecs list-task-definitions

aws ecs update-service

aws ecs wait services-stable

aws elbv2 describe-target-health

aws logs tail

aws ecr get-login-password
```

---

# Setup Instructions

Clone Repository

```bash
git clone <repository-url>
```

Initialize Terraform

```bash
terraform init
```

Select Workspace

```bash
terraform workspace select production
```

Deploy Infrastructure

```bash
terraform apply
```

Push Code

GitHub Actions automatically deploys the application.

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

DevOps Capstone Project

Terraform • AWS • Docker • ECS • GitHub Actions • Infrastructure as Code
