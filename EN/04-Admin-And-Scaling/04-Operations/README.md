# Part 4, Lesson 4: Operations & Maintenance

-----

A database is a living system. Beyond initial design and optimization, you must be prepared for complex operations and daily challenges that arise in a large-scale system.

-----

## 1\. Bulk Data Transfer & Import

### Importing Massive Data Quickly

Suppose you need to import a CSV file with 10 million rows. Writing a script to insert rows one by one using `INSERT` will take hours (or days) and put massive pressure on the database.

**Solution: `LOAD DATA INFILE`**
This command reads data directly from a text file and writes it to the database at extreme speed, bypassing the SQL parser overhead.

```sql
LOAD DATA INFILE '/var/lib/mysql-files/products.csv' -- File path on server
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Ignore CSV header
```

> **💡 Architectural Tip (Vs. `mysqldump`):**
> With `LOAD DATA`, the entire operation is treated as **one single transaction**. If an error occurs at row 5 million, the previous 5 million rows are **ROLLBACK**ed, keeping the database clean.
> In standard methods (`INSERT` or `mysqldump`), if an error occurs halfway, the previous rows remain committed (Partial Import), creating a mess to clean up.

### Changing Schema of Massive Tables

A simple `ALTER TABLE` (e.g., adding a column) on a table with 500 million rows can lock the table for hours, causing total application **Downtime**.

**Solution: Online Schema Change Tools**
Never run `ALTER TABLE` directly on large tables in Production. Use specialized tools like **`pt-online-schema-change`** (Percona) or **`gh-ost`** (GitHub).
These tools create a copy (Ghost table), apply changes to it, sync data in the background, and finally swap the tables—all without locking the original table.

-----

## 2\. Locking & Deadlocks

To maintain integrity, InnoDB uses **Row-Level Locking**. However, conflicting lock requests can lead to a **Deadlock**.

### What is a Deadlock?

It occurs when two transactions are stuck in a **Cycle**: Transaction A waits for a resource held by B, and B waits for a resource held by A. Neither can proceed.
*(Note: Multiple transactions waiting for the same row is NOT a Deadlock; that's just "Lock Wait" or queuing).*

**InnoDB's Defense Mechanism:**
The database smartly detects the cycle and immediately selects one transaction as the "Victim", rolling it back to free up the resources for the other.

### Application Strategy (Retry Logic) 🔄

When the database sacrifices a transaction, it returns error code **`1213`**.
Since a Deadlock is a temporary issue (locks are released milliseconds later), the standard solution is to **Retry**.

**Correct Code Logic:**
Instead of showing an error to the user, the application should check the error code. If it's `1213`, it should restart the transaction from the beginning. Most modern frameworks have built-in tools for this.

### Debugging

If you see `Deadlock found` errors frequently in your logs, you need to investigate your query logic. Use this command to analyze the latest deadlock details:

```sql
SHOW ENGINE INNODB STATUS;
```

Look for the `LATEST DETECTED DEADLOCK` section in the output.

-----

[⏪ Previous Lesson: Scalability](../03-Scalability/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Chapter: Laravel Integration ⏩](../../05-Laravel-Integration/README.md)
