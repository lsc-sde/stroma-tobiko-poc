from pathlib import Path
from typing import Tuple, Type
from sqlmesh.core.config import Config


from stroma.settings import (
    SQLMeshSettings,
    OMOPSettings,
    CdmSourceSettings,
)

layer = Path(__file__).parent.stem

cfg_cdm_source = CdmSourceSettings(
    cdm_source_name="IDRIL-1-",
    cdm_source_abbreviation="IDRIL-1-" + layer.upper(),
)
settings = {
    "cfg_visit_occurrence": {"start_date": "2018-01-01"},
    "cfg_cdm_source": dict(cfg_cdm_source.model_dump(mode="json")),
}

variables = OMOPSettings(
    project=layer,
    # src_catalog=os.getenv("DATABRICKS_CATALOG"),
    src_schema="gold",
    # dest_catalog=os.getenv("DATABRICKS_CATALOG"),
    settings={},
).model_dump(mode="json")


variables.update({"study_start_date": "2019-01-01"})
config = Config(**dict(SQLMeshSettings(project=layer, variables=variables)))
