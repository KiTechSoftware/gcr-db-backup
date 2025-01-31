#!/bin/sh

echo "Starting backup service..."

# Run backup every day at 2 AM
while true; do
    echo "Running database backup..."
    /backup/backup_script.sh
    echo "Backup completed. Sleeping for 24 hours..."
    sleep 86400  # Sleep for 24 hours
done
