MODEL (
  name bronze.domain,
  kind VIEW,
  cron '@yearly'
);

SELECT
  d.domain_id,
  d.domain_name,
  d.domain_concept_id
FROM @catalog_src.@base.domain AS d
