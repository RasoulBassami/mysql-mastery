# Part 2, Lesson 1: Normalization & Denormalization

-----

Have you ever wondered why we split data across multiple tables? Why not store all shop information in a giant table called `everything`? The answer lies in **Normalization**.

Normalization is a step-by-step process to organize tables to minimize **Data Redundancy** and improve **Data Integrity**.

## 🤔 Why is Normalization Important?

A non-normalized table (like a messy Excel sheet) causes serious issues called **Anomalies**:

* **Insertion Anomaly:** You can't add a new author unless you also add a book for them.
* **Update Anomaly:** To change an author's email, you must update hundreds of rows. If one is missed, data becomes inconsistent.
* **Deletion Anomaly:** Deleting the only book of an author might accidentally delete the author's information entirely.

Normalization solves these problems by splitting data into smaller, related tables.

-----

## Normal Forms (The Rules)

Normalization has several levels or "forms". For 99% of practical work, knowing the first three forms is enough.

### 1st Normal Form (1NF): Atomic Data

> **Rule:** Every cell in the table must hold a single **Atomic** value, and there should be no repeating groups.

* **What means Atomic?** It means indivisible. You should not store multiple values separated by commas in a single column.

**❌ Bad Example (Non-1NF):**
A `books` table with a `tags` column storing multiple values.

| id   | title                | tags                      |
|:-----|:---------------------|:--------------------------|
| 1    | Learning SQL         | "MySQL, Database, SQL"    |
| 2    | Laravel Up & Running | "PHP, Laravel, Framework" |

**✅ Solution (Achieving 1NF):**
We split this data into separate tables and create a **Pivot Table** to manage the Many-to-Many relationship.

Table `books`:

| id   | title                |
|:-----|:---------------------|
| 1    | Learning SQL         |
| 2    | Laravel Up & Running |

Table `tags`:

| id   | name     |
|:-----|:---------|
| 1    | MySQL    |
| 2    | Database |
| 3    | PHP      |

Table `book_tag` (Pivot):

| book_id   | tag_id   |
|:-----------|:----------|
| 1          | 1         |
| 1          | 2         |
| 2          | 3         |

-----

### 2nd Normal Form (2NF): Full Dependency

> **Rule:** The table must be in 1NF, and all non-key columns must depend on the **entire Primary Key**. (This rule only applies to tables with a **Composite Primary Key**).

**❌ Bad Example (Non-2NF):**
Consider an `order_items` table with a composite key `(order_id, product_id)`.

| order_id   | product_id   | product\_name   | quantity   |
|:------------|:--------------|:----------------|:----------:|
| 101         | 1             | Laptop          |     1      |
| 101         | 2             | Mouse           |     2      |
| 102         | 1             | Laptop          |     3      |

Here, `product_name` depends only on `product_id`, not on the combination of `(order_id, product_id)`. This is redundant data. If the product name changes, we must update every row in this table.

**✅ Solution (Achieving 2NF):**
Move the `product_name` column to the `products` table.

Table `products`:

| id   | name   |
|:-----|:-------|
| 1    | Laptop |
| 2    | Mouse  |

Table `order_items`:

| order_id   | product_id   | quantity   |
|:------------|:--------------|:----------:|
| 101         | 1             |     1      |
| 101         | 2             |     2      |
| 102         | 1             |     3      |

-----

### 3rd Normal Form (3NF): No Transitive Dependency

> **Rule:** The table must be in 2NF, and no non-key column should depend on another non-key column.

* **What is Transitive Dependency?** It means column C depends on column B, and column B depends on Primary Key A. (`A -> B -> C`)

**❌ Bad Example (Non-3NF):**
Consider a `books` table.

| id | title | author_id | author\_email |
| :- | :--- | :---: | :--- |
| 1 | Learning SQL | 10 | ali@example.com |
| 2 | Advanced SQL | 10 | ali@example.com |

Here, `author_email` depends on `author_id`, and `author_id` depends on the primary key `id`. If the author changes their email, we must update all their books\!

**✅ Solution (Achieving 3NF):**
Move author information to an `authors` table.

Table `authors`:

| id   | name   | email           |
|:-----|:-------|:----------------|
| 10   | Ali    | ali@example.com |

Table `books`:

| id   | title        | author_id   |
|:-----|:-------------|:------------:|
| 1    | Learning SQL |      10      |
| 2    | Advanced SQL |      10      |

Now we have a **Single Source of Truth** for each entity's information.

-----

## ⚡️ Denormalization: Breaking Rules for Speed

**Denormalization** is the **intentional** process of adding redundant data to a table to improve **Read Performance**.

**Why do we do this?**
High normalization leads to more tables and, consequently, more `JOIN`s in queries. In systems with very high read traffic (like a reporting dashboard or a social media feed), these `JOIN`s can become a performance bottleneck.

**Example:**
In a blog, to show a list of posts along with the author's name, we must `JOIN` two tables: `posts` and `users`.

```sql
SELECT p.title, u.name
FROM posts p
JOIN users u ON p.user_id = u.id;
```

To avoid this `JOIN` every time, we can store the author's name directly in the `posts` table as well.

Table `posts` (Denormalized):

| id   | title    | user_id   | author\_name   |
|:-----|:---------|:----------:|:---------------|
| 1    | Post One |     10     | Ali            |

**The Trade-off:**

* **Pros:** Extremely fast reads because `JOIN` is no longer needed.
* **Cons:** Compromised data integrity and increased write complexity. If "Ali" changes their name, you must update not only the `users` table but also all their posts in the `posts` table.

> **Golden Rule:** Always start with a Normalized design. Only switch to Denormalization when **real data** and **monitoring tools** prove that a specific `JOIN` is causing a system slowdown.

-----

[🔼 Back to Chapter Index](../README.md) | [Next Lesson: Advanced Indexing ⏩](../02-Advanced-Indexing/README.md)
