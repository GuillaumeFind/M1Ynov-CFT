# Documentation pour la création d'une infrastructure AWS avec Terraform

## Objectif du projet

Ce projet consiste à créer une infrastructure AWS avec les caractéristiques suivantes :

1. Un Virtual Private Cloud (VPC).
2. Un subnet public et un subnet privé.
3. Une instance EC2 dans le subnet public (bastion).
4. Une instance EC2 dans le subnet privé avec CozyCloud installé.
5. L'accès à l'instance EC2 privée sera uniquement possible via l'instance bastion dans le subnet public.
6. Création d'AMIs pour le bastion et pour l'instance avec CozyCloud, utilisées pour un déploiement automatisé via Terraform.

Toutes les ressources devront être nommées avec le préfixe `CFT-` et seront déployées dans la région `us-west-3`.

---

## Prérequis

1. **AWS CLI** installé et configuré avec les bonnes permissions.
2. **Terraform** installé.
3. Un fichier de configuration AWS avec des credentials valides.
4. Un accès au compte AWS avec les permissions nécessaires pour créer des ressources.
5. Une clé SSH pour se connecter aux instances EC2.

---

## Étapes de mise en place avec Terraform

### 1. Initialisation de Terraform
Créez un fichier `main.tf` pour définir les ressources. Initialisez le projet avec :

terraform init
```

### 2. Création du VPC
Ajoutez une ressource VPC dans votre fichier Terraform :
```hcl
resource "aws_vpc" "CFT_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "CFT-VPC"
  }
}
```

### 3. Création des subnets
#### Subnet public
```hcl
resource "aws_subnet" "CFT_public_subnet" {
  vpc_id                  = aws_vpc.CFT_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-3a"
  tags = {
    Name = "CFT-Public-Subnet"
  }
}
```
#### Subnet privé
```hcl
resource "aws_subnet" "CFT_private_subnet" {
  vpc_id            = aws_vpc.CFT_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-3a"
  tags = {
    Name = "CFT-Private-Subnet"
  }
}
```

### 4. Création de la gateway Internet et table de routage pour le subnet public
#### Gateway Internet
```hcl
resource "aws_internet_gateway" "CFT_igw" {
  vpc_id = aws_vpc.CFT_vpc.id
  tags = {
    Name = "CFT-Internet-Gateway"
  }
}
```
#### Table de routage
```hcl
resource "aws_route_table" "CFT_public_route_table" {
  vpc_id = aws_vpc.CFT_vpc.id
  tags = {
    Name = "CFT-Public-Route-Table"
  }
}

resource "aws_route" "CFT_public_route" {
  route_table_id         = aws_route_table.CFT_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.CFT_igw.id
}

resource "aws_route_table_association" "CFT_public_subnet_association" {
  subnet_id      = aws_subnet.CFT_public_subnet.id
  route_table_id = aws_route_table.CFT_public_route_table.id
}
```

### 5. Création des instances EC2
#### Instance bastion (subnet public)
```hcl
resource "aws_instance" "CFT_bastion" {
  ami           = "ami-08fb0cc3789468f4d" # Remplacez par une AMI valide
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.CFT_public_subnet.id
  key_name      = "your-key-name" # Remplacez par votre clé SSH
  tags = {
    Name = "CFT-Bastion"
  }
}
```
#### Instance privée (subnet privé)
```hcl
resource "aws_instance" "CFT_private_instance" {
  ami           = "ami-87654321" # Remplacez par une AMI valide
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.CFT_private_subnet.id
  tags = {
    Name = "CFT-Private-Instance"
  }
}
```

### 6. Connexion au bastion et transformation en machine de rebond
1. Connectez-vous à l'instance bastion :
   
   ssh -i your-key.pem ec2-user@<public-ip-bastion>
   ```
2. Configurez l'accès SSH pour l'instance privée via le bastion :
   
   ssh -i your-key.pem -J ec2-user@<public-ip-bastion> ec2-user@<private-ip-instance>
   ```

### 7. Création des AMIs
#### AMI pour le bastion
```hcl
resource "aws_ami_from_instance" "CFT_bastion_ami" {
  source_instance_id = aws_instance.CFT_bastion.id
  name               = "CFT-Bastion-AMI"
}
```
#### AMI pour l'instance CozyCloud
Une fois que l'équipe a configuré CozyCloud sur l'instance privée, utilisez une ressource similaire :
```hcl
resource "aws_ami_from_instance" "CFT_cozycloud_ami" {
  source_instance_id = aws_instance.CFT_private_instance.id
  name               = "CFT-CozyCloud-AMI"
}

---
