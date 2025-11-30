# Part 1, Lesson 3: Relationships, Keys & Joins

-----

So far, we've learned to store data in tables with optimal types. But the real power of a Relational Database lies in **connecting** this data. In this lesson, we meet the "glue" that holds tables together: **Keys** and **Relationships**.

-----

## 🔑 Types of Keys: The Identity of Data

Keys are columns (or sets of columns) that play a specific role in identifying and linking rows.

### 1\. Primary Key (PK)

The Primary Key is the unique identity of each row in a table.

* **Rules:** Values must be **Unique** and **Cannot be `NULL`**. Each table can have only one Primary Key.
* **Best Practice:** The most common method is using a numeric column named `id` with `AUTO_INCREMENT`. This type of key, created solely to identify the record, is called a "Surrogate Key".

<!-- end list -->

```sql
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    email VARCHAR(150) NOT NULL,
    PRIMARY KEY (id)
);
```

### 2\. Foreign Key (FK)

The Foreign Key is the bridge connecting one table to another. It is a column in one table that points to the **Primary Key** of another table.

* **Goal:** Ensuring **Referential Integrity**. This means the database won't allow you to create an "orphan" record. For example, you cannot create an `order` for a `user_id` that doesn't exist in the `users` table.
* **Example:** In the `orders` table, the `user_id` column is a Foreign Key pointing to the `id` column in the `users` table.

<!-- end list -->

```sql
CREATE TABLE orders (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (fk_orders_users) REFERENCES users(id)
);
```

### 3\. Unique Key

A Unique Key ensures that all values in a column (or a set of columns) are unique.

* **Difference from Primary Key:**
  * A table can have multiple Unique Keys.
  * A Unique Key can accept a `NULL` value.
* **Use Case:** For columns that must be unique but aren't the primary identifier, like `email` or `username`.

<!-- end list -->

```sql
-- Adding a unique constraint to the email column
ALTER TABLE users ADD CONSTRAINT uk_email UNIQUE (email);
```

### The Concept of `INDEX` Simply Explained

An Index is like the index at the back of a book. Instead of flipping through the entire book to find a topic (Full Table Scan), you look at the index and go directly to the relevant page.

> In a database, an Index is a data structure that significantly speeds up search and retrieval operations. When you create an index on a column, the database keeps a sorted copy of that column's values to quickly find the desired row. (**Note:** In the InnoDB engine, indexing on the Primary Key has important structural differences compared to other columns, which we will cover fully in the "Advanced Design" chapter).

**Important Note:** Columns defined as `PRIMARY KEY` or `UNIQUE KEY` are automatically indexed by MySQL.

-----

## 🔗 JOIN Types: Combining Data from Tables

`JOIN` is a command that allows us to combine rows from two or more tables based on a common relationship (usually PK and FK).

### INNER JOIN

Returns only the rows that have matching values in **both tables**.

* **Example:** Show me users who have placed **at least one order**.

### LEFT JOIN

Returns **all rows** from the left table (first table) and the matched rows from the right table (second table). If a row in the left table has no match in the right table, the right table's columns will be `NULL`.

* **Example:** Show me **all users** and their orders if they have any. Users without orders will also be listed.

### RIGHT JOIN

The opposite of `LEFT JOIN`. Returns all rows from the right table.

* **Note:** Almost any `RIGHT JOIN` can be converted into a `LEFT JOIN` by swapping the tables. For better code readability, most developers prefer using only `LEFT JOIN`.

### CROSS JOIN

Returns the Cartesian product of the two tables. i.e., it combines every row of the first table with every row of the second table.

* **Warning:** This type of `JOIN` usually generates a massive number of rows and is rarely used in applications, except for specific cases like generating test data.

-----

[⏪ Previous Lesson: Data Types](../02-Data-Types/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Chapter: Advanced Design ⏩](../../02-Advanced-Design/README.md)
