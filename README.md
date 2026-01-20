# 🚀 Cloud-Native Multi-App Platform on AWS (Laravel + Django + React)

This repository demonstrates a **complete production-grade system design** where **AWS infrastructure is provisioned using Terraform** and multiple applications run together on **Kubernetes (AWS EKS)**.

### Applications supported:
- ✅ Laravel (PHP backend)
- ✅ Django (Python backend)
- ✅ React (Frontend)

The platform includes:
- GitLab CI/CD (test → build → push → deploy)
- Monitoring with Prometheus & Grafana
- Logging with Loki, Promtail, and AWS CloudWatch

This project is designed as a **reference architecture** for DevOps, Backend, and Platform Engineers.

---

## 🧱 Technology Stack

### Infrastructure (Terraform + AWS)
- Terraform (Infrastructure as Code)
- AWS VPC (Public & Private Subnets)
- AWS Application Load Balancer (ALB / Ingress)
- AWS EKS (Managed Kubernetes)
- AWS RDS (MySQL / PostgreSQL)
- AWS ECR (Docker Image Registry)
- AWS IAM (Least-Privilege Access)
- AWS CloudWatch (Infrastructure Logs)

### Applications
- Laravel (PHP-FPM + Nginx)
- Django (Gunicorn + Nginx)
- React (Nginx Static Hosting)

### CI/CD
- GitLab CI/CD
- Laravel: PHPUnit / Pest
- Django: Pytest
- React: Jest / Build
- Docker Image Build
- Push to AWS ECR
- Deploy to EKS using kubectl / Helm

### Observability
- Prometheus (Metrics Collection)
- Grafana (Dashboards & Alerts)
- Loki + Promtail (Application Logs)
- AWS CloudWatch (Infrastructure-level Logs)

---

## 🏗️ High-Level Architecture Overview


                ┌────────────────────┐
                │       Users        │
                └─────────┬──────────┘
                          │ HTTPS
                   ┌──────▼───────┐
                   │  AWS ALB     │
                   │ (Ingress)    │
                   └──────┬───────┘
                          │
    ┌─────────────────────▼─────────────────────┐
    │              AWS EKS Cluster               │
    │                                           │
    │  ┌─────────────┐   ┌─────────────┐       │
    │  │ Laravel App │   │ Django App  │       │
    │  │   (HPA)     │   │   (HPA)     │       │
    │  └──────┬──────┘   └──────┬──────┘       │
    │         │                 │               │
    │     ┌───▼─────────┐  ┌───▼─────────┐     │
    │     │ React App   │  │ Internal    │     │
    │     │ (Nginx)     │  │ Services    │     │
    │     └─────────────┘  └─────────────┘     │
    │                                           │
    └─────────────────────┬─────────────────────┘
                          │
                   ┌──────▼──────┐
                   │   AWS RDS   │
                   │ (Database)  │
                   └─────────────┘
