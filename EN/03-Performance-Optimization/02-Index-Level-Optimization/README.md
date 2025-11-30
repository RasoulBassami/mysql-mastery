# Part 3, Lesson 2: Index-Level Optimization

-----

In the "Advanced Design" chapter, we covered the basics of indexing. Now, we refine that knowledge to build indexes that act like surgical instruments: precise, fast, and efficient.

Here are three key concepts to maximize index potential.

-----

## 1\. Cardinality: Your Best Friend in Index Selection

**Cardinality** simply refers to the **number of unique values** in a column.

* **High Cardinality:** Columns like `email` or `username`. Almost every row has a different value.
* **Low Cardinality:** Columns like `gender` (Male, Female) or `is_active` (0, 1). Very few unique values exist.

**Golden Rule of Cardinality:**

> Indexes are far more effective on columns with **High Cardinality**.

**Why?**
Think of a book index. If a keyword in the index points to 100 different pages, it's not very helpful. But if it points to exactly 1 or 2 specific pages, it's highly efficient.
An index on `gender` is like the first case; it directs the database to a huge portion of the table (e.g., 50%), offering little help. An index on `email` pinpoints the exact row.

**Application in Composite Indexes:**
When building a composite index, put the column with higher cardinality **first**. This allows MySQL to narrow down the dataset significantly in the very first step.

`INDEX(user_id, status)` is **usually** better than `INDEX(status, user_id)`.

-----

## 2\. Covering Index: Peak Performance

We introduced this concept before, but it's worth repeating due to its immense value.

A **Covering Index** is an index that contains **all columns required by a query** (in `SELECT`, `WHERE`, etc.). This means MySQL can answer the query **just by reading the index** and **skipping the main table lookup entirely**.

**Example:**
Suppose you have this frequent query:

```sql
SELECT sender_id, recipient_id, sent_at FROM messages WHERE conversation_id = 123;
```

To optimize this, create a covering index:

```sql
CREATE INDEX idx_conversation_cover ON messages (conversation_id, sender_id, recipient_id, sent_at);
```

**Analysis:**

* `conversation_id`: First, because it's in the `WHERE` clause for filtering.
* `sender_id`, `recipient_id`, `sent_at`: Added to cover the `SELECT` clause.

Now, MySQL reads everything from `idx_conversation_cover` and never touches the massive `messages` table on disk. This creates a massive speed difference for large tables.

-----

## 3\. Index Prefixes: Optimizing Large Text Columns

What happens if you want to index a `VARCHAR(500)` or `TEXT` column? Creating an index on the full content takes up huge space and can slow down the index itself.

**Solution: Index Prefix**
You can tell MySQL to index only the **first N characters** of a text column.

```sql
CREATE INDEX idx_url_prefix ON logs (url(255));
```

In this example, we only index the first 255 characters of the `url` column.

**How to choose the length?**
The goal is to pick a prefix long enough to distinguish most values but short enough to save space. You can test "uniqueness" with this query:

```sql
SELECT
  COUNT(DISTINCT LEFT(column_name, 10)) / COUNT(*) AS selectivity_10,
  COUNT(DISTINCT LEFT(column_name, 20)) / COUNT(*) AS selectivity_20,
  COUNT(DISTINCT LEFT(column_name, 50)) / COUNT(*) AS selectivity_50
FROM your_table;
```

The closer the result is to 1, the better suited that length is for your index.

**Important Note:** Prefix indexes cannot be used for `ORDER BY` or as a full Covering Index, since the full column value isn't present in the index.

-----

[⏪ Previous Lesson: EXPLAIN](../01-Explain-Plan/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: Query Optimization ⏩](../03-Query-Level-Optimization/README.md)
