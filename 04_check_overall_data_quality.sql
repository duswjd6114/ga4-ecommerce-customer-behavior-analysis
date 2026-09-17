-- 목적: 전체 이벤트 데이터의 규모, 결측값, 날짜 범위 확인

SELECT
  COUNT(*) AS total_event_count,
  COUNT(DISTINCT user_pseudo_id) AS user_count,
  COUNTIF(user_pseudo_id IS NULL) AS null_user_id_count,
  COUNTIF(event_name IS NULL) AS null_event_name_count,
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS start_date,
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS end_date
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';