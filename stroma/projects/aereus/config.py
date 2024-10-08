from pathlib import Path
from typing import Tuple, Type
from sqlmesh.core.config import Config

from stroma.settings import (
    SQLMeshSettings,
    OMOPSettings,
    CdmSourceSettings,
    EnumMedallionLayer,
)

source_layer = EnumMedallionLayer.BASE
target_layer = EnumMedallionLayer.BRONZE

cfg_cdm_source = CdmSourceSettings(
    cdm_source_name="IDRIL-1-" + target_layer.upper(),
    cdm_source_abbreviation="IDRIL-1-" + target_layer.upper(),
)
settings = {
    "cfg_visit_occurrence": {"start_date": "2018-01-01"},
    "cfg_cdm_source": dict(cfg_cdm_source.model_dump(mode="json")),
}


variables = OMOPSettings(
    layer=target_layer,
    schema_src=source_layer,
    settings={},
).model_dump(mode="json")


variables.update({"global_start_date": "2005-01-01"})
config = Config(**dict(SQLMeshSettings(project=target_layer, variables=variables)))
