-- 목적: 반복 횟수가 많은 거래번호의 실제 값 확인

SELECT
  CASE
    WHEN ecommerce.transaction_id IS NULL
      THEN '[NULL]'
    WHEN TRIM(ecommerce.transaction_id) = ''
      THEN '[EMPTY STRING]'
    ELSE ecommerce.transaction_id
  END AS transaction_id_display,

  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS user_count

FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name = 'purchase'

GROUP BY
  transaction_id_display

HAVING
  COUNT(*) > 1

ORDER BY
  event_count DESC

LIMIT
  10;