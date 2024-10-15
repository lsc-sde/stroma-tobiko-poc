from sqlmesh import macro, SQL, ExecutionContext
import sqlglot.expressions as exp
from sqlglot import select, condition, case
from pathlib import Path

sqldir = Path(__file__).parent.joinpath("sql", "dqd")
