FROM alpine:latest

# Install required packages
RUN apk add --no-cache postgresql-client git gnupg curl openssh-client

# Set working directory
WORKDIR /backup

# Copy backup script and entrypoint
COPY . .

# Set permissions
RUN chmod +x backup_script.sh entrypoint.sh

# Entry point for running backups
ENTRYPOINT ["/backup/entrypoint.sh"]
