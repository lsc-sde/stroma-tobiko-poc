MODEL (
  name bronze.concept_synonym,
  kind VIEW,
  cron '@yearly'
);

SELECT
  cs.concept_id,
  cs.concept_synonym_name,
  cs.language_concept_id
FROM @catalog_src.@base.concept_synonym AS cs
