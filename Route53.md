***
# Route 53

Route 53 est un service de noms de domaine (DNS) hautement disponible et évolutif proposé par AWS. Il permet de résoudre les noms de domaine en adresses IP et de diriger le trafic internet vers les applications et les services hébergés sur AWS ou sur site.

**Caractéristique clés**

- **Haute disponibilité** : Route 53 est conçu pour offrir une haute disponibilité et une résilience élevées, avec des serveurs répartis dans des zones géographiques différentes.
- **Évolution** : Le service est conçu pour s’adapter aux besoins changeants des entreprises, avec des fonctionnalités telles que la mise en cache DNS, les politiques de routage et les profils de sécurité.
- **Gestion des domaines** : Route 53 permet de gérer des domaines personnalisés et de les allouer à des applications et des services hébergés sur AWS ou sur site.
- **Résolution de noms de domaine** : Le service résout les noms de domaine en adresses IP et dirige le trafic internet vers les destinations ciblées.
- **Politiques de routage** : Route 53 permet de définir des politiques de routage pour diriger le trafic en fonction de la latence, de la région géographique ou de la disponibilité des ressources.


**Type de routage**

- Routage géographique : Route 53 dirige le trafic en fonction de la position géographique des utilisateurs, en prenant en compte la latence et la distance physique.
- Routage de secours : Le service permet de définir des ressources de secours pour assurer la disponibilité des applications et des services en cas d’échec.
- Routage poids : Route 53 permet de définir des poids pour les enregistrements DNS, ce qui permet de répartir le trafic entre plusieurs ressources.

**Intégration avec d'autres services AWS**

- Amazon S3 : Route 53 peut être utilisé pour diriger le trafic vers des objets stockés dans Amazon S3.
- Amazon CloudFront : Le service peut être utilisé pour diriger le trafic vers des distributions CloudFront.
- Application Load Balancer : Route 53 peut être utilisé pour diriger le trafic vers des Application Load Balancer.

**Conclusion**

Amazon **Route 53** est un service de système de noms de domaine (DNS) hautement disponible et évolutif qui permet de résoudre les noms de domaine en adresses IP et de diriger le trafic internet vers les applications et les services hébergés sur AWS ou sur site. Il offre des fonctionnalités telles que la mise en cache DNS, les politiques de routage et les profils de sécurité, ainsi que des intégrations avec d’autres services AWS.
***

## Configuration Route 53

On se dirige sur la page d'accueil, dans la zone de recherche, on tape **Route53**. On arrive sur le Dashboard du service.

![HomePage](/Images/homepage.png)

On clique sur **Hosted zones**

![HostedZone](/Images/clickhosted.png)

On clique sur la zone d'hébergement déja crée par l'autre promo, **tycm2-infra.fr**.

![HostedZones](/Images/selectdns.png)

On va devoir créer deux enregistrements interne au VPC, on devra cocher la case *Private Hoste Zone* : 

- une enregistrement qui va lier notre serveur à un nom de domaine, nous avons choisi le nom de domaine : [cft-czycloud.tycm2-infra.fr](https://cft-cozycloud.tycm2-infra.fr/)

- un alias de notre nom de domaine comme suit : ***.cft-cozycloud.tycm2-infra.fr**

Une fois fini, on retrouve nos enregistrements.

![Record](/Images/endrecord.png)



Pour automatiser notre enregistrement de l'instance CozyCloud, il faut ajouter dans le code terraform cette instruction :

````
resource "aws_route53_record" "example" {
  zone_id = "Z005299313OXEIIBLI6EB"  # Remplacez par l'ID de votre zone hébergée
  name    = "cft-cozycloud.tycm2-infra.fr"  # Remplacez par votre nom de domaine
  type    = "A"
  ttl     = "300"
  records = [aws_instance.cozycloud.private_ip]
}
````
Pour ajouter un CNAME, on fait :

```

resource "aws_route53_record" "example_cname_record" {
  zone_id = "Z005299313OXEIIBLI6EB"  # Remplacez par l'ID de votre zone hébergée
  name    = "*.cft-cozycloud.tycm2-infra.fr"  # Remplacez par votre sous-domaine
  type    = "CNAME"
  ttl     = "300"
  records = ["cft-cozycloud.tycm2-infra.fr"]  # Remplacez par le domaine cible
}
````

Au niveau du Peer Connection, il faut mettre les VPC private & public pour qu'ils puissent résoudre les nom de domaines, il faut rajouter les commandes suivantes :

```
resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.private_vpc.id
  vpc_id      = aws_vpc.public_vpc.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  }
  ```

  Pour appliquer le DNS private, tycm2-infra.fr, au VPC sur le route 53, il faut ajouter ces valeurs : 

```
  # Ajustement des VPC associée à la zone

resource "aws_route53_zone" "private" {
  name = "tycm2-infra.fr"

  vpc {
    vpc_id = aws_vpc.private_vpc.id
  }

  vpc {
    vpc_id = aws_vpc.public_vpc.id
  }
}
```