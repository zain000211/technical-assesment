# README: Using Terraform for AWS Infrastructure  

This README provides instructions on how to use Terraform to deploy and manage the AWS infrastructure using modular design principles. It ensures reusability, organization, and maintainability of the infrastructure as code.

---

## **Prerequisites**

1. **Tools Installed**:  
   - [Terraform](https://www.terraform.io/downloads.html) (v1.3 or later recommended)  
   - [AWS CLI](https://aws.amazon.com/cli/) (v2 recommended)  
   - Git  

2. **AWS Account Credentials**:  
   - Configure AWS CLI using:  
     ```bash
     aws configure
     ```
   - Ensure your IAM user/role has the necessary permissions for resource creation.

3. **Backend Configuration** (Optional):  
   - If you're using a remote backend (e.g., S3 for storing state files), ensure the backend bucket is created and configured.
    
4. **Initialize Terraform**
   - Run the following command to initialize Terraform and download the required providers and modules:   
     ```bash
     terraform init
     ```

6. **Plan the Infrastructure**:  
   - Generate and review the execution plan to see what resources will be created:
     ```bash
     terraform plan
     ```
7. **Apply the Infrastructure**:  
   - Apply the infrastructure changes to create resources:
     ```bash
     terraform apply
     ```
8. **Apply the Specific module**:  
   - Apply some specific modules to create resources:
     ```bash
     terraform plan -target=module.module_name.resource_block.name
     ```
   - Example
     ```bash
     terraform plan -target=module.vpc.aws_vpc.main
     terraform apply -target=module.vpc.aws_vpc.main
     ```
      
---

## **Project Structure**

The infrastructure uses a modular approach to organize Terraform code. The directory structure looks like this:

```plaintext
├── main.tf                # Entry point for Terraform
├── variables.tf           # Global variables
├── outputs.tf             # Outputs for the root module
├── terraform.tfvars       # Variable values for the environment
├── modules/
│   ├── vpc/               # Module for creating VPC
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── sg/                # Module for Security Group
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── alb/               # Module for ALB
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── s3/                # Module for S3 Buckets
│       ├── main.tf
│       ├── variables.tf
│   ├── iam/               # Module for Iam Roles and policies
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── ecr/               # Module for ECR
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── rds/               # Module for RDS Instances
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── ecs/               # Module for ECS Cluster
│       ├── main.tf
│       ├── variables.tf
│   ├── ecs_service/       # Module for ECS Service
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── ecs_scaling/       # Module for ECS Scaling
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── route53/           # Module for Route53
│       ├── main.tf
│       ├── variables.tf
│   ├── acm/               # Module for ACM
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── cloudfront/        # Module for Cloudfront
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── waf/               # Module for WAF
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── route53_failover/  # Module for Route53 failover
│       ├── main.tf
│       ├── variables.tf
