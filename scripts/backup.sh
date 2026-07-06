#!/bin/bash

set -e

BACKUP_DIR="backups"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/hotel_backup_$TIMESTAMP.sql"

docker exec postgres-db pg_dump \
-U postgres \
-d hotel \
> "$BACKUP_FILE"

echo "Backup completed successfully."
echo "Backup File: $BACKUP_FILE"
