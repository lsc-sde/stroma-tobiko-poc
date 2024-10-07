MODEL (
  name @schema_staging.era__condition_ends,
  kind FULL,
  cron '@monthly'
);

SELECT
  c.person_id,
  c.condition_concept_id,
  c.condition_start_date,
  min(e.end_date) AS era_end_date
FROM @schema_staging.era__condition_target AS c
INNER JOIN @schema_staging.era__condition_end_dates AS e
  ON c.person_id = e.person_id
  AND c.condition_concept_id = e.condition_concept_id
  AND e.end_date >= c.condition_start_date
GROUP BY
  c.person_id,
  c.condition_concept_id,
  c.condition_start_date
