MODEL (
  name bronze.note_nlp,
  kind FULL,
  cron '@monthly',
  grain note_nlp_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  nn.note_nlp_id,
  nn.note_id,
  nn.section_concept_id,
  nn.snippet,
  nn."offset",
  nn.lexical_variant,
  nn.note_nlp_concept_id,
  nn.note_nlp_source_concept_id,
  nn.nlp_system,
  nn.nlp_date,
  nn.nlp_datetime,
  nn.term_exists,
  nn.term_temporal,
  nn.term_modifiers
FROM @catalog_src.@base.note_nlp AS nn
