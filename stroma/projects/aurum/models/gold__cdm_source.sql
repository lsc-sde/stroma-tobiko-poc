MODEL (
  name gold.cdm_source,
  kind FULL,
  cron '@monthly'
);

WITH cte AS (
  SELECT
    vocabulary_version
  FROM @catalog_source.@schema_src.vocabulary
  WHERE
    vocabulary_id = 'None'
)
SELECT
  @metadata['cdm_source_name'] AS cdm_source_name,
  @metadata['cdm_source_abbreviation'] AS cdm_source_abbreviation,
  @metadata['cdm_holder'] AS cdm_holder,
  @metadata['source_description'] AS source_description,
  @metadata['source_documentation_reference'] AS source_documentation_reference,
  @metadata['cdm_etl_reference'] AS cdm_etl_reference,
  CURRENT_DATE AS source_release_date,
  CURRENT_DATE AS cdm_release_date,
  @metadata['cdm_version'] AS cdm_version,
  (
    SELECT
      coalesce(vocabulary_version, 'Unknown') AS vocabulary_version
    FROM cte
  ) AS vocabulary_version,
  75626 AS cdm_version_concept_id
