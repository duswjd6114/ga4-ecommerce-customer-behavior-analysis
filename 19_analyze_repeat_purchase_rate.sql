-- 목적: 구매 고객 중 2회 이상 주문한 고객 비율 계산

WITH orders AS (
  SELECT
    user_pseudo_id,
    ecommerce.transaction_id,

    ROW_NUMBER() OVER (
      PARTITION BY ecommerce.transaction_id
      ORDER BY event_timestamp
    ) AS duplicate_number

  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

  WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name = 'purchase'
    AND user_pseudo_id IS NOT NULL
    AND ecommerce.transaction_id IS NOT NULL
    AND TRIM(ecommerce.transaction_id) != ''
    AND ecommerce.transaction_id != '(not set)'
),

user_orders AS (
  SELECT
    user_pseudo_id,
    COUNT(*) AS order_count
  FROM orders
  WHERE duplicate_number = 1
  GROUP BY user_pseudo_id
)

SELECT
  COUNT(*) AS purchasing_users,

  COUNTIF(order_count = 1) AS one_time_buyers,

  COUNTIF(order_count >= 2) AS repeat_buyers,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNTIF(order_count >= 2),
      COUNT(*)
    ),
    2
  ) AS repeat_purchase_rate,

  ROUND(AVG(order_count), 2) AS average_orders_per_buyer

FROM user_orders;