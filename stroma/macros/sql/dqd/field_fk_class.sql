
/*********
FK_CLASS

Check that drug concepts in DRUG_ERA.drug_concept_id, DOSE_ERA.drug_concept_id,
and DRUG_STRENGTH.ingredient_concept_id are of class 'Ingredient'.

Parameters used in this template:
schema = @schema
vocabDatabaseSchema = @vocabDatabaseSchema
cdmTableName = @cdmTableName
cdmFieldName = @cdmFieldName
fkClass = @fkClass
{@cohort & '@runForCohort' == 'Yes'}?{
cohortDefinitionId = @cohortDefinitionId
cohortDatabaseSchema = @cohortDatabaseSchema
cohortTableName = @cohortTableName
}
**********/


SELECT
    num_violated_rows,
    CASE
        WHEN denominator.num_rows = 0 THEN 0
        ELSE 1.0*num_violated_rows/denominator.num_rows
    END AS pct_violated_rows,
    denominator.num_rows AS num_denominator_rows
FROM (
    SELECT
        COUNT_BIG(violated_rows.violating_field) AS num_violated_rows
    FROM (
        /*violatedRowsBegin*/
        SELECT
            '@cdmTableName.@cdmFieldName' AS violating_field,
            cdmTable.*
        FROM @schema.@cdmTableName cdmTable
            LEFT JOIN @vocabDatabaseSchema.concept co
                ON cdmTable.@cdmFieldName = co.concept_id
            {@cohort & '@runForCohort' == 'Yes'}?{
                JOIN @cohortDatabaseSchema.@cohortTableName c
                    ON cdmTable.person_id = c.subject_id
                    AND c.cohort_definition_id = @cohortDefinitionId
            }
        WHERE co.concept_id != 0
            AND (co.concept_class_id != '@fkClass')
        /*violatedRowsEnd*/
    ) violated_rows
) violated_row_count,
(
    SELECT
        COUNT_BIG(*) AS num_rows
    FROM @schema.@cdmTableName cdmTable
        {@cohort & '@runForCohort' == 'Yes'}?{
            JOIN @cohortDatabaseSchema.@cohortTableName c
                ON cdmTable.person_id = c.subject_id
                AND c.cohort_definition_id = @cohortDefinitionId
        }
) denominator
;
