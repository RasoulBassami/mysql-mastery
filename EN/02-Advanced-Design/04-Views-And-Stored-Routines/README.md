# Part 2, Lesson 4: Using Views & Stored Routines

-----

Imagine having a complex query with multiple `JOIN`s that you use repeatedly across your application. For example, a query that fetches full product details along with category name, brand name, and stock count.

Should you copy-paste this complex query everywhere in your code? That leads to code duplication and maintenance nightmares. If the logic changes, you have to find and fix every copy.

This is where **Views** come to the rescue.

## What is a View?

A **View** is a **Virtual Table** based on the result of a `SELECT` query.

* **It's Virtual:** A View does not store data itself. It acts like a window or shortcut to the actual data stored in the base tables.
* **It's a Stored Query:** You can query a View just like a normal table (`SELECT * FROM my_view`), but behind the scenes, MySQL runs the original query defined in the View.

-----

## Why Use Views?

Using Views offers three main advantages:

### 1\. Simplify Complexity

You can encapsulate a complex query with multiple `JOIN`s, aggregate functions (`GROUP BY`), and calculations inside a View. Developers can then simply `SELECT` from this View to get the complex results without needing to know the underlying logic.

### 2\. Enhance Security

You can limit user access to data using Views.

* **Column Restriction:** Create a View that includes only non-sensitive columns (e.g., employee info without the salary column).
* **Row Restriction:** Create a View that includes only specific rows (e.g., `WHERE is_active = 1`).
  Then, grant users access to the View instead of the main table.

### 3\. Provide an Abstraction Layer

A View can act as a stable API for your database structure. You can change the underlying table structure (e.g., split a column into two), but as long as the View returns the same result format, applications using that View won't break and require no code changes.

-----

## Working with Views in SQL

Commands for Views are very simple.

**Create a View:**

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

**Update a View:**
If you want to change the query of an existing View, use `CREATE OR REPLACE VIEW` or `ALTER VIEW`.

```sql
CREATE OR REPLACE VIEW view_name AS
SELECT new_column_list...;
```

**Delete a View:**

```sql
DROP VIEW view_name;
```

**Important Note:** Dropping a View has **no effect** on the data in the base tables. Only the virtual table definition is removed.

### Drawbacks & Considerations

* **Performance:** Since a View is just a stored query, its performance is exactly that of the underlying query. If the original query is slow, the `SELECT` from the View will also be slow. Views do not perform optimization magic on their own.
* **Updatable Views:** In simple cases, you can run `UPDATE` or `INSERT` on a View, which updates the base table. However, this is often complex and error-prone, so it is generally not recommended.

-----

## Stored Routines: Procedures, Functions, and Triggers

Stored Routines allow you to store and execute logic directly on the MySQL server instead of keeping it only in your application code (e.g., PHP). This can improve performance, security, and code reusability.

### 1\. Stored Procedures

A **Stored Procedure** is a set of SQL statements stored under a name that you can execute using `CALL`. They are like functions in programming languages, except they **do not necessarily return a value**.

**Why use Stored Procedures?**

* **Reduce Network Traffic:** Instead of sending multiple complex queries from the app to the DB, you send just one `CALL` command, and all logic runs on the DB server.
* **Encapsulation:** You can place complex business logic (e.g., user registration involving `INSERT`s into multiple tables) into a procedure. This keeps code cleaner.
* **Security:** You can grant a user permission to execute a procedure without giving them direct access to the underlying tables.

**Simple Example:**

```sql
-- Procedure to add a new user
CREATE PROCEDURE sp_add_new_user(IN user_name VARCHAR(100), IN user_email VARCHAR(150))
BEGIN
    INSERT INTO users (name, email, password_hash)
    VALUES (user_name, user_email, 'default_password');
END;

-- Call the procedure
CALL sp_add_new_user('New User', 'new@example.com');
```

-----

### 2\. Stored Functions

A **Stored Function** is very similar to a procedure but with two key differences:

1.  **It MUST return a single value (`RETURN`).**
2.  It can be used directly inside SQL queries, just like built-in MySQL functions like `NOW()` or `CONCAT()`.

**Why use Stored Functions?**
To create reusable calculations or formatting that you want to leverage inside your `SELECT` queries.

**Simple Example:**

```sql
-- Function to get customer level based on order count
CREATE FUNCTION fn_get_customer_level(customer_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count FROM orders WHERE user_id = customer_id;

    IF order_count > 10 THEN
        RETURN 'Gold Customer';
    ELSEIF order_count > 5 THEN
        RETURN 'Silver Customer';
    ELSE
        RETURN 'Bronze Customer';
    END IF;
END;

-- Use function in a query
SELECT name, fn_get_customer_level(id) AS customer_level FROM users;
```

-----

### 3\. Triggers

A **Trigger** is a special type of routine that you do not call directly. Instead, it executes **automatically** in response to a specific event on a table.

Events are a combination of:

* **Time:** `BEFORE` or `AFTER`
* **Operation:** `INSERT`, `UPDATE`, `DELETE`

**Why use Triggers?**

* **Auditing:** Log all changes to a log table. E.g., every time an employee's salary changes, insert a record into `salary_changes`.
* **Enforcing Business Rules:** Implement rules that cannot be enforced by standard DB constraints.
* **Syncing Denormalized Data:** If you copied `author_name` to the `posts` table, an `AFTER UPDATE` trigger on `users` can update this change in all related posts.

**Important Note:** Use triggers with caution. Since they run in the background "magically", overuse can make application logic complex and **Debugging** difficult.

**Simple Example:**

```sql
-- Trigger to lowercase email before inserting a new user
CREATE TRIGGER trg_before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END;
```

In this example, `NEW` refers to the row about to be inserted.

-----

### ⚠️ Strategic Warning: The "Logic in Database" Trap

After seeing these powerful features, especially the speed of `Stored Procedures`, it's tempting to ask: **"Why not write all application logic in the database?"**

This is a common trap that can hurt your project in the long run.

1.  **Debugging & Testing:** Debugging a complex `LOOP` or `IF` in a Stored Procedure is a **nightmare**. Debugging PHP code is simple. Unit testing database logic is almost impossible.
2.  **Scalability:** This is the **most important** reason. Scaling App Servers (PHP) is easy and cheap (just add 10 more servers). Scaling a Database Server is **very hard and expensive**. By moving logic to the DB, you offload CPU processing from scalable app servers to the database (your main bottleneck).
3.  **Vendor Lock-in:** Your PHP code is portable. Your Stored Procedures written in MySQL syntax won't work on PostgreSQL or SQL Server.

**The Balance Rule:**

* ✅ **Use Views:** To simplify complex, repetitive `SELECT` queries (like reporting).
* ✅ **Use Stored Procedures:** For heavy **data-centric** operations (like archiving old data) or complex transactions that must be atomic.
* ❌ **Avoid Business Logic:** Keep core application logic (authentication, sending emails, payment processing) in the **Application Layer (PHP)**.

-----

[⏪ Previous Lesson: Transactions](../03-Transactions-And-ACID/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Chapter: Performance Optimization ⏩](../../03-Performance-Optimization/README.md)