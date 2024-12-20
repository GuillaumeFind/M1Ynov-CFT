variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "public_vpc_cidr" {
  description = "CIDR block for the public VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_vpc_cidr" {
  description = "CIDR block for the private VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for subnets"
  type        = string
  default     = "us-east-1a"
}

variable "public_instance_ami" {
  description = "AMI ID for the public instance"
  type        = string
}

variable "private_instance_ami" {
  description = "AMI ID for the private instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "customer_gateway_id" {
  description = "ID of the customer gateway"
  type        = string
}

variable "vpn_gateway_id" {
  description = "ID of the VPN gateway"
  type        = string
}
