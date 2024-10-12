from pathlib import Path
from typing import Tuple, Type
from sqlmesh.core.config import Config

from stroma.settings import (
    SQLMeshSettings,
    OMOPSettings,
)

variables = OMOPSettings().model_dump(mode="json")


variables.update(
    {
        "global_start_date": "2005-01-01",
        "minimum_observation_period_start_date": "2005-01-01",
    }
)
config = Config(**dict(SQLMeshSettings(project="stroma", variables=variables)))
