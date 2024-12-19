# Plan du projet #

Ce projet termine le module **Infrastructure Cloud** du semestre 1.

## 1. Premiere étape : Git

Nous devons nous familiariser avec l'outil Git pour  voir le *versionning* de notre code.
Nous avons choisi GitHub pour centraliser le code et la documentation réalisée au cours de ce projet.

Aucun des membres du groupe n'a de l'experience quant à l'utilisation de cet outil. Par conséquent, nous avons pris du temps pour nous l'approprier : gérer les *fetch*, *pull*, *commit*, et *merge*.

Le *repository* utilisé est le suivant : https://github.com/GuillaumeFind/M1Ynov-CFT/

Nous avons créer deux branches dans ce dernier :
- **main**
- **dev**

Nous travaillons principalement sur la branche dev, après test du code terraform sur AWS, la branche dev est merged vers main.

## 2. Deuxième étape : Organisation du projet

Pour mener à bien le projet, nous avons décidé de procéder par étapes :

1. Nous commençons par une infrastructure simple : un VPC créé à la main composé d'un réseau public et privé avec une instance EC2 située dans le réseau public qui hebergera CozyCloud.
2. Nous créeons une AMI de CozyCloud pour automatiser l'installation du cloud privé avec son infrastructure. Ensuite, l'AMI nous servira de base pour tester l'intégration du module OnlyOffice.
3. Une fois l'instance EC2 CozyCloud avec l'addon OnlyOffice d'installé et fonctionnel, nous créons une seconde AMI qui sera notre nouvelle base de test.
4. Après cela, nous continuons à améliorer la sécurité de notre infrastructure : nous créons un bastion dans le réseau public qui fera l'intermédiaire pour accèder à l'instance EC2 avec CozyCloud, située dans le réseau privée désormais.

Nous utilisons Terraform pour créer l'infrastructure supportant CozyCloud.

**Chaque ressource créée par le groupe sera précédée du trigramme "CFT"**.