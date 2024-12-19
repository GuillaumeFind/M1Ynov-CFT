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
  region = "eu-west-1"
}

# Target Group
resource "aws_lb_target_group" "RTT-TargetGroup" {
  name        = "RTT-TargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

# Load Balancer
resource "aws_lb" "RTT-LoadBalancer" {
  name               = "RTT-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.RTT-SecurityGroup.id]
  subnets            = var.subnet_ids

  tags = {
    Name = "RTT-LoadBalancer"
  }
}

# Listener for Load Balancer
resource "aws_lb_listener" "RTT-Listener" {
  load_balancer_arn = aws_lb.RTT-LoadBalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.RTT-TargetGroup.arn
  }
}

# Launch Template
resource "aws_launch_template" "RTT-LaunchTemplate" {
  name          = "RTT-LaunchTemplate"
  image_id      = var.ami_id
  vpc_security_group_ids	= [aws_security_group.RTT-SecurityGroup.id]
  instance_type = var.instance_type
  key_name		= "RTT-Keypair"

  tags = {
    Name = "RTT-LaunchTemplate"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "RTT-AutoScaling" {
  launch_template {
    id      = aws_launch_template.RTT-LaunchTemplate.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2

  target_group_arns = [aws_lb_target_group.RTT-TargetGroup.arn]

  tag {
    key                 = "Name"
    value               = "RTT-AutoScaling"
    propagate_at_launch = true
  }
  
  instance_refresh {
   strategy = "Rolling"
   preferences {
    min_healthy_percentage = 50
   }
   triggers = ["launch_template"]
  }
}

# Security Group
resource "aws_security_group" "RTT-SecurityGroup" {
  name        = "RTT-SecurityGroup"
  description = "Security group for RTT Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	
  }	
  
  ingress {
    from_port   = 22
    to_port     = 22
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
