from dotenv import find_dotenv, load_dotenv

load_dotenv(find_dotenv())

import os
from sqlmesh.core.config import (
    Config,
    ModelDefaultsConfig,
    GatewayConfig,
    DatabricksConnectionConfig,
    PostgresConnectionConfig,
    DuckDBConnectionConfig,
    MSSQLConnectionConfig,
)
from sqlmesh.core.config.format import FormatConfig
from sqlmesh.core.model import ModelKindName
from pydantic import BaseModel, computed_field, Field, ConfigDict
from enum import Enum
from typing import Dict, Any, Optional
from datetime import date
from pathlib import Path

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

    BASE = os.getenv(f"{os.getenv('DEFAULT_GATEWAY').upper()}_SCHEMA_BASE", "base")
    BRONZE = "bronze"
    SILVER = "silver"
    GOLD = "gold"


state_schema: str = os.getenv("STATE_SCHEMA", "stroma")
default_gateway: str = os.getenv("DEFAULT_GATEWAY", EnumDefaultGateway.DATABRICKS)

# Local duckdb

database = os.getenv("DUCKDB_DATABASE")

gateway_duckdb = GatewayConfig(
    connection=DuckDBConnectionConfig(database=os.getenv("DUCKDB_DATABASE")),
    state_connection=DuckDBConnectionConfig(
        database=os.getenv("DUCKDB_STATE_DATABASE")
    ),
    state_schema=state_schema,
)

# Databricks

gateway_databricks = GatewayConfig(
    connection=DatabricksConnectionConfig(
        server_hostname=os.getenv("DATABRICKS_SERVER_HOSTNAME"),
        http_path=os.getenv("DATABRICKS_HTTP_PATH"),
        catalog=os.getenv("DATABRICKS_CATALOG"),
        concurrent_tasks=os.getenv("DATABRICKS_CONCURRENT_TASKS", 4),
        access_token=os.getenv("DATABRICKS_ACCESS_TOKEN"),
    ),
    state_connection=PostgresConnectionConfig(
        host=os.getenv("DATABRICKS_STATE_DB_HOST"),
        port=os.getenv("DATABRICKS_STATE_DB_PORT"),
        user=os.getenv("DATABRICKS_STATE_DB_USER"),
        password=os.getenv("DATABRICKS_STATE_DB_PASSWORD"),
        database=os.getenv("DATABRICKS_STATE_DB_DATABASE"),
    ),
    state_schema=state_schema,
)

# MSSQL

gateway_mssql = GatewayConfig(
    connection=MSSQLConnectionConfig(
        host=os.getenv("MSSQL_HOST"),
        database=os.getenv("MSSQL_DATABASE"),
        concurrent_tasks=os.getenv("MSSQL_CONCURRENT_TASKS", 4),
    ),
    state_connection=MSSQLConnectionConfig(
        host=os.getenv("MSSQL_STATE_DB_HOST"),
        database=os.getenv("MSSQL_STATE_DB_DATABASE"),
    ),
    state_schema=state_schema,
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
    gateways: Dict[str, GatewayConfig] = {
        "databricks": gateway_databricks,
        "mssql": gateway_mssql,
        "duckdb": gateway_duckdb,
    }
    default_gateway: str = default_gateway
    variables: Dict[str, Any]
    format: FormatConfig = FormatConfig(
        append_newline=True,
        normalize=True,
        indent=2,
        normalize_functions="lower",
        leading_comma=False,
        max_text_width=80,
    )


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
