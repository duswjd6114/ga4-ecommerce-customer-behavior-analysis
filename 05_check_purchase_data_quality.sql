-- 목적: 구매 이벤트의 거래번호와 구매금액 품질 확인
-- 주의: total_revenue는 중복 정제 전 참고값임

SELECT
  COUNT(*) AS purchase_event_count,
  COUNT(DISTINCT ecommerce.transaction_id) AS transaction_count,
  COUNTIF(ecommerce.transaction_id IS NULL)
    AS null_transaction_id_count,
  COUNTIF(ecommerce.purchase_revenue IS NULL)
    AS null_revenue_count,
  COUNTIF(ecommerce.purchase_revenue <= 0)
    AS nonpositive_revenue_count,
  ROUND(SUM(ecommerce.purchase_revenue), 2)
    AS total_revenue
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name = 'purchase';