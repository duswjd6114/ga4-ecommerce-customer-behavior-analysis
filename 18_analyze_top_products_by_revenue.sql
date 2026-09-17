-- 목적: 매출 기여도가 높은 상품 TOP 10 확인

WITH purchases AS (
  SELECT
    ecommerce.transaction_id,
    items,

    ROW_NUMBER() OVER (
      PARTITION BY ecommerce.transaction_id
      ORDER BY event_timestamp
    ) AS duplicate_number

  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

  WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name = 'purchase'
    AND ecommerce.transaction_id IS NOT NULL
    AND ecommerce.transaction_id != '(not set)'
)

SELECT
  item.item_name,
  COUNT(DISTINCT transaction_id) AS order_count,
  SUM(item.quantity) AS quantity_sold,
  ROUND(SUM(item.item_revenue_in_usd), 2) AS revenue_usd

FROM purchases,
UNNEST(items) AS item

WHERE
  duplicate_number = 1
  AND item.item_name IS NOT NULL

GROUP BY item.item_name
ORDER BY revenue_usd DESC
LIMIT 10;