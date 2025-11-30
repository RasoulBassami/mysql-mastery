# Part 4, Lesson 1: Security

-----

Database security has two main aspects:

* **Access Control:** Who is allowed to access what data and with what privileges (Read, Write, Delete).
* **Attack Prevention:** How to protect the database against common attacks like SQL Injection.

-----

## User Management & Privileges

In a real-world environment, you should **never** connect your application using the `root` user. The `root` user has the highest privileges, and if its credentials are compromised, your entire database server is at risk.

**Principle of Least Privilege:**

> This principle states that every user (or application) should have **only** the minimum privileges necessary to perform its function, and nothing more.

For example, a user responsible only for reporting should not have `DELETE` or `UPDATE` permissions.

### Key Management Commands

**`CREATE USER`**: Create a new user.

```sql
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'a_very_strong_password';
```

**Note:** The `'@'localhost'` part specifies that this user can only connect from the server itself. For remote access, you can use `'%'` (any IP) or a specific IP address.

**`GRANT`**: Assign privileges to a user.
You can grant privileges at different levels:

* **Global Level (`*.*`):** Access to all databases (Very Dangerous).
* **Database Level (`database_name.*`):** Access to all tables in a specific database.
* **Table Level (`database_name.table_name`):** Access to a specific table.

<!-- end list -->

```sql
-- Grant SELECT, INSERT, UPDATE on all tables in 'my_app' database to the app user
GRANT SELECT, INSERT, UPDATE ON `my_app`.* TO 'app_user'@'localhost';
```

**`REVOKE`**: Remove privileges from a user.

```sql
-- Remove UPDATE privilege from the app user
REVOKE UPDATE ON `my_app`.* FROM 'app_user'@'localhost';
```

**`DROP USER`**: Delete a user completely.

-----

## Preventing SQL Injection

**SQL Injection** is an attack where an attacker injects malicious SQL code through application inputs (like login forms or search bars) to manipulate or steal database data.

**Classic Vulnerable Code Example (PHP):**

```php
// !!! VERY INSECURE CODE !!!
$user_id = $_GET['id']; // Input could be: 105 OR 1=1
$sql = "SELECT * FROM users WHERE id = " . $user_id;
// Final Query: SELECT * FROM users WHERE id = 105 OR 1=1
// This query returns ALL users!
```

**How to Prevent It?**
The main defense against SQL Injection happens in the **Application Layer**, not the database.

* **Use Prepared Statements:**
  This is the best and safest method. In this approach, you first send the query template with placeholders (usually `?`) to the database, and then send the input values separately. In this state, the MySQL server never interprets the input data as part of the SQL code.

**Secure Example (PHP with PDO):**

```php
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_GET['id']]);
$user = $stmt->fetch();
```

Modern frameworks like **Laravel** (with Eloquent and Query Builder) use Prepared Statements by default and are resistant to SQL Injection as long as you don't use `DB::raw()` insecurely.

-----

[⏪ Previous Chapter: Performance Optimization](../../03-Performance-Optimization/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: Backup & Recovery ⏩](../02-Backup-And-Recovery/README.md)
