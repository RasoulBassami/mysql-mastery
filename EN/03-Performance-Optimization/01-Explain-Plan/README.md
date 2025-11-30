# Part 3, Lesson 1: Analyzing Slow Queries with `EXPLAIN`

-----

Whenever a query feels slow, your first and best friend is the `EXPLAIN` command.

`EXPLAIN` does not **execute** your query; instead, it shows you the **Execution Plan**. This map reveals MySQL's step-by-step strategy for finding and returning your data. It acts like an X-ray machine, allowing you to see inside the query process and identify bottlenecks.

### Usage

Using it is very simple. Just prepend the word `EXPLAIN` to your `SELECT` query:

```sql
EXPLAIN SELECT * FROM users WHERE id = 1;
```

The output is a table with various columns. We will focus on the most critical ones that provide 80% of the information you need.

-----

## Decoding the Output

Let's examine the key columns of the output.

### 1\. `type` Column (The Most Important Score)

This column indicates how MySQL accesses the data. It effectively grades your query performance. Values are ranked from Best (Fastest) to Worst (Slowest):

* **`const`:** Excellent\! Best possible scenario. MySQL found only one matching row using a `PRIMARY KEY` or `UNIQUE KEY`.
* **`eq_ref`:** Amazing. Usually seen in `JOIN`s where exactly one row is read from the second table using a key for each row in the first table.
* **`ref`:** Very Good. MySQL uses a non-unique index to find matching rows.
* **`range`:** Good. MySQL finds rows within a specific range using an index (e.g., `WHERE id > 100`).
* **`index`:** Average. MySQL scans the entire index tree. Better than a full table scan, but not ideal.
* **`ALL`:** **Disaster\! 🚨** This means MySQL found no suitable index and must perform a **Full Table Scan**, reading every single row from the disk. This is the main thing to avoid.

### 2\. `possible_keys` & `key` Columns

* **`possible_keys`:** A list of indexes MySQL **thinks** it could use.
* **`key`:** The index MySQL **actually** decided to use.

**Warning Sign:** If `possible_keys` shows an index but `key` is `NULL`, it means something (like a function on a column) is preventing the index from being used.

### 3\. `rows` Column

MySQL's **estimate** of how many rows it needs to examine to execute the query. The goal is to **keep this number low**. A high number here, especially with `type: ALL`, indicates a very inefficient query.

### 4\. `Extra` Column

Contains valuable additional information:

* **`Using index`:** Excellent\! This means a **Covering Index** is used. The query is answered purely from the index without touching the main table.
* **`Using where`:** Normal. It means a `WHERE` clause is used to filter rows.
* **`Using temporary`:** Bad. MySQL had to create a temporary table to process the query (usually for complex `GROUP BY` or `ORDER BY`).
* **`Using filesort`:** Bad. MySQL could not use an index for sorting (`ORDER BY`) and had to sort rows in a separate pass. This is a major cause of slowness in pagination.

-----

[🔼 Back to Chapter Index](../README.md) | [Next Lesson: Index Optimization ⏩](../02-Index-Level-Optimization/README.md)
