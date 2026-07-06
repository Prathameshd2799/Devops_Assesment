#!/bin/bash

set -e

LATEST_BACKUP=$(ls -t backups/*.sql | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "No backup file found."
    exit 1
fi

cat "$LATEST_BACKUP" | docker exec -i postgres-db psql \
-U postgres \
-d hotel
echo "Database restored successfully."
echo "Backup Used: $LATEST_BACKUP"
