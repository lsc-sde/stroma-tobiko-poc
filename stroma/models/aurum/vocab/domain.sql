MODEL (
  name gold.domain,
  kind VIEW,
  cron '@yearly'
);

SELECT
  d.domain_id,
  d.domain_name,
  d.domain_concept_id
FROM silver.domain AS d
