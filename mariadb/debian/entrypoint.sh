#!/bin/sh

# Ensure that the backup log file exists
touch /backup/backup_job.log

if [ "$1" = "cron" ]; then
    # Start cron in the background
    crond
    # Tail the log file so the container stays alive
    tail -f /backup/backup_job.log
else
    # Execute any command provided
    exec "$@"
fi
