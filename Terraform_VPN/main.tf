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
  region = "eu-west-3"
}

# Création du premier VPC (public)
resource "aws_vpc" "public_vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "CFT-Public-VPC"
  }
}

# Création du subnet public dans le VPC public
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "CFT-Public-Subnet"
  }
}

# Création d'une passerelle internet pour le VPC public
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.public_vpc.id
  tags = {
    Name = "CFT-Public-IGW"
  }
}

# Création d'une table de routage pour le VPC public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.public_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_igw.id
  }
  tags = {
    Name = "CFT-Public-Route-Table"
  }
}

# Association de la table de routage au subnet public
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group pour l'instance publique
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.public_vpc.id
  name   = "CFT-Public-SG"

  # Autoriser le trafic SSH depuis n'importe où
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le trafic sortant illimité
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CFT-Public-SG"
  }
}

# Création de l'instance EC2 dans le subnet public
resource "aws_instance" "public_instance" {
  ami           = var.public_ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.name]
  tags = {
    Name = "CFT-Public-Instance"
  }
}

# Création du deuxième VPC (privé)
resource "aws_vpc" "private_vpc" {
  cidr_block       = "10.1.0.0/16"
  tags = {
    Name = "CFT-Private-VPC"
  }
}

# Création du subnet privé dans le VPC privé
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.private_vpc.id
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "CFT-Private-Subnet"
  }
}

# Security Group pour l'instance privée
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.private_vpc.id
  name   = "CFT-Private-SG"

  # Autoriser le trafic VPN provenant du subnet public
  ingress {
    from_port   = 1194  # Port OpenVPN par défaut (modifiable selon la configuration)
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

  # Autoriser le trafic sortant illimité
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CFT-Private-SG"
  }
}

# Création de l'instance EC2 dans le subnet privé
resource "aws_instance" "private_instance" {
  ami           = var.private_ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.name]
  tags = {
    Name = "CFT-Private-Instance"
  }
}

# Configuration du VPN (simplifié)
resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = var.customer_gateway_id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "CFT-VPN-Connection"
  }
}

# Configuration du VPN (simplifié)
#resource "aws_vpn_connection" "vpn" {
#  customer_gateway_id = var.customer_gateway_id
#  type                = "ipsec.1"
#  static_routes_only  = true
#  tags = {
#    Name = "CFT-VPN-Connection"
#  }
#}
