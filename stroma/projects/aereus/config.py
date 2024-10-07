from pathlib import Path
from typing import Tuple, Type
from sqlmesh.core.config import Config

from stroma.settings import (
    SQLMeshSettings,
    OMOPSettings,
    CdmSourceSettings,
    EnumMedallionLayer,
)

layer = EnumMedallionLayer.BRONZE

cfg_cdm_source = CdmSourceSettings(
    cdm_source_name="IDRIL-1-" + layer.upper(),
    cdm_source_abbreviation="IDRIL-1-" + layer.upper(),
)
settings = {
    "cfg_visit_occurrence": {"start_date": "2018-01-01"},
    "cfg_cdm_source": dict(cfg_cdm_source.model_dump(mode="json")),
}


variables = OMOPSettings(
    layer=layer, settings={}, schema_src=EnumMedallionLayer.BASE
).model_dump(mode="json")


variables.update({"global_start_date": "2005-01-01"})
config = Config(**dict(SQLMeshSettings(project=layer, variables=variables)))
