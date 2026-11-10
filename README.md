Financial Market ELT Pipeline

An end-to-end, containerized ELT data pipeline that extracts multi-asset financial feeds (Equities, Cryptocurrencies, Commodities), stages raw data in a local Parquet lake, loads it into a Dockerized PostgreSQL warehouse, and models it into an analytics-ready Kimball Star Schema using dbt Core with automated data assertions.

Architecture Overview

flowchart LR
    A[Yahoo Finance API] -->|extract_to_bronze.py| B[(Bronze: Parquet Lake)]
    B -->|load_to_silver.py| C[(Silver: PostgreSQL Raw)]
    C -->|dbt View| D[stg_market_prices]
    D -->|dbt Models| E[(Gold: Star Schema)]
    E --> F[13 Automated dbt Tests]
    E --> G[Power BI / BI Tools]


Tech Stack

Storage & Warehouse: PostgreSQL 15 (Docker), Apache Parquet

Transformation & Testing: dbt Core (dbt-postgres)

Ingestion & Processing: Python 3.11 (pandas, pyarrow, sqlalchemy, yfinance)

Infrastructure: Docker Compose

Dimensional Data Model (Kimball Star Schema)

The analytical gold layer implements a Star Schema designed to support financial analytics, temporal slicing, and BI reporting:

fct_market_prices (Fact Table):

Grain: One record per asset per trading day.

Primary Surrogate Key: price_surrogate_key generated via MD5(ticker || '_' || price_date).

Foreign Keys: asset_id, date_id.

Metrics: open_price, high_price, low_price, close_price, trading_volume.

Calculated Analytical Fields:

daily_return_pct: Percentage change calculated via LAG(close_price, 1) OVER (PARTITION BY ticker ORDER BY price_date).

moving_avg_7d: Rolling 7-day closing average calculated via AVG(close_price) OVER (PARTITION BY ticker ORDER BY price_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW).

dim_assets (Dimension Table):

Attributes: asset_id (Surrogate Key), ticker, asset_class (Cryptocurrency, Equity ETF, Commodity ETF), currency.

dim_date (Dimension Table):

Attributes: date_id (Integer formatted YYYYMMDD), price_date, year, month, day, day_name, quarter.

Key Engineering Decisions

Idempotency & Dependency Preservation: Instead of using destructive full-table replacements (if_exists="replace"), the Silver staging layer executes transactional TRUNCATE operations followed by appended inserts. This prevents dropping base database relations and protects dependent downstream dbt views from compilation errors (DependentObjectsStillExist).

Medallion Architecture Separation:

Bronze Layer: Raw data is stored locally as compressed Parquet files partitioned by ticker and ingestion timestamp, serving as an immutable raw audit log.

Silver Layer: Raw tables and typed staging views normalize schema types, parse ISO dates, and filter corrupted records.

Gold Layer: Fully materialized tables optimized with primary keys, foreign key references, and analytical calculations.

Automated Data Quality Suite: 13 dbt test assertions run on every execution to enforce:

Primary key uniqueness on fact and dimension tables.

NOT NULL constraints across critical business columns.

Referential integrity between dimension surrogates and the central fact table.

Repository Structure

├── data_lake/               # Local Bronze Parquet lake (ignored by Git)
├── models/
│   ├── staging/             # Silver views & source configurations
│   │   ├── sources.yml
│   │   └── stg_market_prices.sql
│   └── marts/               # Gold dimension and fact tables
│       ├── dim_assets.sql
│       ├── dim_date.sql
│       ├── fct_market_prices.sql
│       └── schema.yml       # Automated dbt tests
├── docker-compose.yml       # PostgreSQL database container specification
├── extract_to_bronze.py     # Bronze ingestion script (Yahoo Finance to Parquet)
├── load_to_silver.py        # Silver loading & staging script (Parquet to Postgres)
├── run_pipeline.py          # Unified pipeline runner with logging & telemetry
├── profiles.yml             # dbt connection profiles
├── dbt_project.yml          # dbt project configurations
├── requirements.txt         # Project dependencies
└── README.md                # Project documentation


Getting Started

1. Prerequisites

Docker Desktop installed and running

Python 3.10+

2. Environment Setup

git clone https://github.com/MO-GEMY/financial-market-elt-pipeline.git
cd financial-market-elt-pipeline
python -m venv venv
# On Windows:
.\venv\Scripts\activate
# On Linux/macOS:
source venv/bin/activate
pip install -r requirements.txt


3. Spin Up the Database Container

docker compose up -d


4. Execute the End-to-End Pipeline

Run the unified orchestrator to execute extraction, staging, dbt transformations, and data quality tests in a single command:

python run_pipeline.py


5. Generate and View dbt Documentation & Lineage DAG

dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir . --port 8080


Navigate to http://localhost:8080 to inspect table schemas, column descriptions, and interactive lineage graphs.