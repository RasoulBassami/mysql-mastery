#!/bin/bash

# متغیرها را برای راحتی تعریف می‌کنیم
DB_USER="your_db_user"
DB_PASS="your_db_password"
DB_NAME="my_app"
BACKUP_DIR="/path/to/your/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql"

# --- گرفتن یک بک‌آپ کامل و بهینه (مناسب برای Production) ---
# از gzip برای فشرده‌سازی فایل بک‌آپ استفاده می‌کنیم تا حجم کمتری بگیرد
echo "Creating production-ready backup for database: $DB_NAME"
mysqldump -u $DB_USER -p$DB_PASS \
  --single-transaction \
  --routines \
  --triggers \
  $DB_NAME | gzip > "$BACKUP_FILE.gz"

echo "Backup created at: $BACKUP_FILE.gz"
echo "-------------------------------------"


# --- گرفتن بک‌آپ فقط از ساختار (Schema) ---
echo "Creating schema-only backup..."
mysqldump -u $DB_USER -p$DB_PASS --no-data $DB_NAME > "$BACKUP_DIR/schema_only.sql"
echo "Schema backup created."
echo "-------------------------------------"


# --- بازیابی یک بک‌آپ ---
# ابتدا فایل را از حالت فشرده خارج می‌کنیم
# gunzip < "$BACKUP_FILE.gz" > $BACKUP_FILE
#
# سپس آن را در یک دیتابیس جدید (یا همان دیتابیس) بازیابی می‌کنیم
# echo "Restoring backup..."
# mysql -u $DB_USER -p$DB_PASS $DB_NAME < $BACKUP_FILE
# echo "Restore complete."
# echo "-------------------------------------"


# --- نمونه یک Cron Job برای اجرای خودکار بک‌آپ هر شب ساعت ۲ بامداد ---
# این خط را باید در crontab سرور خود اضافه کنید (با دستور crontab -e)
# 0 2 * * * /path/to/your/script/examples.sh
