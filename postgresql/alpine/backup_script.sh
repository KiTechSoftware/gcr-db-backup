#!/bin/sh

# Set up environment variables
DB_HOST=${DB_HOST:-db}
DB_USER=${DB_USER:-user}
DB_PASSWORD=${DB_PASSWORD:-password}
DB_NAME=${DB_NAME:-app_db}
BACKUP_DIR="/backup"
GPG_PASSPHRASE=${GPG_PASSPHRASE}
TEAMS_WEBHOOK=${TEAMS_WEBHOOK}
BACKUP_REPO_URL=${BACKUP_REPO_URL}

# Date Variables
TODAY=$(date +%Y%m%d)
DAY_OF_WEEK=$(date +%u)
DAY_OF_MONTH=$(date +%d)

# Backup filenames
DAILY_BACKUP="$BACKUP_DIR/daily_backup.sql"
ENCRYPTED_DAILY="$DAILY_BACKUP.gpg"

WEEKLY_BACKUP="$BACKUP_DIR/weekly_backup.sql.gpg"
MONTHLY_BACKUP="$BACKUP_DIR/monthly_backup.sql.gpg"

# Start backup process
echo "[$(date)] Starting database backup..."

export PGPASSWORD=$DB_PASSWORD

# Step 1: Dump the Database
if pg_dump -U "$DB_USER" -h "$DB_HOST" -d "$DB_NAME" > "$DAILY_BACKUP"; then
    echo "[$(date)] Database dump successful."
else
    echo "❌ ERROR: Database dump failed!"
    curl -H "Content-Type: application/json" -d '{"text": "❌ *Database Backup Failed!* \n- ❗ *Issue:* Database dump failed\n- 🕒 Timestamp: '"$(date)"'"}' "$TEAMS_WEBHOOK"
    exit 1
fi

# Step 2: Encrypt the Backup
if gpg --batch --yes --passphrase "$GPG_PASSPHRASE" --symmetric --cipher-algo AES256 --output "$ENCRYPTED_DAILY" "$DAILY_BACKUP"; then
    echo "[$(date)] Encryption successful."
    rm "$DAILY_BACKUP"
else
    echo "❌ ERROR: Encryption failed!"
    curl -H "Content-Type: application/json" -d '{"text": "❌ *Database Backup Failed!* \n- ❗ *Issue:* Encryption failed\n- 🕒 Timestamp: '"$(date)"'"}' "$TEAMS_WEBHOOK"
    exit 1
fi

# Step 3: Rotate Weekly and Monthly Backups
if [ "$DAY_OF_WEEK" -eq 7 ]; then
    cp "$ENCRYPTED_DAILY" "$WEEKLY_BACKUP"
fi

if [ "$DAY_OF_MONTH" -eq 01 ]; then
    cp "$ENCRYPTED_DAILY" "$MONTHLY_BACKUP"
fi

# Step 4: Push to GitHub
cd "$BACKUP_DIR"

if [ ! -d ".git" ]; then
    git init
    git remote add origin "$BACKUP_REPO_URL"
    git checkout -b main
fi

git add daily_backup.sql.gpg weekly_backup.sql.gpg monthly_backup.sql.gpg
git commit -m "Backup on $(date)" || echo "No changes to commit"
git push origin main

# Success Notification
curl -H "Content-Type: application/json" -d '{"text": "✅ *Database Backup Successful!* \n- 📂 *Daily Backup Updated*\n- 🕒 Timestamp: '"$(date)"'"}' "$TEAMS_WEBHOOK"

echo "[$(date)] Backup completed successfully!"
