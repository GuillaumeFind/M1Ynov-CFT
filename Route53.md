***
# Route 53

Route 53 est un servise de noms de domaine (DNS) hautement dsisponible et évolutif proposé par AWS. Il permet de résoudre les noms de domaine en adresses IP et de diriger le trafic internet vers les applications et les services hébergés sur AWS ou sur site.

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

![HomePage](/images/homepage.png)

On clique sur **Hosted zones**

![HostedZone](/Images/clickhosted.png)

On clique sur la zone d'hébergement déja crée par l'autre promo, **tycm2-infra.fr**.

![HostedZones](/Images/selectdns.png)

On va devoir créer deux enregistrements : 

- une enregistrement qui va lier notre serveur à un nom de domaine, nous avons choisi le nom de domaine : [cft-czycloud.tycm2-infra.fr](https://cft-cozycloud.tycm2-infra.fr/)

- un alias de notre nom de domaine comme suit : ***.cft-cozycloud.tycm2-infra.fr**

Une fois fini, on retrouve nos enregistrements.

![Record](/Images/endrecord)



