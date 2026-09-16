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

### Questions 2 et 3 : chiffre d'affaires et rentabilité par catégorie

Période analysée : du 1er septembre 2025 au 31 août 2026 ([requête 02](sql/02_performance_par_categorie.sql)). Le taux de marge correspond à la marge brute (prix de vente moins coût d'achat) divisée par le chiffre d'affaires.

Sur cette période, TheLook réalise **2,92 millions de dollars** de chiffre d'affaires pour **1,52 million de dollars** de marge brute, soit un taux de marge moyen de **52,0 %**.

<details>
<summary><b>Voir le tableau complet des 26 catégories</b></summary>

| Catégorie | Articles vendus | Chiffre d'affaires | Marge brute | Taux de marge | Part du CA |
|---|---:|---:|---:|---:|---:|
| Outerwear & Coats | 2 469 | 362 596 $ | 200 859 $ | 55,4 % | 12,4 % |
| Jeans | 3 484 | 339 103 $ | 157 764 $ | 46,5 % | 11,6 % |
| Sweaters | 2 903 | 217 750 $ | 113 112 $ | 51,9 % | 7,5 % |
| Suits & Sport Coats | 1 407 | 178 946 $ | 107 147 $ | 59,9 % | 6,1 % |
| Swim | 3 114 | 176 858 $ | 87 427 $ | 49,4 % | 6,1 % |
| Fashion Hoodies & Sweatshirts | 3 158 | 169 807 $ | 81 797 $ | 48,2 % | 5,8 % |
| Sleep & Lounge | 3 061 | 153 615 $ | 79 573 $ | 51,8 % | 5,3 % |
| Shorts | 3 022 | 142 685 $ | 71 235 $ | 49,9 % | 4,9 % |
| Active | 2 413 | 130 426 $ | 75 670 $ | 58,0 % | 4,5 % |
| Tops & Tees | 3 069 | 125 456 $ | 55 087 $ | 43,9 % | 4,3 % |
| Intimates | 3 647 | 122 992 $ | 57 799 $ | 47,0 % | 4,2 % |
| Dresses | 1 518 | 120 484 $ | 65 967 $ | 54,8 % | 4,1 % |
| Pants | 1 958 | 117 908 $ | 63 718 $ | 54,0 % | 4,0 % |
| Accessories | 2 697 | 109 342 $ | 65 437 $ | 59,8 % | 3,7 % |
| Blazers & Jackets | 810 | 77 602 $ | 48 257 $ | 62,2 % | 2,7 % |
| Maternity | 1 384 | 71 092 $ | 39 810 $ | 56,0 % | 2,4 % |
| Underwear | 2 091 | 56 181 $ | 29 788 $ | 53,0 % | 1,9 % |
| Pants & Capris | 895 | 47 286 $ | 22 350 $ | 47,3 % | 1,6 % |
| Plus | 1 159 | 45 735 $ | 22 922 $ | 50,1 % | 1,6 % |
| Suits | 285 | 32 390 $ | 12 856 $ | 39,7 % | 1,1 % |
| Socks | 1 636 | 31 271 $ | 12 449 $ | 39,8 % | 1,1 % |
| Skirts | 594 | 31 030 $ | 18 661 $ | 60,1 % | 1,1 % |
| Leggings | 863 | 20 860 $ | 8 303 $ | 39,8 % | 0,7 % |
| Socks & Hosiery | 998 | 16 303 $ | 9 752 $ | 59,8 % | 0,6 % |
| Jumpsuits & Rompers | 285 | 14 348 $ | 6 714 $ | 46,8 % | 0,5 % |
| Clothing Sets | 61 | 5 624 $ | 2 121 $ | 37,7 % | 0,2 % |
| **Total** | **48 981** | **2 917 690 $** | **1 516 575 $** | **52,0 %** | **100 %** |

</details>

**Constats :**

- **Un chiffre d'affaires concentré.** Sur 26 catégories, Outerwear & Coats et Jeans réalisent à elles seules 24 % du chiffre d'affaires, et les cinq premières 44 %.
- **Outerwear & Coats, la catégorie la plus stratégique.** Première en chiffre d'affaires (362 596 $), elle affiche aussi un taux de marge supérieur à la moyenne (55,4 %) et génère 13 % de la marge brute totale.
- **Jeans, un volume élevé mais une rentabilité faible.** Deuxième en chiffre d'affaires, elle a l'un des taux de marge les plus bas du catalogue (46,5 %). Au taux de marge moyen, elle rapporterait environ 18 500 $ de marge supplémentaire sur l'année.
- **Des catégories très rentables encore peu développées.** Blazers & Jackets (62,2 %), Suits & Sport Coats (59,9 %), Accessories (59,8 %) et Active (58,0 %) dégagent parmi les meilleures marges, mais ne représentent ensemble que 17 % du chiffre d'affaires.
- **Des petites catégories peu rentables.** Tops & Tees (43,9 %), Socks, Leggings et Suits (environ 39,8 %) ainsi que Clothing Sets (37,7 %) ont les taux de marge les plus faibles.

**Conclusion :** la rentabilité de TheLook repose sur un nombre limité de catégories. Deux leviers se dégagent : améliorer la marge des Jeans, en renégociant les coûts d'achat ou en ajustant les prix, et développer les catégories à forte marge comme Blazers & Jackets, Suits & Sport Coats et Accessories. Les Accessories rejoignent d'ailleurs la piste de la question 1 : proposés en complément d'un achat, ils augmenteraient à la fois le panier moyen et la marge.


## Outils

- **BigQuery (SQL)** : préparation et analyse des données
- **Looker Studio** : création du dashboard
- **GitHub** : documentation et présentation du projet
