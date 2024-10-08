MODEL (
  name @schema_dest.domain,
  kind VIEW,
  cron '@yearly'
);

SELECT
  d.domain_id,
  d.domain_name,
  d.domain_concept_id
FROM @catalog_source.@schema_src.domain AS d
