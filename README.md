# Fincra Take-Home Project
## Overview
This repository contains a comprehensive analysis of payment data, developed as part of the Fincra take-home assignment. The project utilizes  PostgreSQL for data processing and analysis, with the entire workflow encapsulated in a Docker environment for ease of replication and deployment.

## Repository Structure
~
datasets/:
    chargebacks.csv: Dataset containing chargeback information.
    merchants.csv: Dataset detailing merchant information.
    transactions.csv: Dataset comprising transaction records.
~
create_clean.sql: SQL script for creating and cleaning database tables.
docker-compose.yml: Docker Compose file to set up the PostgreSQL database environment.
load_data_to_postgres.ipynb: Jupyter Notebook for loading data into the PostgreSQL database.
script.sql: SQL script containing queries used in the analysis.

## Getting Started
To replicate or explore the analysis, follow these steps:

1. Clone the Repository
~
git clone https://github.com/techacct/fincra_take_home.git
cd fincra_take_home
~

2. Set Up the Docker Environment
Ensure you have Docker and Docker Compose installed. The provided docker-compose.yml file will set up a PostgreSQL database.

~
docker-compose up -d
~
This command will start the PostgreSQL database in a Docker container.

3. Load Data into PostgreSQL
After setting up the Docker environment, load the datasets into the PostgreSQL database:
create_clean.sql: SQL script for creating and cleaning database tables.

Open and run the load_data_to_postgres.ipynb notebook to load the CSV data into the PostgreSQL database.

4. Perform the Analysis
With the data loaded, you can proceed to perform the analysis:

Open and run the Payment_Analysis.ipynb notebook to execute the analysis using PostgreSQL.

Alternatively, explore the DuckDB_Payment_Analysis.ipynb notebook for analysis using DuckDB.

Dependencies
Docker and Docker Compose

- Python 3.x
- Jupyter Notebook
 - Required Python libraries: pandas, numpy, sqlalchemy, psycopg2, duckdb

Install the Python dependencies using:

```pip install pandas numpy sqlalchemy psycopg2 

Additional Notes
Ensure the CSV files (transactions.csv, merchants.csv, chargebacks.csv) are placed in the datasets/ folder.

The docker-compose.yml file configures a PostgreSQL database with the following credentials:

Username: admin
Password: admin
Database: payt_company
Port: 5432



