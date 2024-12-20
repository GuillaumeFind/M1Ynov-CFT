# Variables des IDs des AMIs
variable "public_ami_id" {
  description = "ID de l'AMI pour l'instance publique"
  type        = string
}

variable "private_ami_id" {
  description = "ID de l'AMI pour l'instance privée"
  type        = string
}

# Customer Gateway ID pour le VPN
#variable "customer_gateway_id" {
#  description = "ID de la passerelle client pour le VPN"
#  type        = string
#}
