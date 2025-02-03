# Projet Infrastructure Cloud - CozyCloud Sécurisé

## Table des Matières
1. [Organisation du Projet](#organisation-du-projet)
2. [Architecture](#architecture)
3. [Prérequis](#prérequis)
4. [Structure du Code](#structure-du-code)
5. [Installation et Déploiement](#installation-et-déploiement)
6. [Sécurité](#sécurité)

## Organisation du Projet

### Gestion de Version avec Git
- **Repository**: [https://github.com/GuillaumeFind/M1Ynov-CFT/](https://github.com/GuillaumeFind/M1Ynov-CFT/)
- **Branches**:
  - `main`: Branch de production
  - `dev`: Branch de développement

### Étapes de Développement
1. **Phase Initiale**: Infrastructure simple
   - VPC avec réseaux public
   - VPC avec réseaux privé
   - Instance EC2 pour CozyCloud (réseau privé) 
   - Instance EC2 pour Bastion (réseau public)

2. **Création d'AMI Base**
   - Installation automatisée de CozyCloud
   - Tests d'intégration

3. **Intégration OnlyOffice**
   - Installation et configuration de l'addon
   - Création d'une AMI finale

4. **Sécurisation de l'Infrastructure**
   - Mise en place d'un bastion host
   - Migration de CozyCloud vers le réseau privé
   - Configuration VPN

## Architecture

### Infrastructure Réseau
- **VPC Public (Bastion)**
  - CIDR: Variable (`var.public_vpc_cidr`)
  - Subnet public pour le bastion
  - Internet Gateway
  - Security Group dédié

- **VPC Privé (CozyCloud)**
  - CIDR: Variable (`var.private_vpc_cidr`)
  - Subnet privé pour CozyCloud
  - Pas d'accès direct à Internet
  - Security Group restrictif

### Connectivité
- VPC Peering entre les VPCs
- Bastion accessible via SSH (port 22)
- OpenVPN sur le bastion (port 1194)
- CozyCloud accessible uniquement via le bastion:
  - HTTP (80)
  - HTTPS (443)

## Prérequis
- AWS CLI configuré
- Terraform >= 1.2.0
- Key pair AWS
- AMIs préparées pour:
  - Bastion 
  - CozyCloud avec OnlyOffice

## Structure du Code

```plaintext
.
├── main.tf          # Configuration principale
├── variables.tf     # Déclaration des variables
└── outputs.tf       # Sorties d'information
```

### Convention de Nommage
Toutes les ressources sont préfixées avec "CFT-" suivant les standards du projet.

## Installation et Déploiement

1. **Préparation**
```bash
# Cloner le repository
git clone https://github.com/GuillaumeFind/M1Ynov-CFT/
cd M1Ynov-CFT

2. **Déploiement**
```bash
terraform init
terraform plan
terraform apply
```

## Sécurité

### Bastion Host
- Accès SSH public limité au bastion
- OpenVPN pour l'accès sécurisé
- Security group restrictif

### CozyCloud
- Pas d'accès direct depuis Internet
- Accès uniquement via le bastion
- Trafic sortant limité au VPC public
- Ports ouverts minimaux (80, 443, 22)

### Post-Déploiement
1. Configuration OpenVPN sur le bastion
2. Vérification des accès
3. Configuration SSL pour CozyCloud

---
Projet réalisé dans le cadre du module Infrastructure Cloud - M1 Ynov
