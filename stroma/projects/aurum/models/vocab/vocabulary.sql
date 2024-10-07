MODEL (
  name gold.vocabulary,
  kind VIEW,
  cron '@yearly'
);

SELECT
  v.vocabulary_id,
  v.vocabulary_name,
  v.vocabulary_reference,
  v.vocabulary_version,
  v.vocabulary_concept_id
FROM @catalog_source.@schema_src.vocabulary AS v
