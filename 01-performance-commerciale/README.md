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

**Constats :**

- 15 % des articles ont été annulés et 10 % retournés, soit environ 25 % du montant total des commandes.
- Les données couvrent la période du 13/01/2019 au 19/09/2026 et contiennent des commandes datées dans le futur.

**Règles retenues :**

- **Chiffre d'affaires** : seuls les articles livrés (Complete), expédiés (Shipped) ou en préparation (Processing) sont comptés. Les articles annulés ou retournés sont exclus, car ils n'ont généré aucun revenu.
- **Période** : l'analyse s'arrête au 31/08/2026, dernier mois complet.
- **Évolution du chiffre d'affaires** : analysée sur tout l'historique (janvier 2019 - août 2026).
- **Catégories, rentabilité, retours et pays** : analysés sur les 12 derniers mois complets (septembre 2025 - août 2026), la période la plus utile pour préparer le budget de l'année prochaine.


## Outils

- **BigQuery (SQL)** : préparation et analyse des données
- **Looker Studio** : création du dashboard
- **GitHub** : documentation et présentation du projet
