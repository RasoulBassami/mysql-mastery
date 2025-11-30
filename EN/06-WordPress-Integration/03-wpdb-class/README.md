# Part 6, Lesson 3: Writing Secure & Optimized Queries with `$wpdb`

-----

Standard WordPress functions like `WP_Query` or `get_posts` are great for 80% of daily tasks. They are secure and automatically use the WordPress caching system. However, sometimes you need to execute custom, complex, or highly optimized queries. This is where you need to talk directly to the database, and the WordPress tool for this job is the global object `$wpdb`.

## What is `$wpdb`?

`$wpdb` is a **Database Abstraction Layer** in WordPress that gives you a secure and convenient interface to execute any SQL query.

### When to use `$wpdb`?

* To build complex reports requiring custom `JOIN`s between different tables (especially custom plugin tables).
* To execute batch `UPDATE` or `DELETE` operations for better performance.
* When working with custom tables that don't follow the standard WordPress posts or users structure.

-----

## Key Methods of `$wpdb`

To use this class, you must access the global `$wpdb` variable in your code.

```php
global $wpdb;
```

* **`$wpdb->get_results()`:** To execute a `SELECT` query where you expect **multiple rows** returned. The output is an array of objects.
* **`$wpdb->get_row()`:** For a `SELECT` query that returns only **one row**.
* **`$wpdb->get_var()`:** When you only need **a single value** from a row (e.g., `COUNT(*)`).
* **`$wpdb->query()`:** For commands that don't return results, like `INSERT`, `UPDATE`, `DELETE`. This method returns the number of affected rows.

-----

## Security First: Using `$wpdb->prepare()`

The most important rule you must follow when working with `$wpdb` is:

> **Never, ever, ever** concatenate input variables (like `$_GET` or `$_POST`) directly into your query string. This creates a massive SQL Injection vulnerability.

The WordPress solution for this problem is the `$wpdb->prepare()` method. This method works like `sprintf`, using placeholders to safely substitute values.

* `%s` for Strings
* `%d` for Integers
* `%f` for Floats

**Comparison: Insecure vs. Secure Code**

**❌ Catastrophic Code (Vulnerable):**

```php
$user_id = $_GET['id']; // User can input '1 OR 1=1'
$user_posts = $wpdb->get_results("SELECT * FROM $wpdb->posts WHERE post_author = $user_id");
```

**✅ Secure Code:**

```php
$user_id = $_GET['id'];
$user_posts = $wpdb->get_results( $wpdb->prepare(
    "SELECT * FROM $wpdb->posts WHERE post_author = %d",
    $user_id
) );
```

In the secure version, `$wpdb->prepare()` guarantees that the `$user_id` variable is always interpreted as a number, and no malicious code can be injected.

-----

## Advanced Tips & Best Practices

* **Always use table prefixes:** Instead of writing `wp_posts`, use `$wpdb->posts`. This ensures your code works on sites with different table prefixes.
* **Caching Results:** Unlike `WP_Query`, `$wpdb` queries are **not** automatically cached. If you have a heavy custom query running frequently, **you are responsible for caching its results**. The best way to do this in WordPress is using the **Transients API**.

-----

[⏪ Previous Lesson: Autoload Issue](../02-wp-options-autoload/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.php) | [Next Lesson: EAV Problem ⏩](../04-postmeta-eav-problem/README.md)
