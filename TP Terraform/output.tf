output "load_balancer_dns" {
  description = "Nom DNS du Load Balancer"
  value       = aws_lb.RTT-LoadBalancer.dns_name
}

output "autoscaling_group_arn" {
  description = "ARN du groupe Auto Scaling"
  value       = aws_autoscaling_group.RTT-AutoScaling.arn
}
