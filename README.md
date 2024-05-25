
# AWS Infrastructure Setup with Terraform

This project provides a Terraform configuration to set up an AWS cloud infrastructure. The setup includes a Virtual Private Cloud (VPC), public and private subnets, an Internet Gateway, a NAT Gateway, security groups, and two EC2 instances (one in the public subnet with an Apache web server and one in the private subnet).

## Project Structure

- **Variables**: Defines configurable parameters like AWS region, CIDR blocks, and instance types.
- **Provider**: Configures the AWS provider with the specified region.
- **Resources**: Creates the necessary AWS resources including VPC, subnets, Internet Gateway, route tables, NAT Gateway, security groups, and EC2 instances.

## Resources

- **VPC**: Creates a VPC with the specified CIDR block.
- **Subnets**: Creates a public and a private subnet.
- **Internet Gateway**: Allows internet access for the VPC.
- **Route Tables**: Sets up route tables for the public and private subnets.
- **NAT Gateway**: Enables internet access for instances in the private subnet.
- **Security Groups**: Defines security groups for the public and private instances.
- **EC2 Instances**: Launches a public EC2 instance with an Apache web server and a private EC2 instance.

## Usage

### Prerequisites

- Terraform installed on your local machine.
- AWS credentials configured on your local machine.

### Steps

1. **Clone the Repository**

   ```sh
   git clone https://github.com/mahatahoon/Terraform-Project.git
   cd your-repository
   ```

2. **Initialize Terraform**

   ```sh
   terraform init
   ```

3. **Plan the Deployment**

   ```sh
   terraform plan
   ```

4. **Apply the Configuration**

   ```sh
   terraform apply
   ```

5. **Verify the Deployment**

   After applying the configuration, you can log in to your AWS Management Console to verify that the resources have been created successfully.

## Configuration Details

### Variables

- **aws_region**: AWS region (default: "us-east-1")
- **vpc_cidr**: CIDR block for the VPC (default: "10.0.0.0/16")
- **public_subnet_cidr**: CIDR block for the public subnet (default: "10.0.0.0/24")
- **private_subnet_cidr**: CIDR block for the private subnet (default: "10.0.1.0/24")
- **public_instance_type**: Instance type for the public EC2 instance (default: "t2.micro")
- **private_instance_type**: Instance type for the private EC2 instance (default: "t2.micro")

### Resources

- **VPC**
- **Subnets**
- **Internet Gateway**
- **Route Tables**
- **NAT Gateway**
- **Security Groups**
- **EC2 Instances**

### EC2 Instance User Data

The public EC2 instance user data script installs and starts an Apache web server:

```bash
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl restart httpd
```

#
