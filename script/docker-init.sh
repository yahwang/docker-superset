#!/usr/bin/env bash

set -e

# Create an admin user (you will be prompted to set username, first and last name before setting a password)
flask fab create-admin \
  --username "$1" \
  --firstname "$2" \
  --lastname "$3" \
  --email "$4" \
  --password "$5" \

# Initialize the database
superset db upgrade

# Create default roles and permissions
superset init
