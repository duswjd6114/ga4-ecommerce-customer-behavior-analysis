-- 목적: 기기별 동일 세션 기준 5단계 누적 퍼널 계산

WITH event_base AS (
  SELECT
    device.category AS device_category,
    CONCAT(
      user_pseudo_id, '-',
      (SELECT value.int_value
       FROM UNNEST(event_params)
       WHERE key = 'ga_session_id')
    ) AS session_id,
    event_name
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name IN (
      'session_start',
      'view_item',
      'add_to_cart',
      'begin_checkout',
      'purchase'
    )
),

session_flags AS (
  SELECT
    device_category,
    session_id,
    MAX(IF(event_name = 'session_start', 1, 0)) AS step1,
    MAX(IF(event_name = 'view_item', 1, 0)) AS step2,
    MAX(IF(event_name = 'add_to_cart', 1, 0)) AS step3,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS step4,
    MAX(IF(event_name = 'purchase', 1, 0)) AS step5
  FROM event_base
  WHERE session_id IS NOT NULL
  GROUP BY device_category, session_id
)

SELECT
  device_category,
  COUNTIF(step1 = 1) AS session_start,
  COUNTIF(step1 = 1 AND step2 = 1) AS view_item,
  COUNTIF(step1 = 1 AND step2 = 1 AND step3 = 1) AS add_to_cart,
  COUNTIF(step1 = 1 AND step2 = 1 AND step3 = 1 AND step4 = 1)
    AS begin_checkout,
  COUNTIF(
    step1 = 1 AND step2 = 1 AND step3 = 1
    AND step4 = 1 AND step5 = 1
  ) AS purchase
FROM session_flags
GROUP BY device_category
ORDER BY session_start DESC;