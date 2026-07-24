# StartTech Application

A production-ready cloud-native full-stack application deployed on Amazon EKS using Kubernetes. This repository contains the application source code, Docker configurations, Kubernetes manifests, and GitHub Actions workflow used to build, deploy, and expose the application through an AWS Application Load Balancer.

This project was built as part of the **StartTech Enterprise DevOps Assessment**, demonstrating modern containerization, orchestration, CI/CD, and cloud-native deployment practices.

---

# Architecture

```
                        GitHub
                           │
                GitHub Actions CI
                           │
          Build & Validate Application
                           │
                     Docker Images
                           │
                           ▼
                    Amazon EKS Cluster
          ┌────────────────────────────────┐
          │                                │
          │     Kubernetes Deployment      │
          │                                │
          │   Frontend Pods   Backend Pods │
          │                                │
          └─────────────┬──────────────────┘
                        │
                 Kubernetes Service
                        │
               AWS Load Balancer Controller
                        │
          AWS Application Load Balancer (ALB)
                        │
                    Internet Users
```

---

# Features

- React Frontend
- Golang REST API Backend
- Dockerized application
- Kubernetes Deployments
- Kubernetes Services
- Ingress with AWS Application Load Balancer
- AWS Load Balancer Controller integration
- Health checks
- GitHub Actions CI pipeline
- Production-ready Kubernetes manifests

---

# Technology Stack

## Frontend

- React
- JavaScript
- Nginx

## Backend

- Golang
- REST API

## Containerization

- Docker
- Docker Compose

## Orchestration

- Kubernetes
- Amazon EKS

## AWS Services

- Amazon EKS
- Elastic Load Balancer (ALB)
- IAM
- VPC
- EC2 Worker Nodes

## DevOps

- GitHub Actions
- Docker
- Kubernetes
- kubectl

---

# Repository Structure

```text
starttech-application/
│
├── frontend/
│   ├── src/
│   ├── public/
│   └── Dockerfile
│
├── backend/
│   ├── cmd/
│   ├── internal/
│   ├── Dockerfile
│   └── go.mod
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
│
├── .github/
│   └── workflows/
│       └── application.yml
│
├── docker-compose.yml
└── README.md
```

---

# Deployment Workflow

## 1. Clone Repository

```bash
git clone https://github.com/Afolabiamez/Go-Full-Stack-Deployment.git

cd Go-Full-Stack-Deployment/starttech-application
```

---

## 2. Build Docker Images

```bash
docker build -t frontend ./frontend

docker build -t backend ./backend
```

---

## 3. Push Images

Push the application images to your preferred container registry.

Example:

```bash
docker tag backend your-registry/backend:latest

docker push your-registry/backend:latest
```

---

## 4. Deploy to Kubernetes

```bash
kubectl apply -f kubernetes/
```

---

## 5. Verify Deployment

```bash
kubectl get pods

kubectl get svc

kubectl get ingress
```

---

## Kubernetes Resources

The project deploys:

- Namespace
- Backend Deployment
- Frontend Deployment
- ClusterIP Services
- Ingress
- AWS Application Load Balancer

---

# CI/CD Pipeline

GitHub Actions automatically performs:

- Checkout source code
- Build application
- Validate Kubernetes manifests
- Deploy to Amazon EKS
- Verify deployment status

---

# Health Checks

Backend health endpoint:

```
/health
```

The AWS Application Load Balancer continuously checks application health before routing traffic.

---

# Skills Demonstrated

- Docker Containerization
- Kubernetes
- Amazon EKS
- AWS Load Balancer Controller
- Ingress Configuration
- Cloud Networking
- DevOps Automation
- GitHub Actions
- Production Application Deployment
- Infrastructure Integration
- Microservices Deployment
- CI/CD

---

# Related Repository

Infrastructure for this application is managed separately using Terraform.

Repository:

**starttech-infra**

This repository provisions:

- Amazon VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- IAM Roles
- Amazon EKS Cluster
- Managed Node Groups
- Networking
- Security Groups

The infrastructure is deployed before the application and serves as the cloud foundation for this project.

---

# Future Improvements

- HTTPS using AWS Certificate Manager
- Route53 Custom Domain
- Horizontal Pod Autoscaler
- Prometheus Monitoring
- Grafana Dashboards
- ArgoCD GitOps
- Helm Charts
- External Secrets Manager
- Blue/Green Deployments
- Canary Deployments

---

# License

This project is for educational and portfolio purposes.

---

# Author

**James Afolabi**

*Systems Engineer | Cloud Engineer | Industrial Automation Engineer | Industrial IoT*

🌍 **Location:** Nigeria

💼 **LinkedIn:** https://www.linkedin.com/in/afolabijames/

🐙 **GitHub:** https://github.com/Afolabiamez