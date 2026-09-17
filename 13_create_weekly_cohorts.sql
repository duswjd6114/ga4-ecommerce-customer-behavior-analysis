-- 목적: 첫 방문 주차가 같은 사용자를 하나의 코호트로 구성

WITH first_visits AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_visit_date
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20201102' AND '20210131'
    AND event_name = 'first_visit'
    AND user_pseudo_id IS NOT NULL
  GROUP BY user_pseudo_id
)

SELECT
  DATE_TRUNC(first_visit_date, WEEK(MONDAY)) AS cohort_week,
  COUNT(*) AS cohort_users
FROM first_visits
GROUP BY cohort_week
ORDER BY cohort_week;