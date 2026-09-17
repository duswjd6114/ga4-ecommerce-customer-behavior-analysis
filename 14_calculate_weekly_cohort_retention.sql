-- 목적: 첫 방문 주차별 주간 리텐션 계산

WITH user_weeks AS (
  SELECT DISTINCT
    user_pseudo_id,

    DATE_TRUNC(
      PARSE_DATE('%Y%m%d', event_date),
      WEEK(MONDAY)
    ) AS activity_week,

    DATE_TRUNC(
      MIN(
        IF(
          event_name = 'first_visit',
          PARSE_DATE('%Y%m%d', event_date),
          NULL
        )
      ) OVER (PARTITION BY user_pseudo_id),
      WEEK(MONDAY)
    ) AS cohort_week

  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20201102' AND '20210131'
    AND user_pseudo_id IS NOT NULL
),

retention AS (
  SELECT
    cohort_week,
    DATE_DIFF(activity_week, cohort_week, WEEK) AS week_number,
    COUNT(DISTINCT user_pseudo_id) AS active_users
  FROM user_weeks
  WHERE
    cohort_week IS NOT NULL
    AND activity_week >= cohort_week
  GROUP BY cohort_week, week_number
)

SELECT
  cohort_week,
  week_number,

  FIRST_VALUE(active_users) OVER (
    PARTITION BY cohort_week
    ORDER BY week_number
  ) AS cohort_users,

  active_users,

  ROUND(
    100 * SAFE_DIVIDE(
      active_users,
      FIRST_VALUE(active_users) OVER (
        PARTITION BY cohort_week
        ORDER BY week_number
      )
    ),
    2
  ) AS retention_rate

FROM retention
ORDER BY cohort_week, week_number;