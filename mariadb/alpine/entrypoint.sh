#!/bin/sh
if [ "$1" = "cron" ]; then
    # Start cron in the background
    crond
    # Tail the log file so the container stays alive
    tail -f /backup/backup_job.log
else
    # Execute any command provided
    exec "$@"
fi
