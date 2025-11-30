# Part 1, Lesson 2: Data Types & Optimal Selection

-----

Choosing the right data type for your table columns is one of the most fundamental yet impactful skills in database design. It's like choosing the right-sized box for an item; a box too big wastes space, and a box too small breaks the content.

Proper Data Type selection serves two main goals:

1.  **Data Integrity:** The database prevents invalid data from being stored. For example, you cannot store text in a numeric column.
2.  **Space & Performance Optimization:** Using the smallest possible data type reduces table size. Smaller tables mean less disk usage, faster data transfer, and fitting more data into RAM, all leading to **Higher Speed**.

-----

## 🔢 Numeric Types

For storing numbers, the `INTEGER` family offers various options with different sizes.

| Type        | Storage Size   | Range (Signed)                 | Range (Unsigned)       |
|:------------|:--------------:|:-------------------------------|:-----------------------|
| `TINYINT`   |     1 Byte     | -128 to 127                    | 0 to 255               |
| `SMALLINT`  |    2 Bytes     | -32,768 to 32,767              | 0 to 65,535            |
| `MEDIUMINT` |    3 Bytes     | -8,388,608 to 8,388,607        | 0 to 16,777,215        |
| `INT`       |    4 Bytes     | \~ -2.1 Billion to 2.1 Billion | \~ 0 to 4.2 Billion    |
| `BIGINT`    |    8 Bytes     | Massive\! (\~9 Quintillion)    | \~ 0 to 18 Quintillion |

**Golden Rule for Numbers:**

> Always choose the **smallest** data type that can reliably hold the **largest possible value** for that column.

* **Example 1:** For an `age` column, `TINYINT UNSIGNED` is perfect because age is never negative and won't exceed 255.
* **Example 2:** For a `status` column with values between 0 and 5, `TINYINT UNSIGNED` is the best choice. Using `INT` here is a pure waste of space.
* **Example 3:** For user `id`s, `INT UNSIGNED` (4.3 Billion capacity) might seem enough for most sites. However, using **`BIGINT UNSIGNED`** from the start is considered a **Professional Standard**.

**Important Note: `INT` vs `BIGINT`**

> Choosing `BIGINT` for Primary Keys is cheap "insurance" against a catastrophic risk in the future. The cost of changing `INT` to `BIGINT` on a massive table (using `ALTER TABLE`) can cause days of downtime. The cost of 4 extra bytes for `BIGINT` is negligible compared to this risk. That's why modern frameworks like Laravel use `BIGINT` by default.

#### 💡 Important Note: High-Value Currencies (e.g., Won, Yen)

When working with zero-decimal currencies like **South Korean Won (KRW)** or **Japanese Yen (JPY)**, numbers can get massive very quickly.
For example, a luxury apartment in Seoul can cost over **5 Billion Won**, which exceeds the limit of `INT UNSIGNED` (~4.29 Billion).
Therefore, for columns like `amount` or `price` in these currencies, **ALWAYS** use **`BIGINT UNSIGNED`**. Using `DECIMAL` is unnecessary (no cents), and `INT` is risky.

-----

## ✍️ String Types

There are two main choices for storing text: `VARCHAR` and `CHAR`.

#### `CHAR(n)`

* **Fixed-Length:** Always occupies `n` characters of space, even if your text is shorter. Empty space is padded.
* **Use Case:** For data that has a **Fixed Length**, like 2-letter Country Codes (`US`, `DE`), Status Codes (`A`, `P`), or MD5 hashes.

#### `VARCHAR(n)`

* **Variable-Length:** Occupies only the space of the actual text + 1 or 2 bytes to store the length.
* **Use Case:** Almost any other text with variable length: Names, Emails, Titles, Addresses.

**Golden Rule for Strings:**

> Always use `VARCHAR` unless you are 100% sure the data length is constant.

For very long text (like an article body), use `TEXT` types (`TINYTEXT`, `TEXT`, `MEDIUMTEXT`, `LONGTEXT`).

-----

## ⏰ Date and Time Types

Two common types for storing full date and time are `DATETIME` and `TIMESTAMP`.

#### `DATETIME`

* Stores date and time in `YYYY-MM-DD HH:MM:SS` format.
* Has a large range (Year 1000 to 9999).
* **NOT Timezone-aware.** It stores and retrieves exactly what you give it.
* **Use Case:** For constant values that shouldn't change with server timezone, like **Birthday**.

#### `TIMESTAMP`

* Works like `DATETIME` but with a key difference: **It is Timezone-aware.**
* Converts input to **UTC** for storage and converts back to the current session timezone upon retrieval.
* Has a smaller range (until 2038, known as the "Year 2038 Problem").
* **Use Case:** Best choice for audit columns like `created_at` and `updated_at`. This ensures an event time is consistent for users across different timezones.

**Note on "Year 2038 Problem":**

> This limitation existed in old 32-bit systems. In all modern 64-bit servers and newer MySQL versions (like MySQL 8.0+), this issue is **fully resolved**, and `TIMESTAMP` will work correctly for billions of years. So use it with confidence.

-----

## 🧩 `JSON` Data Type

This type, added in newer MySQL versions, allows you to store a JSON structure (Object or Array) directly in a column.

#### When is it Good? 👍

* For storing **Metadata** or settings that don't have a fixed structure. E.g., `settings` for a user or `attributes` for a product where features vary by model.
* When you don't want to create a new column for every small feature.

#### When is it Bad? 👎

* **NEVER** use it for core, relational data.
* If you need to frequently filter (`WHERE`) or sort (`ORDER BY`) on a value, that value should be in its own indexed column, not inside a JSON.
* Searching inside JSON is significantly slower than searching an indexed column.

**Golden Rule for JSON:**

> Use `JSON` for flexibility with non-essential, variable data, not as a replacement for proper database design.

-----

[⏪ Previous Lesson: Storage Engines](../01-Storage-Engines/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: Keys & Relationships ⏩](../03-Keys-And-Relationships/README.md)
