from sqlmesh import macro, SQL, ExecutionContext
import sqlglot.expressions as exp
from sqlglot import select, condition, case


@macro()
def get_observation_period_unified(
    evaluator,
    schema: exp.Schema,
    start_date: exp.Column,
    end_date: exp.Column,
) -> str:

    minimum_observation_period_start_date = evaluator.var(
        "minimum_observation_period_start_date"
    )

    columns = [
        ("device_exposure", "device_exposure_start_date", "device_exposure_start_date"),
        ("drug_exposure", "drug_exposure_start_date", "drug_exposure_start_date"),
        ("measurement", "measurement_date", "measurement_date"),
        ("observation", "observation_date", "observation_date"),
        ("procedure_occurrence", "procedure_date", "procedure_date"),
        ("specimen", "specimen_date", "specimen_date"),
        ("visit_occurrence", "visit_start_date", "visit_end_date"),
    ]
    span_template = """
    select
        distinct person_id ,
        coalesce(observation_period_start_date, observation_period_end_date) as observation_period_start_date,
        coalesce(observation_period_end_date, observation_period_start_date) as observation_period_end_date
    from
        (
        select
            t.person_id ,
            case
                when
                {start_date}::DATE >= '{minimum_observation_period_start_date}'
                and {start_date}::DATE <= current_date
                then {start_date}
                else null
            end as observation_period_start_date,
            case
                when {end_date}::DATE >= '{minimum_observation_period_start_date}'
                and {end_date}::DATE <= current_date
                then {end_date}
                else null
            end as observation_period_end_date
        from {schema}.{model} as t
        )
    where
        observation_period_start_date is not null
        or observation_period_end_date is not null
    """
    fragment_span = []
    for model, start_date, end_date in columns:
        fragment_span.append(
            span_template.format(
                model=model,
                start_date=start_date,
                end_date=end_date,
                minimum_observation_period_start_date=minimum_observation_period_start_date,
            )
        )
    fragment_span = " union ".join(fragment_span)

    fragment = f"""
SELECT DISTINCT
  person_id,
  first_value(observation_period_start_date) OVER (PARTITION BY person_id, group_id ORDER BY observation_period_start_date) AS observation_period_start_date,
  first_value(observation_period_end_date) OVER (PARTITION BY person_id, group_id ORDER BY observation_period_start_date DESC) AS observation_period_end_date
from (
    SELECT
    *,
    sum(CASE WHEN time_difference > 548 OR time_difference IS NULL THEN 1 ELSE 0 END) OVER (PARTITION BY person_id ORDER BY row_num) AS group_id
  FROM (

    SELECT
        person_id,
        observation_period_start_date,
        observation_period_end_date,
        row_number() OVER (PARTITION BY person_id ORDER BY observation_period_start_date) AS row_num,
        date_diff(
        'DAY',
        lag(observation_period_end_date) OVER (PARTITION BY person_id ORDER BY observation_period_start_date)::DATE,
        observation_period_start_date::DATE
        ) AS time_difference
    FROM {fragment_span}
    WHERE
        observation_period_start_date >= {minimum_observation_period_start_date}

)
)

    """

    return fragment


@macro()
def get_observation_period(
    evaluator,
    model: exp.Table,
    start_date: exp.Column,
    end_date: exp.Column,
) -> str:

    minimum_observation_period_start_date = evaluator.var(
        "minimum_observation_period_start_date"
    )

    # minimum_observation_period_start_date = "1900-01-01"

    fragment = f"""
select
    distinct person_id ,
    coalesce(observation_period_start_date, observation_period_end_date) as observation_period_start_date,
    coalesce(observation_period_end_date, observation_period_start_date) as observation_period_end_date
  from
    (
    select
        t.person_id ,
        case
            when
              {start_date}::DATE >= '{minimum_observation_period_start_date}'
              and {start_date}::DATE <= current_date
              then {start_date}
            else null
        end as observation_period_start_date,
        case
            when {end_date}::DATE >= '{minimum_observation_period_start_date}'
            and {end_date}::DATE <= current_date
            then {end_date}
            else null
        end as observation_period_end_date
    from {model} as t
    )
  where
    observation_period_start_date is not null
    or observation_period_end_date is not null
"""
    return fragment


@macro()
def get_observation_period_alternative(
    evaluator,
    model: exp.Table,
    start_date: exp.Column,
    end_date: exp.Column,
):

    exp.Condition()
    cond_1: exp.Case = (
        case()
        .when(
            condition(
                start_date >= evaluator.var("minimum_observation_period_start_date")
            ).and_(start_date <= exp.CurrentDate()),
            start_date,
        )
        .else_(condition=exp.null())
        .as_("observation_period_start_date")
    )
    cond_2: exp.Case = (
        case()
        .when(
            condition(
                end_date >= evaluator.var("minimum_observation_period_start_date")
            ).and_(end_date <= exp.CurrentDate()),
            end_date,
        )
        .else_(condition=exp.null())
        .as_("observation_period_end_date")
    )

    subquery1 = select("person_id", cond_1, cond_2).from_(model).distinct()

    return cond_1, cond_2
