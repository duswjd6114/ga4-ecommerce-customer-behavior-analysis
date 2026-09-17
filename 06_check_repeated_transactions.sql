-- 목적: 동일 거래번호의 반복 기록 규모 확인

WITH transaction_counts AS (
  SELECT
    ecommerce.transaction_id AS transaction_id,
    COUNT(*) AS purchase_event_count
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name = 'purchase'
    AND ecommerce.transaction_id IS NOT NULL
  GROUP BY
    transaction_id
)

SELECT
  COUNTIF(purchase_event_count > 1)
    AS repeated_transaction_count,

  SUM(
    CASE
      WHEN purchase_event_count > 1
        THEN purchase_event_count - 1
      ELSE 0
    END
  ) AS additional_event_count,

  MAX(purchase_event_count)
    AS max_events_per_transaction
FROM
  transaction_counts;