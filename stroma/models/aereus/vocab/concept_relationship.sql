MODEL (
  name bronze.concept_relationship,
  kind VIEW,
  cron '@yearly'
);

SELECT
  cr.concept_id_1,
  cr.concept_id_2,
  cr.relationship_id,
  cr.valid_start_date,
  cr.valid_end_date,
  cr.invalid_reason
FROM @catalog_src.@base.concept_relationship AS cr
