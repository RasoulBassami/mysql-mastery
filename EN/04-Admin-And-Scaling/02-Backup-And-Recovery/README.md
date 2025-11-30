# Part 4, Lesson 2: Backup & Recovery

-----

Data is the most valuable asset of any application. A bug in the code can be fixed, but lost data cannot be replaced. **Backup** is your only lifeline against hardware failure, human error (a `DELETE` without `WHERE`), or malicious attacks.

> **Golden Rule:** A backup strategy without a tested recovery plan is meaningless. A backup you cannot restore is just a useless file.

-----

## Backup Types: Logical vs. Physical

There are two main approaches to database backup:

### 1\. Logical Backup

Exports the database as SQL commands (like `CREATE TABLE...`, `INSERT INTO...`). The output is a large, readable text file.

* **Main Tool:** `mysqldump`
* **Pros:**
  * **Flexible:** Can be restored on different MySQL versions, hardware, or even other database systems (with tweaks).
  * **Readable:** You can open the file to inspect or edit content.
* **Cons:**
  * **Slower Restore:** To restore, MySQL must execute all SQL commands line by line, which takes time.
  * Can be slow to create for very large databases (hundreds of GB).

### 2\. Physical Backup

Copies the actual binary files where the database stores data, instead of generating SQL.

* **Main Tool:** Percona XtraBackup (Popular open-source tool)
* **Pros:**
  * **Very Fast:** Both backup and restore are much faster as it only involves file copying.
* **Cons:**
  * **Less Flexible:** Usually requires restoring to the same MySQL version and OS.
  * **Not Readable:** Files are binary and not human-readable.

**Which one to choose?** For most small to medium applications (under 10-20 GB), `mysqldump` is perfectly sufficient, simple, and reliable.

-----

## Mastering `mysqldump`

This command-line tool is your Swiss Army Knife for logical backups.

**Key Options You Must Know:**

* `--single-transaction`: **Crucial for InnoDB.** Ensures a consistent backup snapshot without locking tables, keeping your app running.
* `--quick`: Vital for large databases. Prevents `mysqldump` from loading the entire table into RAM (which could crash the server) by reading rows one by one.
* `--routines` & `--triggers`: Ensures database logic (Stored Procedures and Triggers) is included.
* `--no-data`: Exports only the table structure (Schema) without data.

### 🚀 The Golden Command: Optimized & Compressed Backup

For a multi-gigabyte database, this is the best command. It takes the backup, compresses it on the fly (using `gzip`), and timestamps the filename.

```bash
mysqldump -u root -p \
    --single-transaction \
    --quick \
    --routines \
    --triggers \
    my_database_name | gzip > backup_$(date +%F).sql.gz
```

* **Why `gzip`?** SQL files are text and compress extremely well (usually 10:1 ratio). A 3GB database becomes \~300MB, making storage and transfer much faster.

### ☁️ Direct Transfer to Another Server (Streaming)

If you lack disk space on the source server or want to reduce I/O, you can stream the backup directly to another server (Backup Server) via SSH:

```bash
mysqldump -u root -p --single-transaction --quick my_db | gzip | ssh user@backup_server_ip "cat > /path/to/backups/backup_$(date +%F).sql.gz"
```

This method is highly professional as **not a single byte is written to the source server's disk**.

-----

### Backup Strategy & Rotation Policy

> **⚠️ Deadly Warning:** NEVER replace a new backup file with the previous one\!

If your database gets corrupted today and you overwrite yesterday's healthy backup with today's corrupted one, your data is **lost forever**.

**Correct Solution (Rotation):**
Keep multiple versions of backups (e.g., last 7 daily backups and 4 weekly backups). A simple script can automatically delete old files:

```bash
# Delete backup files older than 7 days
find /path/to/backups -name "*.sql.gz" -mtime +7 -delete
```

**Restore Command:**

```bash
gunzip < backup.sql.gz | mysql -u [username] -p [database_name]
```

-----

[⏪ Previous Lesson: Security](../01-Security/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sh) | [Next Lesson: Scalability ⏩](../03-Scalability/README.md)
