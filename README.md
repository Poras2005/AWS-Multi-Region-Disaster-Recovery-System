# AWS Multi-Region Disaster Recovery System

A cloud-native disaster recovery platform built on AWS to simulate multi-region failover, automated infrastructure provisioning, and resilient application deployment using Infrastructure as Code (IaC) and DevOps practices.

This project demonstrates practical implementation of:
- Multi-region deployment architecture
- Route53 DNS failover
- Cross-region database replication
- Infrastructure automation with Terraform
- Containerized microservices
- CI/CD security validation
- Cloud monitoring and failover testing

---

# Architecture Overview

The system deploys application infrastructure across two AWS regions in an active-passive disaster recovery setup.

## Core Components

- AWS EC2 instances for application hosting
- Auto Scaling Groups for workload resilience
- Elastic Load Balancers for traffic distribution
- Route53 health checks and DNS failover
- Cross-region Amazon RDS replication
- Dockerized Flask microservice
- Terraform-based infrastructure provisioning
- GitHub Actions CI/CD workflows
- CloudWatch monitoring and alerting

---

# Tech Stack

| Category | Technologies |
|---|---|
| Cloud Platform | AWS |
| Infrastructure as Code | Terraform |
| Containerization | Docker |
| Backend | Flask (Python) |
| CI/CD | GitHub Actions |
| Security Scanning | Checkov, Trivy |
| Monitoring | AWS CloudWatch |
| DNS & Failover | Route53 |
| Database | Amazon RDS |

---

# Key Features

## Multi-Region Failover

Implemented Route53 DNS failover between primary and secondary AWS regions using health checks and automated traffic redirection.

## Infrastructure Automation

Provisioned AWS infrastructure using reusable Terraform modules for networking, compute, database, and monitoring resources.

## Containerized Application Deployment

Built and deployed a Dockerized Flask microservice with:
- Region-aware API responses
- Health-check endpoints
- Structured application logging
- Database-backed request simulation

## CI/CD Validation Pipeline

Integrated GitHub Actions workflows for:
- Terraform validation
- Security scanning using Checkov
- Container vulnerability scanning using Trivy
- Automated deployment workflows

## Monitoring & Observability

Configured CloudWatch monitoring for:
- EC2 instance health
- Application availability
- Infrastructure events
- Failover simulation testing

---

# Project Structure

```bash
.
├── terraform/
│   ├── modules/
│   ├── environments/
│   └── main.tf
│
├── app/
│   ├── routes/
│   ├── templates/
│   ├── Dockerfile
│   └── app.py
│
├── .github/workflows/
│
├── monitoring/
│
└── scripts/
```

---

# Deployment Workflow

1. Provision AWS infrastructure using Terraform
2. Build and containerize Flask application
3. Deploy workloads to primary AWS region
4. Configure Route53 health checks and failover policies
5. Enable cross-region RDS replication
6. Validate failover using simulated outages

---

# Disaster Recovery Workflow

## Normal Operation
- Primary region handles application traffic
- Secondary region remains on standby
- Route53 continuously monitors endpoint health

## Failover Scenario
- Route53 detects application failure
- DNS traffic redirects to secondary region
- Secondary infrastructure serves application traffic

---

# Validation & Testing

The project was tested using simulated application and infrastructure failures.

### Tested Scenarios

- EC2 application shutdown
- Health-check failure simulation
- Route53 DNS failover behavior
- Terraform infrastructure recreation
- CI/CD security validation workflows

### Observations

- DNS failover response observed within approximately 45–70 seconds depending on DNS propagation behavior
- Infrastructure redeployment successfully validated using Terraform automation
- Security scans detected vulnerable container dependencies during CI/CD testing

---

# Security Practices

Implemented several foundational cloud security practices:

- IAM role-based access control
- AWS Secrets Manager integration
- Infrastructure security scanning using Checkov
- Container image vulnerability scanning using Trivy
- Principle of least privilege for service permissions

---

# Current Limitations

This project is designed as a learning-focused disaster recovery implementation and has several limitations:

- Uses active-passive failover instead of active-active architecture
- Terraform state is currently stored locally
- Limited application-level observability
- Database replication lag may affect immediate consistency during failover
- Failover timing depends on DNS TTL and health-check intervals

---

# Future Improvements

Potential enhancements include:

- Remote Terraform state management using S3 + DynamoDB locking
- Kubernetes-based deployment architecture
- Centralized logging with Grafana Loki or ELK Stack
- Blue/Green deployment strategy
- Automated rollback workflows
- Chaos engineering-based failure testing
- Prometheus and Grafana integration

---

- GitHub: https://github.com/Poras2005
- LinkedIn: [Add LinkedIn URL]
