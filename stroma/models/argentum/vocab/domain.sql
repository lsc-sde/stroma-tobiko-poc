MODEL (
  name silver.domain,
  kind VIEW,
  cron '@yearly'
);

SELECT
  d.domain_id,
  d.domain_name,
  d.domain_concept_id
FROM bronze.domain AS d
