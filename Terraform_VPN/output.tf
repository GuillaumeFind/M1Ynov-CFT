output "public_instance_id" {
  description = "ID of the public instance"
  value       = aws_instance.public_instance.id
}

output "private_instance_id" {
  description = "ID of the private instance"
  value       = aws_instance.private_instance.id
}

output "public_vpc_id" {
  description = "ID of the public VPC"
  value       = aws_vpc.public_vpc.id
}

output "private_vpc_id" {
  description = "ID of the private VPC"
  value       = aws_vpc.private_vpc.id
}

output "vpn_connection_id" {
  description = "ID of the VPN connection"
  value       = aws_vpn_connection.vpn_connection.id
}
