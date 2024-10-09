MODEL (
  name @schema_dest.cdm_source,
  kind FULL,
  cron '@monthly'
);

SELECT
  'IDRIL-1-GOLD' AS cdm_source_abbreviation,
  'IDRIL-1 Medallion Gold Layer' AS source_description,
  'LSC SDE' AS cdm_holder,
  NULL AS source_documentation_reference,
  NULL AS cdm_etl_reference,
  CURRENT_DATE AS source_release_date,
  CURRENT_DATE AS cdm_release_date,
  '5.4' AS cdm_version,
  coalesce(vocabulary_version, 'Unknown') AS vocabulary_version,
  75626 AS cdm_version_concept_id
FROM base.vocabulary
WHERE
  vocabulary_id = 'None'
