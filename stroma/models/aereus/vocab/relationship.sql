MODEL (
  name bronze.relationship,
  kind VIEW,
  cron '@yearly'
);

SELECT
  r.relationship_id,
  r.relationship_name,
  r.is_hierarchical,
  r.defines_ancestry,
  r.reverse_relationship_id,
  r.relationship_concept_id
FROM @catalog_src.@base.relationship AS r
