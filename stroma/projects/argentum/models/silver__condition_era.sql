MODEL (
  name @schema_dest.condition_era,
  kind FULL,
  cron '@monthly',
  grain condition_era_id
);

@calculate_condition_era(@schema_dest)
