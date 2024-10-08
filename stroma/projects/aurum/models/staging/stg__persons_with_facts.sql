MODEL (
  name @schema_stg.stg__persons_with_facts,
  kind FULL,
  cron '@monthly'
);

SELECT DISTINCT
  person_id::BIGINT
FROM (
  SELECT
    person_id
  FROM silvermeasurement
  WHERE
    measurement_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silverobservation
  WHERE
    observation_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silvercondition_occurrence
  WHERE
    condition_start_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silverprocedure_occurrence
  WHERE
    procedure_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silverdrug_exposure
  WHERE
    drug_exposure_start_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silverdevice_exposure
  WHERE
    device_exposure_start_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silvervisit_occurrence
  WHERE
    visit_start_date >= @minimum_observation_period_start_date
  UNION
  SELECT
    person_id
  FROM silverspecimen
  WHERE
    specimen_date >= @minimum_observation_period_start_date
)
