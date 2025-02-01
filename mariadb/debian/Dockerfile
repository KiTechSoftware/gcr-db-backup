FROM debian:latest

# Set working directory
WORKDIR /backup

# Copy backup script and entrypoint
COPY backup_job backup-db entrypoint.sh /usr/bin/

# Install required packages
RUN apt-get update && apt-get install -y \
    mariadb-client git gnupg curl openssh-client bash\
    && rm -rf /var/lib/apt/lists/* \
    # Set permissions
    chmod +x /usr/bin/backup_job /usr/bin/backup-db /usr/bin/entrypoint.sh && \
    # Add the backup script to the crontab for 24/7 backups
    echo "0 0 * * * /usr/bin/backup_job >> /backup/backup_job.log 2>&1" > /etc/crontabs/root

# Copy backup script and entrypoint
# Start cron and tail the log file
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["cron"]
