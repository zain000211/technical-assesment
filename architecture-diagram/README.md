# KnowledgeCity AWS Infrastructure Documentation

This document outlines the infrastructure design and implementation for KnowledgeCity's ecosystem. The infrastructure ensures **high availability**, **security**, and **efficiency** while supporting the diverse applications and services of the organization.

---

## **Infrastructure Objective**

The objective is to implement a **secure**, **highly available (99.99%)**, **geographically redundant**, and **cost-optimized** infrastructure on AWS. This infrastructure supports KnowledgeCity's applications and services, including:
- Front-end SPAs
- A monolithic PHP API
- A reporting microservice
- A media server

---

## **Requirements Addressed**

### **1. High Availability (99.99%)**
- Multi-region setup with failover between the **Primary Region (Saudi Arabia)** and the **Secondary Region**.
- ECS Clusters in both regions with **auto-scaling**.
- **Load Balancers** to distribute traffic evenly.
- Master-slave database replication for **MySQL** and **ClickHouse**.

### **2. Encrypted Video Traffic**
- Python-based media server for **video encryption**.
- Enforced encryption for all traffic using **SSL/TLS**.
- Encrypted video storage in **Amazon S3** with **AWS Key Management Service (KMS)** integration.

### **3. Fast Static Content Delivery**
- **Amazon CloudFront** integrated with S3 for globally distributed static content delivery.
- **Low-latency caching** using regional edge locations.

### **4. Geographical Redundancy**
- **Synchronization between regions:**
  - S3 Replication for media and static assets.
  - Database replication for MySQL and ClickHouse.
- **VPC Peering** for secure communication between regions.

### **5. Encapsulated Databases**
- Support for isolated MySQL databases using **Amazon RDS**.
- Dedicated ClickHouse instances for special clients hosted within private subnets.

### **6. Cost Optimization**
- Optimized use of **on-demand** and **reserved instances**.
- **Auto-scaling** to handle variable workloads.
- Use of managed services like **ECS**, **CloudFront**, and **RDS** to reduce operational overhead.

---

## **Infrastructure Architecture**

### **1. Components Overview**

#### **Frontend Applications**
- Two SPAs:
  - **React SPA**
  - **Svelte SPA**
- Hosted on **Amazon ECS** clusters in both regions.
- Accessed via **CloudFront** for improved performance and scalability.

#### **Backend Services**
- Monolithic PHP API hosted in **ECS**.
- MySQL database backend using **Amazon RDS**.
- Reporting microservice leveraging **ClickHouse** database.

#### **Media Server**
- Python-based video encryption server deployed on **ECS**.
- Integrated with S3 buckets for storing encrypted video assets.

#### **Databases**
- **Amazon RDS (MySQL):**
  - Master database in the primary region.
  - Replicated slave database in the secondary region.
- **ClickHouse Database:**
  - Dedicated instances for analytics and reporting.

---

### **2. Key AWS Services and Features**

| **Service**         | **Purpose**                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| **Amazon ECS**       | To host containerized applications (frontend, backend, microservices).     |
| **Amazon S3**        | To store and replicate static assets and encrypted video content.          |
| **Amazon CloudFront**| To deliver static content with low latency using global edge locations.    |
| **Amazon RDS**       | To host encapsulated and replicated MySQL databases.                      |
| **ClickHouse**       | To provide fast analytical reporting capabilities.                        |
| **AWS Route 53**     | For DNS management and routing traffic to appropriate regions.            |
| **Elastic Load Balancer**| To distribute traffic across ECS tasks and ensure availability.       |
| **AWS KMS**          | To handle encryption for videos and sensitive data.                       |
| **VPC Peering**      | To connect primary and secondary region VPCs for secure communication.    |

---

## **Design Choices**

### **1. High Availability**
- ECS **Auto-Scaling** ensures application tasks scale dynamically based on demand.
- Primary and secondary regions synchronized to handle **failover** scenarios.
- **Load Balancers** in each region for efficient traffic distribution.

### **2. Security**
- **SSL/TLS encryption** for all traffic.
- Encrypted storage for all data in S3 and RDS.
- Private subnets for sensitive resources like databases.

### **3. Performance**
- Use of **CloudFront** ensures minimal latency for global users.
- S3 Lifecycle Policies to manage storage costs for media assets.

### **4. Geographical Redundancy**
- Synchronized S3 buckets and databases across regions for seamless failover.

### **5. Cost Optimization**
- Reserved Instances for predictable workloads.
- Spot Instances for media server tasks with flexible timing.

---

## **Workflow and Data Flow**

1. **Frontend Applications:**
   - User traffic is routed through **Route 53**.
   - Requests are cached and delivered by **CloudFront**, reducing backend load.
   - SPAs communicate with backend APIs hosted in **ECS**.

2. **Backend API:**
   - Hosted in ECS clusters, the PHP API processes requests and interacts with **RDS** for data.
   - Microservices provide reporting via the **ClickHouse** database.

3. **Media Server:**
   - Python scripts process video uploads and encrypt them.
   - Encrypted videos are stored in **S3 buckets**, replicated across regions.

4. **Databases:**
   - MySQL in RDS handles transactional data.
   - ClickHouse processes analytics and reporting requests.

5. **Failover:**
   - If the primary region becomes unavailable, **Route 53** redirects traffic to the secondary region.

---

## **Disaster Recovery Plan**

- **Database Failover:** RDS automatically promotes the secondary MySQL instance as the new primary.
- **Application Failover:** ECS tasks in the secondary region become active nodes.
- **S3 Data Redundancy:** S3 replication ensures minimal data loss.

---

## **Cost Estimate**

The infrastructure is designed to fit within a **$16,000 monthly budget**. Key cost optimizations include:
- Reserved Instances for predictable workloads.
- S3 Intelligent Tiering to reduce storage costs.
- Spot Instances for non-critical, flexible workloads.
