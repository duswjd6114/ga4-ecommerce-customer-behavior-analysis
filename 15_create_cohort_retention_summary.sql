-- 목적: 코호트별 1~4주 차 리텐션을 한 행으로 비교

WITH user_weeks AS (
  SELECT DISTINCT
    user_pseudo_id,
    DATE_TRUNC(
      PARSE_DATE('%Y%m%d', event_date),
      WEEK(MONDAY)
    ) AS activity_week,

    DATE_TRUNC(
      MIN(IF(
        event_name = 'first_visit',
        PARSE_DATE('%Y%m%d', event_date),
        NULL
      )) OVER (PARTITION BY user_pseudo_id),
      WEEK(MONDAY)
    ) AS cohort_week

  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20201102' AND '20210131'
    AND user_pseudo_id IS NOT NULL
),

activity AS (
  SELECT
    user_pseudo_id,
    cohort_week,
    DATE_DIFF(activity_week, cohort_week, WEEK) AS week_number
  FROM user_weeks
  WHERE cohort_week IS NOT NULL
)

SELECT
  cohort_week,
  COUNT(DISTINCT user_pseudo_id) AS cohort_users,
  100 AS week_0,

  ROUND(100 * SAFE_DIVIDE(
    COUNT(DISTINCT IF(week_number = 1, user_pseudo_id, NULL)),
    COUNT(DISTINCT user_pseudo_id)
  ), 2) AS week_1,

  ROUND(100 * SAFE_DIVIDE(
    COUNT(DISTINCT IF(week_number = 2, user_pseudo_id, NULL)),
    COUNT(DISTINCT user_pseudo_id)
  ), 2) AS week_2,

  ROUND(100 * SAFE_DIVIDE(
    COUNT(DISTINCT IF(week_number = 3, user_pseudo_id, NULL)),
    COUNT(DISTINCT user_pseudo_id)
  ), 2) AS week_3,

  ROUND(100 * SAFE_DIVIDE(
    COUNT(DISTINCT IF(week_number = 4, user_pseudo_id, NULL)),
    COUNT(DISTINCT user_pseudo_id)
  ), 2) AS week_4

FROM activity
WHERE cohort_week <= '2020-12-28'
GROUP BY cohort_week
ORDER BY cohort_week;