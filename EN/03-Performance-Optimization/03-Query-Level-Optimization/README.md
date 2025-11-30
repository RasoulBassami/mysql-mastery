# Part 3, Lesson 3: Query-Level Optimization

-----

Even with the best indexes, a poorly written query can render all your efforts useless. Query-level optimization is about writing SQL that helps the MySQL **Optimizer** find the best execution path.

It's like giving clear instructions to a skilled librarian. Your library (indexes) is excellent, but your request (query) must be precise too.

-----

## ☠️ Common Anti-Patterns to Avoid

### 1\. Using `SELECT *`

This is the most common mistake. Always explicitly name only the columns you need.

**Why is `SELECT *` bad?**

* **Network Traffic & I/O:** You transfer unnecessary data from DB to App.
* **Kills Covering Indexes:** This is the main reason. If you have a perfect covering index on `(status, created_at)` for a query like `SELECT created_at FROM posts WHERE status = 'published'`, using `SELECT *` forces MySQL to go back to the main table to fetch all other columns, destroying the optimization advantage.

### 2\. Using Functions on Indexed Columns in `WHERE`

This is a performance killer. If you apply a function to a column in the `WHERE` clause, MySQL **cannot use the index** on that column.

**❌ Bad Example:**

```sql
-- This query will NEVER use the index on `created_at`
SELECT * FROM orders WHERE YEAR(created_at) = 2025;
```

MySQL has to run the `YEAR()` function on **every single row** to check the condition.

**✅ Good Example (SARGable Query):**
Rewrite the query so the indexed column stands alone on one side.

```sql
-- Uses the index for a range search
SELECT * FROM orders WHERE created_at >= '2025-01-01' AND created_at < '2026-01-01';
```

### 3\. Using `LIKE` with a Leading Wildcard (`%`)

Indexes are sorted like a phone book. You can quickly find names starting with "A", but you can't find names ending in "a" without reading the whole book.

* `WHERE name LIKE 'Ali%'`: **Can** use the index.
* `WHERE name LIKE '%Ali'`: **Cannot** use the index (Full Table Scan).

**Solution:** For complex text searches, use **Full-Text Search**, which we will cover later.

-----

## 🚀 Efficient Query Techniques

### 1\. Optimized Pagination with Keyset Pagination

Pagination using `OFFSET` gets very slow on deep pages. `LIMIT 10 OFFSET 1000000` means "Read 1,000,010 rows, throw away the first million, and return 10". This process becomes slower as `OFFSET` increases.

**Solution: Keyset Pagination (or Seek Method)**
Instead of page number, pass the `id` (or any other sort column) of the last row seen on the previous page.

**❌ Slow Way:**

```sql
-- Go to page 2
SELECT * FROM posts ORDER BY id LIMIT 10 OFFSET 10;
```

**✅ Fast Way:**

```sql
-- Assuming the last ID on page 1 was 10
SELECT * FROM posts WHERE id > 10 ORDER BY id LIMIT 10;
```

This method stays fast regardless of how deep you go into the pages.

### 2\. `UNION ALL` instead of `UNION`

Both commands combine results from two queries, but with a big difference:

* `UNION`: Combines results and performs a heavy operation to **remove duplicate rows**.
* `UNION ALL`: Just concatenates results without checking for duplicates.

> **Golden Rule:** If you know results won't have duplicates or duplicates don't matter, **always** use `UNION ALL`. It is significantly faster.

-----

[⏪ Previous Lesson: Index Optimization](../02-Index-Level-Optimization/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: Architecture Optimization ⏩](../04-Architecture-Level-Optimization/README.md)
