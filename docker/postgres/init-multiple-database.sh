#!/bin/bash

set -e
set -u

function create_user_and_database() {
    local database=$1
    local username=$2
    local password=$3
    
    echo "Creating user '$username' and database '$database'"
    
    # Check if user already exists
    if psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_roles WHERE rolname='$username'" | grep -q 1; then
        echo "  User '$username' already exists, skipping user creation"
    else
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
            CREATE USER $username WITH PASSWORD '$password';
EOSQL
        echo "  User '$username' created successfully"
    fi
    
    # Check if database already exists
    if psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -qw $database; then
        echo "  Database '$database' already exists, skipping database creation"
    else
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
            CREATE DATABASE $database;
            GRANT ALL PRIVILEGES ON DATABASE $database TO $username;
EOSQL
        echo "  Database '$database' created successfully"
    fi
    
    echo "  Finished processing '$username' and '$database'"
}

echo "Starting database initialization..."

# Wait a moment for PostgreSQL to be ready
sleep 5

# Metadata database
if [[ -n "${METADATA_DATABASE_NAME:-}" && -n "${METADATA_DATABASE_USERNAME:-}" && -n "${METADATA_DATABASE_PASSWORD:-}" ]]; then
    create_user_and_database "$METADATA_DATABASE_NAME" "$METADATA_DATABASE_USERNAME" "$METADATA_DATABASE_PASSWORD"
else
    echo "Metadata database variables not set, skipping..."
fi

# Celery result backend database
if [[ -n "${CELERY_BACKEND_NAME:-}" && -n "${CELERY_BACKEND_USERNAME:-}" && -n "${CELERY_BACKEND_PASSWORD:-}" ]]; then
    create_user_and_database "$CELERY_BACKEND_NAME" "$CELERY_BACKEND_USERNAME" "$CELERY_BACKEND_PASSWORD"
else
    echo "Celery backend database variables not set, skipping..."
fi

# ELT database
if [[ -n "${ELT_DATABASE_NAME:-}" && -n "${ELT_DATABASE_USERNAME:-}" && -n "${ELT_DATABASE_PASSWORD:-}" ]]; then
    create_user_and_database "$ELT_DATABASE_NAME" "$ELT_DATABASE_USERNAME" "$ELT_DATABASE_PASSWORD"
else
    echo "ELT database variables not set, skipping..."
fi

echo "All databases and users processed successfully"