from dotenv import find_dotenv, load_dotenv

import os
import logging
from pathlib import Path
from sqlmesh.core.config import Config

from sqlmesh.core.config import (
    ModelDefaultsConfig,
    GatewayConfig,
    DatabricksConnectionConfig,
    PostgresConnectionConfig,
    DuckDBConnectionConfig,
    MSSQLConnectionConfig,
)
from sqlmesh.core.config.format import FormatConfig
from sqlmesh.core.config.ui import UIConfig
from sqlmesh.core.model import ModelKindName
from pydantic import BaseModel, computed_field, ConfigDict
from enum import Enum
from typing import Dict, Any, Optional

load_dotenv(find_dotenv(), override=True)

###############################################################################
# SQLMESH CONFIGURATION
###############################################################################


class EnumDefaultGateway(str, Enum):
    """
    Enumeration class representing the default gateway options.

    Attributes:
        DATABRICKS (str): Represents the Databricks gateway.
        MSSQL (str): Represents the MSSQL gateway.
        DUCKDB (str): Represents the DuckDB gateway.
    """

    DATABRICKS = "databricks"
    MSSQL = "mssql"
    DUCKDB = "duckdb"


class EnumMedallionLayer(str, Enum):
    BASE = os.getenv(
        f"{os.getenv('DEFAULT_GATEWAY', default='duckdb').upper()}_SCHEMA_BASE", "base"
    )
    BRONZE = "bronze"
    SILVER = "silver"
    GOLD = "gold"


state_schema: str = os.getenv("STATE_SCHEMA", "stroma")
default_gateway: str = os.getenv("DEFAULT_GATEWAY", EnumDefaultGateway.DUCKDB)

gateways = {}

# Setup gateways
# For each gateway, first check if a key environment variable is set.
# If the host is set, all other environment variables for that gateway must also be set or an error will be logged.


# Local duckdb
if os.getenv("DUCKDB_DATABASE"):
    try:
        database = str(Path(os.environ["DUCKDB_DATABASE"]).resolve())
        state_database = str(Path(os.environ["DUCKDB_STATE_DATABASE"]).resolve())

        gateway_duckdb = GatewayConfig(
            connection=DuckDBConnectionConfig(database=database),
            state_connection=DuckDBConnectionConfig(database=state_database),
            state_schema=state_schema,
        )

        gateways["duckdb"] = gateway_duckdb

    except Exception as e:
        logging.error(
            f"Error setting up DuckDb gateway.  Ensure all environment variables are set correctly. {e}"
        )

# Databricks
if os.getenv("DATABRICKS_SERVER_HOSTNAME"):
    try:
        gateway_databricks = GatewayConfig(
            connection=DatabricksConnectionConfig(
                server_hostname=os.environ["DATABRICKS_SERVER_HOSTNAME"],
                http_path=os.environ["DATABRICKS_HTTP_PATH"],
                catalog=os.environ["DATABRICKS_CATALOG"],
                concurrent_tasks=os.getenv("DATABRICKS_CONCURRENT_TASKS", default=4),
                access_token=os.environ["DATABRICKS_ACCESS_TOKEN"],
            ),
            state_connection=PostgresConnectionConfig(
                host=os.environ["DATABRICKS_STATE_DB_HOST"],
                port=os.environ["DATABRICKS_STATE_DB_PORT"],
                user=os.environ["DATABRICKS_STATE_DB_USER"],
                password=os.environ["DATABRICKS_STATE_DB_PASSWORD"],
                database=os.environ["DATABRICKS_STATE_DB_DATABASE"],
            ),
            state_schema=state_schema,
        )

        gateways["databricks"] = gateway_databricks

    except Exception as e:
        logging.error(
            f"Error setting up Databricks gateway. Ensure all environment variables are set correctly. {e}"
        )


# MSSQL
if os.getenv("MSSQL_HOST"):
    try:
        gateway_mssql = GatewayConfig(
            connection=MSSQLConnectionConfig(
                host=os.environ["MSSQL_HOST"],
                database=os.environ["MSSQL_DATABASE"],
                concurrent_tasks=os.getenv("MSSQL_CONCURRENT_TASKS", default=4),
            ),
            state_connection=MSSQLConnectionConfig(
                host=os.environ["MSSQL_STATE_DB_HOST"],
                database=os.environ["MSSQL_STATE_DB_DATABASE"],
            ),
            state_schema=state_schema,
        )

        gateways["mssql"] = gateway_mssql
    except Exception as e:
        logging.error(
            f"Error setting up MS SQL Server gateway. Ensure all environment variables are set correctly. {e}"
        )


class SQLMeshSettings(BaseModel):
    """
    SQLMeshSettings class represents the settings for SQLMesh.

    Attributes:
        project (str): The name of the project.
        model_defaults (ModelDefaultsConfig): The configuration for model defaults.
        gateways (dict): A dictionary of gateways, where the keys are the gateway names and the values are the corresponding gateway functions.
        default_gateway (str): The name of the default gateway.
        variables (dict): A dictionary of variables.
        format (FormatConfig): The configuration for formatting.
    """

    model_config = ConfigDict(protected_namespaces=())

    project: str
    model_defaults: ModelDefaultsConfig = ModelDefaultsConfig(
        kind=ModelKindName.VIEW, dialect="duckdb", cron="@daily", owner="LTH DST"
    )
    gateways: Dict[str, GatewayConfig] = gateways
    default_gateway: str = default_gateway
    variables: Dict[str, Any]
    format: FormatConfig = FormatConfig(
        append_newline=True,
        normalize=True,
        indent=2,
        normalize_functions="lower",
        leading_comma=False,
        max_text_width=80,
        no_rewrite_casts=False,
    )
    ui: UIConfig = UIConfig(format_on_save=True)


###############################################################################
# OMOP SETTINGS
###############################################################################


class OMOPSettings(BaseModel):
    settings: Optional[dict] = {}

    base: Optional[str] = EnumMedallionLayer.BASE
    bronze: Optional[str] = EnumMedallionLayer.BRONZE
    silver: Optional[str] = EnumMedallionLayer.SILVER
    gold: Optional[str] = EnumMedallionLayer.GOLD

    stg_bronze: Optional[str] = "stg_" + EnumMedallionLayer.BRONZE
    stg_silver: Optional[str] = "stg_" + EnumMedallionLayer.SILVER
    stg_gold: Optional[str] = "stg_" + EnumMedallionLayer.GOLD

    temp_bronze: Optional[str] = "temp_" + EnumMedallionLayer.BRONZE
    temp_silver: Optional[str] = "temp_" + EnumMedallionLayer.SILVER
    temp_gold: Optional[str] = "temp_" + EnumMedallionLayer.GOLD

    @computed_field
    @property
    def catalog_src(self) -> str:
        if default_gateway == EnumDefaultGateway.DATABRICKS:
            return os.getenv("DATABRICKS_CATALOG_SOURCE")
        elif default_gateway == EnumDefaultGateway.MSSQL:
            return os.getenv("MSSQL_DATABASE_SOURCE")
        elif default_gateway == EnumDefaultGateway.DUCKDB:
            return Path(os.getenv("DUCKDB_DATABASE")).stem


variables = OMOPSettings().model_dump(mode="json")


variables.update(
    {
        "global_start_date": "2005-01-01",
        "minimum_observation_period_start_date": "2005-01-01",
    }
)
config = Config(**dict(SQLMeshSettings(project="stroma", variables=variables)))
