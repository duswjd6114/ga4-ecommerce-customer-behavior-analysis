-- 목적: 기본 구매금액 결측을 달러 환산 금액으로 보완 가능한지 확인

SELECT
  COUNTIF(ecommerce.purchase_revenue IS NULL)
    AS original_revenue_null,

  COUNTIF(ecommerce.purchase_revenue_in_usd IS NULL)
    AS usd_revenue_null,

  COUNTIF(
    ecommerce.purchase_revenue IS NULL
    AND ecommerce.purchase_revenue_in_usd IS NULL
  ) AS both_revenue_null

FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name = 'purchase';