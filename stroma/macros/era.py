from sqlmesh import macro
from pathlib import Path

sqldir = Path(__file__).parent.joinpath("sql", "era")


@macro()
def calculate_condition_era(evaluator, schema: str) -> str:
    fragment = sqldir.joinpath("condition_era.sql").read_text()
    fragment = fragment.format(schema=schema)

    return fragment


@macro()
def calculate_drug_era(evaluator, schema: str) -> str:
    fragment = sqldir.joinpath("drug_era.sql").read_text()
    fragment = fragment.format(schema=schema, schema_vocab=schema)

    return fragment
