
/*********
CDM_FIELD

Verify the field exists.

Parameters used in this template:
schema = @schema
cdmTableName = @cdmTableName
cdmFieldName = @cdmFieldName

**********/


SELECT
    num_violated_rows,
    CASE
        WHEN denominator.num_rows = 0 THEN 0 ELSE 1.0*num_violated_rows/denominator.num_rows
    END AS pct_violated_rows,
    denominator.num_rows AS num_denominator_rows
FROM (
    SELECT num_violated_rows FROM (
        SELECT
            CASE
                WHEN COUNT_BIG(@cdmFieldName) = 0 THEN 0
                ELSE 0
            END AS num_violated_rows
        FROM @schema.@cdmTableName cdmTable
    ) violated_rows
) violated_row_count,
(
    SELECT 1 AS num_rows
) denominator
;
