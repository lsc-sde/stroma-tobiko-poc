MODEL (
  name @schema_dest.person,
  kind FULL,
  cron '@monthly',
  grain person_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

/* This is the patient table. */
SELECT
  p.person_id,
  p.gender_concept_id,
  p.year_of_birth::INT, /* This is the year the patient was born */
  p.month_of_birth::INT,
  p.day_of_birth::INT,
  p.birth_datetime::DATETIME,
  p.race_concept_id,
  p.ethnicity_concept_id,
  p.location_id,
  p.provider_id,
  p.care_site_id,
  p.person_source_value,
  p.gender_source_value,
  p.gender_source_concept_id,
  p.race_source_value,
  p.race_source_concept_id,
  p.ethnicity_source_value,
  p.ethnicity_source_concept_id
FROM @catalog_src.@schema_src.person AS p
