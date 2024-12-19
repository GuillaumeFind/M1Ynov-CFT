variable "vpc_id" {
  description = "ID du VPC à utiliser"
  type        = string
  default     = "vpc-0035b5ae8bbbefd3f"
}

variable "subnet_ids" {
  description = "Liste des subnets à utiliser"
  type        = list(string)
  default     = [
    "subnet-0655f72c900baddc5", # eu-west-1c
    "subnet-02ae3d0545ef9967e", # eu-west-1a
    "subnet-01bac5268bd103c55"  # eu-west-1b
  ]
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser pour les instances"
  type        = string
  default     = "ami-0413fd2f91ed1fbd1"
}

variable "instance_type" {
  description = "Type d'instance à utiliser"
  type        = string
  default     = "t2.micro"
}
