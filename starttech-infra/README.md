# StartTech Full-Stack Deployment on AWS

An end-to-end cloud-native deployment project that provisions and manages a production-style infrastructure on AWS using Terraform, Amazon EKS, Redis, ECR, and the AWS Load Balancer Controller.

This project demonstrates Infrastructure as Code (IaC), Kubernetes orchestration, containerized application deployment, networking, security group management, and managed cloud services.

---

## Architecture Overview

The infrastructure provisions:

- Custom VPC across multiple Availability Zones
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables and Associations
- Amazon EKS Cluster
- EKS Managed Node Group
- IAM Roles and Policies
- AWS Load Balancer Controller
- Amazon ElastiCache Redis
- Amazon ECR Repository
- Security Groups and Security Group Rules

---

## Architecture Diagram

```text
                                      Internet
                                          │
                                          │
                                  GitHub Actions
                                          │
                                          │
                                  Terraform Apply
                                          │
                                          ▼
                              ┌──────────────────────┐
                              │      AWS Account     │
                              └──────────────────────┘
                                          │
                                          ▼
                        ┌────────────────────────────────┐
                        │          Amazon VPC            │
                        │          10.0.0.0/16           │
                        └────────────────────────────────┘
                               │                  │
                 ┌─────────────┘                  └─────────────┐
                 │                                              │
                 ▼                                              ▼
      ┌────────────────────┐                      ┌────────────────────┐
      │ Public Subnet A    │                      │ Public Subnet B    │
      │ 10.0.1.0/24        │                      │ 10.0.2.0/24        │
      └────────────────────┘                      └────────────────────┘
                 │                                              │
                 ├───────────────┐              ┌───────────────┤
                 │               │              │               │
                 ▼               ▼              ▼               ▼
          Internet Gateway    NAT Gateway    EKS Control Plane
                 │
                 │
─────────────────┼────────────────────────────────────────────────────
                 │
                 ▼
      ┌────────────────────┐                      ┌────────────────────┐
      │ Private Subnet A   │                      │ Private Subnet B   │
      │ 10.0.3.0/24        │                      │ 10.0.4.0/24        │
      └────────────────────┘                      └────────────────────┘
                 │                                              │
                 └──────────────────┬───────────────────────────┘
                                    │
                                    ▼
                        Amazon EKS Worker Nodes
                                    │
                                    ▼
                          Kubernetes Cluster
```


## Features

- Provision AWS infrastructure using Terraform
- Deploy a highly available Amazon EKS cluster
- Private networking with public and private subnets
- Managed Redis cache using Amazon ElastiCache
- Private container registry using Amazon ECR
- AWS Load Balancer Controller integration
- Modular Terraform architecture
- Production-inspired security group design
- Easily reproducible infrastructure

## Technologies Used

### Cloud

- AWS
- Amazon EKS
- Amazon ECR
- Amazon ElastiCache Redis
- Amazon VPC
- IAM
- Security Groups

### Infrastructure as Code

- Terraform

### Containers & Orchestration

- Docker
- Kubernetes
- AWS Load Balancer Controller

### CI/CD *(Future Enhancement)*

- GitHub Actions

starttech-infra/
│
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   │
│   ├── modules/
│   │   ├── eks/
│   │   ├── database/
│   │   └── ecr/
│
├── kubernetes/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
│
├── diagrams/
│   └── architecture.png
│
└── README.md

## Infrastructure Modules

### VPC Module

Creates:

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations
- Elastic IP
- NAT Gateway

---

### EKS Module

Creates:

- Amazon EKS Cluster
- Managed Node Group
- IAM Roles
- IAM Policy Attachments
- OIDC Provider
- AWS Load Balancer Controller IAM Role
- Cluster Security Group
- Worker Node Security Group
- ALB Security Group
- Security Group Rules

---

### Database Module

Creates:

- Amazon ElastiCache Redis Cluster
- Redis Subnet Group
- Redis Security Group
- Redis Security Group Rules

---

### ECR Module

Creates:
- Backend Container Repository
- Amazon Elastic Container Registry (ECR) Repository

### Security Design

#### Security groups are configured to allow:

| Source            | Destination  | Port                 |
| ----------------- | ------------ | -------------------- |
| ALB               | Worker Nodes | NodePort Range       |
| EKS Nodes         | Redis        | 6379                 |
| EKS Control Plane | Nodes        | 1025–65535           |
| Nodes             | Nodes        | All Internal Traffic |


---

## 🚀 Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/Afolabiamez/Go-Full-Stack-Deployment.git
cd Go-Full-Stack-Deployment/terraform
```

---

### 2. Initialize Terraform

Download the required Terraform providers and initialize the working directory.

```bash
terraform init
```

---

### 3. Validate the Configuration (Optional)

Validate that the Terraform configuration is syntactically correct.

```bash
terraform validate
```

---

### 4. Review the Execution Plan

Preview the infrastructure changes before deployment.

```bash
terraform plan
```

---

### 5. Deploy the Infrastructure

Provision the AWS infrastructure.

```bash
terraform apply
```

Type:

```text
yes
```

when prompted.

---

### 6. View Terraform Outputs

Display useful infrastructure information such as the EKS endpoint, VPC ID, subnet IDs, Redis endpoint, and security groups.

```bash
terraform output
```

---

### 7. Destroy the Infrastructure (Optional)

Remove all resources created by Terraform.

```bash
terraform destroy
```

## Outputs

After deployment, Terraform exposes the following outputs:

- VPC ID
- Public Subnet IDs
- Private Subnet IDs
- EKS Cluster Endpoint
- EKS Cluster Name
- Redis Endpoint
- Redis Port
- ECR Repository URL
- Security Group IDs

---

## Challenges Solved During This Project

During development, several real-world infrastructure challenges were encountered and resolved:

- Reconciling Terraform state with manually updated AWS infrastructure
- Importing existing AWS resources into Terraform state
- Managing Security Group rules without resource replacement
- Configuring networking for Amazon EKS
- Enabling Redis connectivity from Kubernetes worker nodes
- Deploying and configuring the AWS Load Balancer Controller
- Managing infrastructure drift between AWS and Terraform
- Troubleshooting Terraform dependency and state conflicts

---

## Future Improvements

Planned enhancements for this project include:

- GitHub Actions CI/CD pipeline
- Helm charts for Kubernetes deployments
- Argo CD GitOps workflow
- Prometheus and Grafana monitoring
- CloudWatch logging
- Horizontal Pod Autoscaler (HPA)
- ExternalDNS integration
- SSL/TLS termination with AWS Certificate Manager
- Blue/Green deployment strategy

---

## Learning Outcomes

This project provided hands-on experience with:

- Infrastructure as Code using Terraform
- Amazon EKS and Kubernetes
- AWS networking (VPC, Subnets, Route Tables, NAT Gateway)
- IAM Roles and Policies
- AWS Security Groups
- Amazon ElastiCache (Redis)
- Amazon ECR
- Kubernetes Ingress and AWS Load Balancer Controller
- Terraform state management
- Infrastructure debugging and troubleshooting
- Production-style cloud architecture

---

## Author

**James Afolabi**

Systems Engineer | Cloud Engineer | Industrial Automation Engineer | Industrial IoT

- 🌍 Location: Nigeria
- 💼 LinkedIn: https://www.linkedin.com/in/afolabijames/
- 🐙 GitHub: https://github.com/Afolabiamez

---