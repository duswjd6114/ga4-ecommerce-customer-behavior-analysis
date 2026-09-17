-- 목적: 이벤트 종류별 발생 횟수와 익명 사용자 식별자 수 확인
-- 결과: page_view, view_item, add_to_cart, purchase 등 17종 확인

SELECT
  event_name,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS user_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY
  event_name
ORDER BY
  event_count DESC;