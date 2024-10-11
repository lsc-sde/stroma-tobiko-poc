MODEL (
  name @schema_dest.concept_ancestor,
  kind VIEW,
  cron '@yearly'
);

SELECT
  ca.ancestor_concept_id,
  ca.descendant_concept_id,
  ca.min_levels_of_separation,
  ca.max_levels_of_separation
FROM @schema_src.concept_ancestor AS ca
