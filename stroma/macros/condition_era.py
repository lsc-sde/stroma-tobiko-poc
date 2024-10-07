from sqlmesh import macro, SQL, ExecutionContext
import sqlglot.expressions as exp
from sqlglot import select, condition, case
from pathlib import Path

here = Path(__file__).parent


@macro()
def calculate_condition_era(evaluator, schema: str) -> str:

    fragment = here.joinpath("sql", "condition_era.sql").read_text()
    fragment = fragment.format(schema=schema)

    return fragment
