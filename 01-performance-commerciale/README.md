# Analyse de la performance commerciale et de la rentabilité - TheLook

## Contexte

TheLook est une boutique en ligne de vêtements. La direction prépare le budget de l'année prochaine et souhaite mieux comprendre la performance de son activité.

## Problématique

Le chiffre d'affaires progresse, mais la direction ne sait pas précisément où l'entreprise gagne vraiment de l'argent, et où elle en perd. Elle souhaite identifier les produits et les marchés sur lesquels miser.

## Questions métier

1. Comment évoluent le chiffre d'affaires et le nombre de commandes mois par mois ?
2. Quelles catégories de produits génèrent le plus de chiffre d'affaires ?
3. Quelles catégories sont les plus rentables ?
4. Quelles catégories ont le plus de retours ?
5. Dans quels pays l'entreprise réalise-t-elle ses meilleures ventes ?

## Données

**Source :** jeu de données public `bigquery-public-data.thelook_ecommerce`, mis à disposition par Google sur BigQuery. Les données sont fictives mais reproduisent le fonctionnement d'une vraie boutique en ligne.

| Table | Contenu |
|---|---|
| `orders` | Les commandes (date, statut, client) |
| `order_items` | Les articles de chaque commande (prix de vente, statut, retour) |
| `products` | Les produits (catégorie, marque, coût d'achat, prix) |
| `users` | Les clients (pays, âge, date d'inscription) |


Avant l'analyse, j'ai exploré les statuts des articles commandés ([requête 00](sql/00_exploration_des_statuts.sql)).

## Constats 

- 15 % des articles ont été annulés et 10 % retournés, soit environ 25 % du montant total des commandes.
- Les données couvrent la période du 13/01/2019 au 19/09/2026 et contiennent des commandes datées dans le futur.

**Règles retenues :**

- **Chiffre d'affaires** : seuls les articles livrés (Complete), expédiés (Shipped) ou en préparation (Processing) sont comptés. Les articles annulés ou retournés sont exclus, car ils n'ont généré aucun revenu.
- **Période** : l'analyse s'arrête au 31/08/2026, dernier mois complet.
- **Évolution du chiffre d'affaires** : analysée sur tout l'historique (janvier 2019 - août 2026).
- **Catégories, rentabilité, retours et pays** : analysés sur les 12 derniers mois complets (septembre 2025 - août 2026), la période la plus utile pour préparer le budget de l'année prochaine.

## Analyse

### Question 1 : évolution du chiffre d'affaires

Pour comparer des périodes équivalentes, chaque année est mesurée de janvier à août, puisque les données 2026 s'arrêtent au 31 août ([requête 01](sql/01_evolution_ca_annuel.sql)).

| Année | Commandes | Chiffre d'affaires | Panier moyen | Évolution du CA | Évolution des commandes |
|---|---:|---:|---:|---:|---:|
| 2019 | 361 | 34 889 $ | 96,64 $ | - | - |
| 2020 | 1 500 | 134 692 $ | 89,79 $ | +286,1 % | +315,5 % |
| 2021 | 2 858 | 243 268 $ | 85,12 $ | +80,6 % | +90,5 % |
| 2022 | 4 571 | 395 350 $ | 86,49 $ | +62,5 % | +59,9 % |
| 2023 | 6 586 | 568 820 $ | 86,37 $ | +43,9 % | +44,1 % |
| 2024 | 9 446 | 806 971 $ | 85,43 $ | +41,9 % | +43,4 % |
| 2025 | 13 852 | 1 199 018 $ | 86,56 $ | +48,6 % | +46,6 % |
| 2026 | 25 183 | 2 167 518 $ | 86,07 $ | +80,8 % | +81,8 % |

*Période : janvier à août de chaque année.*

**Constats :**

- **Une croissance continue.** Le chiffre d'affaires progresse chaque année depuis 2019 et atteint 2,17 millions de dollars sur les huit premiers mois de 2026.
- **Une nette accélération en 2026.** Après trois années autour de +40 à +50 %, la croissance atteint +80,8 %. Les très fortes hausses de 2020 et 2021 sont à relativiser : elles partent d'un volume de départ très faible (361 commandes en 2019).
- **Une croissance portée par le volume.** Le nombre de commandes évolue presque au même rythme que le chiffre d'affaires, tandis que le panier moyen reste stable, entre 85 et 87 $ depuis 2021.

**Conclusion :** TheLook gagne plus parce qu'elle reçoit davantage de commandes, et non parce que ses clients dépensent plus à chaque achat. L'augmentation du panier moyen représente donc un levier de croissance encore inexploité.


## Outils

- **BigQuery (SQL)** : préparation et analyse des données
- **Looker Studio** : création du dashboard
- **GitHub** : documentation et présentation du projet
