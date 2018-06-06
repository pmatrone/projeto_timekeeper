#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER fabricads1 WITH PASSWORD 'Redhat@DS2017';
    CREATE DATABASE fabricads1;
    GRANT ALL PRIVILEGES ON DATABASE fabricads1 TO fabricads1;
EOSQL