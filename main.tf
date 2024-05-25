variable "aws_region" {
  default     = "us-east-1"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  default     = "10.0.1.0/24"
}

variable "public_instance_type" {
  default     = "t2.micro"
}

variable "private_instance_type" {
  default     = "t2.micro"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.public_subnet_cidr
  
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.private_subnet_cidr
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.example.id

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.example.id

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  
  }
}

resource "aws_instance" "public_ec2" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = var.public_instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl restart httpd
  EOF
  tags = {
    Name = "ec2_apach"
  }
}

resource "aws_instance" "private_ec2" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = var.private_instance_type
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = {
    Name = "ec2"
  }

 
}