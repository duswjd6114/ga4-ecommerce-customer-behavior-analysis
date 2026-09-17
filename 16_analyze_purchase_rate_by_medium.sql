-- 목적: 최초 유입 매체별 구매 사용자 비율 비교

SELECT
  COALESCE(
    traffic_source.medium,
    '(not set)'
  ) AS acquisition_medium,

  COUNT(DISTINCT user_pseudo_id) AS users,

  COUNT(DISTINCT IF(
    event_name = 'purchase',
    user_pseudo_id,
    NULL
  )) AS purchasing_users,

  ROUND(
    100 * SAFE_DIVIDE(
      COUNT(DISTINCT IF(
        event_name = 'purchase',
        user_pseudo_id,
        NULL
      )),
      COUNT(DISTINCT user_pseudo_id)
    ),
    2
  ) AS purchase_user_rate

FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND user_pseudo_id IS NOT NULL

GROUP BY acquisition_medium
HAVING users >= 100
ORDER BY purchase_user_rate DESC;