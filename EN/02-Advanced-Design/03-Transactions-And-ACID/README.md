# Part 2, Lesson 3: Transactions & Understanding ACID

-----

How does a banking system ensure money is deducted from Account A and added to Account B without disappearing if the server crashes in between? The answer is **Transactions**.

A Transaction is a powerful mechanism in the InnoDB engine that allows you to execute one or more SQL statements as a **single, indivisible unit of work**.

> **Transaction Rule:** Either all statements inside it execute successfully, or if any error occurs, none of them are executed, and the database returns to its initial state. (All or Nothing).

-----

## ACID: The 4 Pillars of Reliability

The concept of transactions is built upon four properties abbreviated as **ACID**. Understanding these properties is essential for every senior developer.

### 1\. Atomicity ⚛️

Ensures the transaction is "atomic". It means either all operations (e.g., deducting from one account and adding to another) complete successfully, or none do. There is no such thing as a "half-done transaction".

### 2\. Consistency ✅

Ensures that every transaction transitions the database from one **Consistent State** to another. The database maintains its rules and constraints (like `FOREIGN KEY` or `NOT NULL`) before and after the transaction. For example, a transaction cannot result in a negative bank balance (if such a rule exists).

### 3\. Isolation 🏝️

Relates to **Concurrency**. When multiple transactions run simultaneously, `Isolation` ensures they don't interfere with each other. Each transaction runs in an isolated environment, as if it were the only one running in the system. This prevents issues like **Dirty Reads** (reading data that hasn't been committed yet). MySQL offers different isolation levels, which we'll cover in advanced topics.

### 4\. Durability 💾

Ensures that once a transaction is successfully **Commit**ted, its changes are **Permanent**, even in the event of a power loss or server crash. InnoDB achieves this by writing changes to Transaction Logs before applying them.

-----

### 💡 Pro Tip: Transactions for Speed (Bulk Operations)

Beyond **Safety**, transactions offer a massive **Speed** advantage for Bulk Operations.

* **Default (Autocommit):** By default, MySQL runs in `autocommit=1` mode. This means **every single SQL statement is treated as a transaction**.
* **The Problem:** When you run 100 `UPDATE` statements in a loop, you are effectively running **100 separate transactions**. To guarantee "Durability", InnoDB is **forced** to flush changes to the physical disk (Log File) after *each* statement. That’s 100 slow Disk I/O operations.
* **The Solution:** When you wrap statements in a `START TRANSACTION ... COMMIT` block, you tell InnoDB to log all 100 changes in memory and flush them to disk **only once** at the end.

**Result:** By bundling bulk operations in a transaction, you reduce the cost from **100 Disk writes** to **1 Disk write**, drastically improving speed.

-----

## Working with Transactions in SQL

There are three main commands for managing transactions:

* **`START TRANSACTION` (or `BEGIN`):** Starts a new transaction block.
* **`COMMIT`:** Finalizes the transaction. All changes made since `START TRANSACTION` are permanently saved to the database.
* **`ROLLBACK`:** Cancels the transaction. All changes made since `START TRANSACTION` are ignored, and the database reverts to the state before the transaction started.

### Classic Scenario: Bank Transfer

Let's see how a transaction prevents disaster.

**Without Transaction (Dangerous Way):**

```sql
-- 1. Deduct 100 from the first account
UPDATE accounts SET balance = balance - 100 WHERE id = 'A';

-- !!! If the server crashes right here, money is gone from A but never added to B!

-- 2. Add 100 to the second account
UPDATE accounts SET balance = balance + 100 WHERE id = 'B';
```

**With Transaction (Safe & Correct Way):**

```sql
START TRANSACTION;

-- Attempt operations
UPDATE accounts SET balance = balance - 100 WHERE id = 'A';
UPDATE accounts SET balance = balance + 100 WHERE id = 'B';

-- If both commands above succeed without error, finalize it.
COMMIT;

-- If an error occurs at any step (e.g., table lock or constraint violation),
-- we can (or the system will automatically) cancel the transaction.
-- ROLLBACK;
```

In this case, if the server crashes between the two `UPDATE`s, upon restart, InnoDB will automatically `ROLLBACK` the incomplete transaction, returning the database to its initial consistent state.

-----

[⏪ Previous Lesson: Advanced Indexing](../02-Advanced-Indexing/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: Views & Routines ⏩](../04-Views-And-Stored-Routines/README.md)

