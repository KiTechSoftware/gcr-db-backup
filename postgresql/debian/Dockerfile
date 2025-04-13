FROM debian:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    postgresql-client \
    git \
    gnupg \
    curl \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /backup

# Copy backup script and entrypoint
COPY . .

# Set permissions
RUN chmod +x backup_script.sh entrypoint.sh

# Entry point for running backups
ENTRYPOINT ["/backup/entrypoint.sh"]
