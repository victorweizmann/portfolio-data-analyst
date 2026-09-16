-- ============================================================
-- Projet : Analyse de la performance commerciale - TheLook
-- Requête 00 : exploration des statuts des articles
--
-- Objectif : identifier les articles à exclure du chiffre
-- d'affaires et vérifier la période couverte par les données.
-- ============================================================

SELECT
  status,
  COUNT(*) AS nb_articles,
  ROUND(SUM(sale_price), 2) AS montant_total,
  MIN(DATE(created_at)) AS premiere_date,
  MAX(DATE(created_at)) AS derniere_date
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP BY status
ORDER BY nb_articles DESC;

-- ============================================================
-- Constats (exécution du 16/09/2026)
-- - 15 % des articles sont annulés (Cancelled) et 10 % retournés
--   (Returned), soit environ 25 % du montant total.
-- - Les données vont du 13/01/2019 au 19/09/2026 : certaines
--   commandes sont datées dans le futur.
--
-- Règles retenues pour la suite de l'analyse
-- - Chiffre d'affaires = articles Complete, Shipped et Processing.
-- - Analyse arrêtée au 31/08/2026 (dernier mois complet).
-- ============================================================
