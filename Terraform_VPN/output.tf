# Affichage des informations sur les ressources créées
output "public_vpc_id" {
  description = "ID du VPC public"
  value       = aws_vpc.public_vpc.id
}

output "private_vpc_id" {
  description = "ID du VPC privé"
  value       = aws_vpc.private_vpc.id
}

output "public_instance_id" {
  description = "ID de l'instance publique"
  value       = aws_instance.public_instance.id
}

output "private_instance_id" {
  description = "ID de l'instance privée"
  value       = aws_instance.private_instance.id
}

#output "vpn_connection_id" {
#  description = "ID de la connexion VPN"
#  value       = aws_vpn_connection.vpn.id
#}
