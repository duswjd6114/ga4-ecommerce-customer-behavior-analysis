-- 목적: 구매 퍼널에 필요한 이벤트의 존재 여부와 규모 확인

SELECT
  CASE
    WHEN event_name = 'session_start' THEN 1
    WHEN event_name = 'view_item' THEN 2
    WHEN event_name = 'add_to_cart' THEN 3
    WHEN event_name = 'begin_checkout' THEN 4
    WHEN event_name = 'add_shipping_info' THEN 5
    WHEN event_name = 'add_payment_info' THEN 6
    WHEN event_name = 'purchase' THEN 7
  END AS funnel_step,
  event_name,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS user_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name IN (
    'session_start',
    'view_item',
    'add_to_cart',
    'begin_checkout',
    'add_shipping_info',
    'add_payment_info',
    'purchase'
  )
GROUP BY
  funnel_step,
  event_name
ORDER BY
  funnel_step;