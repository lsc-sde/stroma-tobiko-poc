MODEL (
  name @schema_staging.era__condition_end_dates,
  kind FULL,
  cron '@monthly'
);

SELECT
  person_id,
  condition_concept_id,
  event_date + INTERVAL (
    -30
  ) DAY AS end_date
/* unpad the end date */
FROM (
  SELECT
    e1.person_id,
    e1.condition_concept_id,
    e1.event_date,
    coalesce(e1.start_ordinal, max(e2.start_ordinal)) AS start_ordinal,
    e1.overall_ord
  FROM (
    SELECT
      person_id,
      condition_concept_id,
      event_date,
      event_type,
      start_ordinal,
      row_number() OVER (PARTITION BY person_id, condition_concept_id ORDER BY event_date, event_type) AS overall_ord
    /* this re-numbers the inner union so all rows are numbered ordered by the event date */
    FROM (
      /* select the start dates, assigning a row number to each */
      SELECT
        person_id,
        condition_concept_id,
        condition_start_date AS event_date,
        -1 AS event_type,
        row_number() OVER (PARTITION BY person_id, condition_concept_id ORDER BY condition_start_date) AS start_ordinal
      FROM @schema_staging.era__condition_target
      UNION ALL
      /* pad the end dates by 30 to allow a grace period for overlapping ranges. */
      SELECT
        person_id,
        condition_concept_id,
        condition_end_date + INTERVAL '30' DAY,
        1 AS event_type,
        NULL
      FROM @schema_staging.era__condition_target
    ) AS rawdata
  ) AS e1
  INNER JOIN (
    SELECT
      person_id,
      condition_concept_id,
      condition_start_date AS event_date,
      row_number() OVER (PARTITION BY person_id, condition_concept_id ORDER BY condition_start_date) AS start_ordinal
    FROM @schema_staging.era__condition_target
  ) AS e2
    ON e1.person_id = e2.person_id
    AND e1.condition_concept_id = e2.condition_concept_id
    AND e2.event_date <= e1.event_date
  GROUP BY
    e1.person_id,
    e1.condition_concept_id,
    e1.event_date,
    e1.start_ordinal,
    e1.overall_ord
) AS e
WHERE
  (
    2 * e.start_ordinal
  ) - e.overall_ord = 0
