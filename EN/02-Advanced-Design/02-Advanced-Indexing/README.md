# Part 2, Lesson 2: Advanced Indexing

-----

In Part 1, we briefly said an index is like the back of a book. Now, we dive deeper to learn how to design smart and optimal indexes.

Knowing *that* you need an index is good; knowing **what type**, on **which columns**, and in **what order** is expert-level.

-----

### How Indexes Work Behind the Scenes: B-Tree

In the InnoDB engine, indexes are typically implemented using a data structure called **B-Tree**. A B-Tree keeps data **sorted**, allowing for very fast search, insertion, and deletion.

The most important thing to know about B-Tree is that **data is sorted**. Because of this, B-Tree indexes are incredibly efficient for:

* **Exact Match:** `WHERE id = 100`
* **Range Search:** `WHERE price > 5000`
* **Sorting:** `ORDER BY created_at`

-----

### Most Important Concept: Composite Index

A Composite Index is an index created on two or more columns simultaneously. This is where the art of index design shines.

**Golden Rule: Column Order is Critical\!**

A composite index is like a phone book sorted first by **Last Name**, and then by **First Name**.

Suppose we have an index on `(last_name, first_name)`:

* **Query `WHERE last_name = 'Smith' AND first_name = 'John'`:** Very fast. Like finding "Smith, John" in the phone book.
* **Query `WHERE last_name = 'Smith'`:** Fast. You go to the "S" section and find all Smiths.
* **Query `WHERE first_name = 'John'`:** **Very Slow\!** This is like trying to find everyone named "John" in the phone book. Since the book isn't sorted by first name, you have to flip through the entire book (Full Table Scan).

This concept is known as the **Left-Prefix Rule**. A query can only use a composite index if it uses the leftmost columns of the index in its `WHERE` clause.

#### How to Choose Column Order?

1.  **Prioritize High Cardinality:** The column with more unique values (higher cardinality) should come first. For example, in an index on `(status, user_id)`, `user_id` has much higher cardinality than `status` (which might only have a few values). So, `(user_id, status)` is usually better.
2.  **Based on Queries:** Design the index to cover your most frequent queries.

-----

### The Ultimate Speed: Covering Index

A Covering Index happens when **all columns required by a query** (including `SELECT`, `WHERE`, `ORDER BY`) are present in the index itself.

**Why is it so fast?**
Because MySQL can provide the query result **just by reading the index**, without needing to refer back to the main table (which is on disk). This eliminates a full step of Disk I/O. In the output of `EXPLAIN`, this is indicated by `Using index` in the `Extra` column.

**Example:**
Suppose we have the following query:

```sql
SELECT id, email FROM users WHERE status = 'active';
```

* **Simple Index:** `INDEX(status)` helps MySQL find rows quickly, but it must go to the main table to read `id` and `email`.
* **Covering Index:** `INDEX(status, email, id)` is a covering index. MySQL reads `status` for filtering, and `email` and `id` for the `SELECT` part directly from the index itself.

-----

### ☠️ Indexing Anti-Patterns (Traps)

Knowing when *not* to index is as important as building one. Avoid these two common mistakes:

* **Trap 1: Individual Index per Column:**
  It's tempting to create a separate index on every column used in `WHERE` (e.g., `INDEX(status)` and `INDEX(user_id)`). This is **very inefficient**. For a query like `WHERE status = 'X' AND user_id = Y`, the MySQL optimizer struggles to use both indexes effectively. The correct solution is a **Composite Index** `INDEX(status, user_id)` which answers the query in one go. Remember, every extra index significantly slows down write operations (`INSERT`, `UPDATE`).

* **Trap 2: The Giant Index:**
  Creating a massive index on all columns `(a, b, c, d)` is useless for a query `WHERE d = ...` due to the **Left-Prefix Rule**, and it needlessly slows down writes.

**Golden Rule:** Instead of many random indexes, build a **few smart composite indexes** that serve your most frequent queries as **Covering Indexes**.

-----

### Concepts for Senior Engineers

* **Clustered Index:** In InnoDB, the Primary Key *is* the Clustered Index. This means the actual table data is physically sorted on disk based on the Primary Key order. That's why searching by Primary Key is the fastest possible operation. Each table has only one Clustered Index.
* **Secondary Index:** Any index other than the Primary Key is a Secondary Index. These indexes store the indexed column's value and a **pointer** to the Primary Key. So, searching with these usually involves two steps: finding the pointer in the Secondary Index, and then finding the actual data using that pointer in the Clustered Index.

-----

[⏪ Previous Lesson: Normalization](../01-Normalization/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: Transactions ⏩](../03-Transactions-And-ACID/README.md)
