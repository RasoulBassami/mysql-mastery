#!/bin/bash

# Define variables
DB_USER="your_db_user"
DB_PASS="your_db_password"
DB_NAME="my_app"
BACKUP_DIR="/path/to/your/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql"

# --- Create a Full, Optimized Backup (Production Ready) ---
# Using gzip to compress the backup file
echo "Creating production-ready backup for database: $DB_NAME"
mysqldump -u $DB_USER -p$DB_PASS \
  --single-transaction \
  --routines \
  --triggers \
  $DB_NAME | gzip > "$BACKUP_FILE.gz"

echo "Backup created at: $BACKUP_FILE.gz"
echo "-------------------------------------"


# --- Create Schema-Only Backup ---
echo "Creating schema-only backup..."
mysqldump -u $DB_USER -p$DB_PASS --no-data $DB_NAME > "$BACKUP_DIR/schema_only.sql"
echo "Schema backup created."
echo "-------------------------------------"


# --- Restore a Backup ---
# First, unzip the file
# gunzip < "$BACKUP_FILE.gz" > $BACKUP_FILE
#
# Then import it into a database
# echo "Restoring backup..."
# mysql -u $DB_USER -p$DB_PASS $DB_NAME < $BACKUP_FILE
# echo "Restore complete."
# echo "-------------------------------------"


# --- Example Cron Job for Daily Backup at 2 AM ---
# Add this line to your server's crontab (crontab -e)
# 0 2 * * * /path/to/your/script/examples.sh