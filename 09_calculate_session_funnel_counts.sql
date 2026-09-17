-- 목적: 동일 세션 기준 5단계 구매 퍼널의 단계별 세션 수 계산

WITH event_base AS (
  SELECT
    user_pseudo_id,

    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS ga_session_id,

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
    user_pseudo_id,
    ga_session_id,

    MAX(IF(event_name = 'session_start', 1, 0))
      AS step1_start,

    MAX(IF(event_name = 'view_item', 1, 0))
      AS step2_view,

    MAX(IF(event_name = 'add_to_cart', 1, 0))
      AS step3_cart,

    MAX(IF(event_name = 'begin_checkout', 1, 0))
      AS step4_checkout,

    MAX(IF(event_name = 'purchase', 1, 0))
      AS step5_purchase

  FROM
    event_base

  WHERE
    ga_session_id IS NOT NULL

  GROUP BY
    user_pseudo_id,
    ga_session_id
)

SELECT
  COUNTIF(step1_start = 1)
    AS session_start_count,

  COUNTIF(
    step1_start = 1
    AND step2_view = 1
  ) AS view_item_count,

  COUNTIF(
    step1_start = 1
    AND step2_view = 1
    AND step3_cart = 1
  ) AS add_to_cart_count,

  COUNTIF(
    step1_start = 1
    AND step2_view = 1
    AND step3_cart = 1
    AND step4_checkout = 1
  ) AS begin_checkout_count,

  COUNTIF(
    step1_start = 1
    AND step2_view = 1
    AND step3_cart = 1
    AND step4_checkout = 1
    AND step5_purchase = 1
  ) AS purchase_count

FROM
  session_flags;