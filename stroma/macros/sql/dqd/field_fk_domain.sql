
/*********
FIELD_FK_DOMAIN

Check that all standard concept IDs belong to the appropriate domain for a given table and field.

Parameters used in this template:
schema = @schema
vocabDatabaseSchema = @vocabDatabaseSchema
cdmTableName = @cdmTableName
cdmFieldName = @cdmFieldName
fkDomain = @fkDomain
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
            AND co.domain_id NOT IN ('@fkDomain')
        /*violatedRowsEnd*/
    ) violated_rows
) violated_row_count,
(
    SELECT
        COUNT_BIG(*) AS num_rows
    FROM @schema.@cdmTableName cdmTable
    {@cohort & '@runForCohort' == 'Yes'}?{
    JOIN @cohortDatabaseSchema.@cohortTableName c
        ON cdmTable.PERSON_ID = c.SUBJECT_ID
        AND c.COHORT_DEFINITION_ID = @cohortDefinitionId
    }
) denominator
;
