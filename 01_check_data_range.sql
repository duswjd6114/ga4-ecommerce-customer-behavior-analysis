-- 목적: GA4 날짜별 테이블의 시작일, 종료일, 개수 확인
-- 결과: 2020-11-01~2021-01-31, 총 92개

SELECT
  MIN(table_name) AS first_table,
  MAX(table_name) AS last_table,
  COUNT(*) AS table_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.INFORMATION_SCHEMA.TABLES`
WHERE
  table_name LIKE 'events_%';