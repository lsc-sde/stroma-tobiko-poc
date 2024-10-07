MODEL (
  name @schema_temp.temp__condition_era_ends,
  kind FULL,
  cron '@monthly'
);

SELECT
  c.person_id,
  c.condition_concept_id,
  c.condition_start_date,
  min(e.end_date) AS era_end_date
FROM @schema_temp.temp__condition_era_target AS c
INNER JOIN @schema_temp.temp__condition_era_end_dates AS e
  ON c.person_id = e.person_id
  AND c.condition_concept_id = e.condition_concept_id
  AND c.condition_start_date <= e.end_date
GROUP BY
  c.person_id,
  c.condition_concept_id,
  c.condition_start_date
