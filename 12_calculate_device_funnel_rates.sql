-- 목적: 기기별 단계 전환율과 전체 구매 전환율 비교

WITH funnel AS (
  SELECT 'desktop' AS device, 205899 AS start, 43813 AS view,
         8619 AS cart, 3377 AS checkout, 1592 AS purchase
  UNION ALL
  SELECT 'mobile', 141079, 29799, 5962, 2362, 1162
  UNION ALL
  SELECT 'tablet', 7879, 1659, 316, 129, 62
)

SELECT
  device,
  ROUND(100 * SAFE_DIVIDE(view, start), 2) AS view_rate,
  ROUND(100 * SAFE_DIVIDE(cart, view), 2) AS cart_rate,
  ROUND(100 * SAFE_DIVIDE(checkout, cart), 2) AS checkout_rate,
  ROUND(100 * SAFE_DIVIDE(purchase, checkout), 2) AS purchase_rate,
  ROUND(100 * SAFE_DIVIDE(purchase, start), 2) AS total_conversion_rate
FROM funnel
ORDER BY total_conversion_rate DESC;