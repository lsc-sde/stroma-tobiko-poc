MODEL (
  name gold.location,
  kind FULL,
  cron '@monthly',
  grain location_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  l.location_id,
  l.address_1,
  l.address_2,
  l.city,
  l.state,
  l.zip,
  l.county,
  l.location_source_value,
  l.country_concept_id,
  l.country_source_value,
  l.latitude,
  l.longitude
FROM silver.location AS l
