-- ============================================================
-- Projet : Analyse de la performance commerciale - TheLook
-- Requête 02 : chiffre d'affaires et rentabilité par catégorie
--
-- Objectif : identifier les catégories qui génèrent le plus de
-- chiffre d'affaires (question 2) et les plus rentables
-- (question 3), sur les 12 derniers mois complets.
-- ============================================================

SELECT
  p.category AS categorie,
  COUNT(*) AS nb_articles_vendus,
  ROUND(SUM(oi.sale_price), 0) AS chiffre_affaires,
  ROUND(SUM(oi.sale_price - p.cost), 0) AS marge_brute,
  ROUND(100 * SUM(oi.sale_price - p.cost) / SUM(oi.sale_price), 1) AS taux_marge_pct,
  ROUND(100 * SUM(oi.sale_price) / SUM(SUM(oi.sale_price)) OVER (), 1) AS part_du_ca_pct
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
  ON oi.product_id = p.id
WHERE oi.status IN ('Complete', 'Shipped', 'Processing')
  AND DATE(oi.created_at) BETWEEN '2025-09-01' AND '2026-08-31'
GROUP BY categorie
ORDER BY chiffre_affaires DESC;

-- ============================================================
-- Constats (exécution du 16/09/2026)
-- - CA total : 2,92 M$ ; marge brute : 1,52 M$ (taux moyen 52,0 %).
-- - Outerwear & Coats et Jeans réalisent 24 % du CA.
-- - Outerwear & Coats : n°1 en CA avec une marge de 55,4 %.
-- - Jeans : n°2 en CA mais une marge de seulement 46,5 %.
-- - Blazers & Jackets, Suits & Sport Coats, Accessories et Active
--   dépassent 58 % de marge mais ne font que 17 % du CA.
-- ============================================================
