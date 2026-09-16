-- ============================================================
-- Projet : Analyse de la performance commerciale - TheLook
-- Requête 01 : évolution annuelle du chiffre d'affaires
--
-- Objectif : mesurer la croissance de l'activité et identifier
-- si elle vient du nombre de commandes ou du panier moyen.
-- Chaque année est mesurée de janvier à août, pour comparer
-- des périodes équivalentes (2026 s'arrête au 31/08).
-- ============================================================

WITH ventes_par_annee AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS annee,
    COUNT(DISTINCT order_id) AS nb_commandes,
    SUM(sale_price) AS chiffre_affaires
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status IN ('Complete', 'Shipped', 'Processing')
    AND EXTRACT(MONTH FROM created_at) <= 8
    AND DATE(created_at) <= '2026-08-31'
  GROUP BY annee
)

SELECT
  annee,
  nb_commandes,
  ROUND(chiffre_affaires, 0) AS chiffre_affaires,
  ROUND(chiffre_affaires / nb_commandes, 2) AS panier_moyen,
  ROUND(100 * (chiffre_affaires / LAG(chiffre_affaires) OVER (ORDER BY annee) - 1), 1) AS evolution_ca_pct,
  ROUND(100 * (nb_commandes / LAG(nb_commandes) OVER (ORDER BY annee) - 1), 1) AS evolution_commandes_pct
FROM ventes_par_annee
ORDER BY annee;

-- ============================================================
-- Constats (exécution du 16/09/2026)
-- - Croissance continue depuis 2019 : 2,17 M$ de CA sur
--   janvier-août 2026 (+80,8 % par rapport à 2025).
-- - Accélération en 2026, après +40 à +50 % par an de 2023 à 2025.
-- - Le nombre de commandes progresse au même rythme que le CA,
--   alors que le panier moyen reste stable (85 à 87 $ depuis 2021).
--   La croissance vient donc du volume de commandes.
-- ============================================================
