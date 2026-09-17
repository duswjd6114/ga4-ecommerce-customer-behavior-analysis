-- 목적: 퍼널 결과로 단계별 전환율과 이탈률 계산

WITH funnel AS (
  SELECT 1 AS step, 'session_start' AS stage, 354857 AS sessions UNION ALL
  SELECT 2, 'view_item',       75271 UNION ALL
  SELECT 3, 'add_to_cart',     14897 UNION ALL
  SELECT 4, 'begin_checkout',   5868 UNION ALL
  SELECT 5, 'purchase',         2816
),

previous_step AS (
  SELECT
    *,
    LAG(sessions) OVER (ORDER BY step) AS previous_sessions
  FROM funnel
)

SELECT
  step,
  stage,
  sessions,
  ROUND(100 * SAFE_DIVIDE(sessions, previous_sessions), 2)
    AS step_conversion_rate,
  ROUND(100 * (1 - SAFE_DIVIDE(sessions, previous_sessions)), 2)
    AS dropoff_rate
FROM previous_step
ORDER BY step;