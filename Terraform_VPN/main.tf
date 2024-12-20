terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "public_vpc" {
  cidr_block           = var.public_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CFT-public-vpc"
  }
}

resource "aws_vpc" "private_vpc" {
  cidr_block           = var.private_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CFT-private-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "CFT-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.private_vpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "CFT-private-subnet"
  }
}

resource "aws_instance" "public_instance" {
  ami                    = var.public_instance_ami
  instance_type          = var.public_instance_type
  subnet_id              = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "CFT-public-instance"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.private_instance_ami
  instance_type = var.private_instance_type
  subnet_id     = aws_subnet.private_subnet.id
  tags = {
    Name = "CFT-private-instance"
  }
}