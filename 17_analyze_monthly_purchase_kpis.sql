-- 목적: 월별 주문 수, 구매 사용자, 매출, 평균 주문금액 계산

WITH orders AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS order_date,
    user_pseudo_id,
    ecommerce.transaction_id,
    ecommerce.purchase_revenue_in_usd AS revenue_usd,

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
    AND TRIM(ecommerce.transaction_id) != ''
    AND ecommerce.transaction_id != '(not set)'
)

SELECT
  FORMAT_DATE('%Y-%m', order_date) AS month,
  COUNT(*) AS order_count,
  COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
  ROUND(SUM(revenue_usd), 2) AS total_revenue_usd,
  ROUND(AVG(revenue_usd), 2) AS average_order_value_usd
FROM orders
WHERE duplicate_number = 1
GROUP BY month
ORDER BY month;