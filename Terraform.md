provider "aws" {
  region = "us-west-3"
  # Configure le fournisseur AWS pour la région us-west-3
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Plage d'adresses CIDR pour le VPC
  enable_dns_support   = true           # Activer le support DNS
  enable_dns_hostnames = true          # Activer les noms d'hôte DNS
  tags = {
    Name = "CFT-main-vpc" # Nom pour identifier le VPC
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24" # Sous-réseau public
  availability_zone       = "us-west-3a" # Zone de disponibilité
  map_public_ip_on_launch = true          # Attribuer une IP publique aux instances
  tags = {
    Name = "CFT-public-subnet" # Nom pour identifier le sous-réseau public
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24" # Sous-réseau privé
  availability_zone = "us-west-3b" # Zone de disponibilité
  tags = {
    Name = "CFT-private-subnet" # Nom pour identifier le sous-réseau privé
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80 # Port HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Autorise les connexions HTTP de n'importe où
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Autorise tout le trafic sortant
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CFT-alb-sg" # Nom pour identifier le groupe de sécurité ALB
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22 # Port SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Autorise SSH de n'importe où (à restreindre en production)
  }

  ingress {
    from_port   = 80 # Port HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Autorise tout le trafic sortant
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CFT-ec2-sg" # Nom pour identifier le groupe de sécurité EC2
  }
}

resource "aws_instance" "cozycloud" {
  ami           = "ami-12345678" # Remplacer par l'AMI CozyCloud
  instance_type = "t2.micro"     # Type d'instance
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "CFT-cozycloud-instance" # Nom pour identifier l'instance EC2 CozyCloud
  }
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "cft-data-bucket-${random_id.bucket_id.hex}" # Nom unique pour le bucket S3

  tags = {
    Name = "CFT-data-bucket" # Nom pour identifier le bucket S3
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8 # Génère un identifiant unique pour le bucket
}

resource "aws_launch_configuration" "app" {
  name          = "CFT-app-lc" # Nom de la configuration de lancement
  image_id      = "ami-12345678" # Remplacer par l'AMI appropriée
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true # Associe une IP publique aux instances

  lifecycle {
    create_before_destroy = true # Assure une mise à jour sans interruption
  }
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  vpc_zone_identifier  = [aws_subnet.public.id]
  min_size             = 2 # Nombre minimal d'instances
  max_size             = 4 # Nombre maximal d'instances
  desired_capacity     = 2 # Capacité cible

  tags = [
    {
      key                 = "Name"
      value               = "CFT-autoscaling-instance"
      propagate_at_launch = true # Propager les balises aux instances
    }
  ]
}

resource "aws_lb" "app_lb" {
  name               = "CFT-app-lb" # Nom du load balancer
  internal           = false         # Load balancer public
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false # Désactive la protection contre la suppression

  tags = {
    Name = "CFT-app-lb" # Nom pour identifier le load balancer
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "CFT-app-tg" # Nom du groupe cible
  port     = 80           # Port HTTP
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "CFT-app-tg" # Nom pour identifier le groupe cible
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80 # Port HTTP
  protocol          = "HTTP"

  default_action {
    type             = "forward" # Redirige les requêtes vers le groupe cible
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_tg" {
  autoscaling_group_name = aws_autoscaling_group.app.name
  target_group_arn       = aws_lb_target_group.app_tg.arn
  # Attache le groupe d'auto-scaling au groupe cible du load balancer
}
