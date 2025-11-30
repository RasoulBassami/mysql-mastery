# Part 6, Lesson 2: Solving the `wp_options` & `autoload` Performance Issue

-----

The `wp_options` table is the place for storing general site settings, widgets, and plugin/theme configurations. Inside this table lies a seemingly innocent column named `autoload` that can bring your site to its knees.

## What is `autoload` and why is it a problem?

The `autoload` column can have two values: `yes` or `no`. If the value is `yes`, WordPress automatically reads that option from the database and loads it into memory on **every single page load**, whether it's the front-end or the admin dashboard.

* **Analogy:** Imagine leaving your house for a short walk, but instead of just taking your keys and wallet, you carry all your home furniture in a giant backpack\! This is exactly what WordPress does with `autoload`ed options.

This feature is good for frequently used options (like the site URL). But the problem starts when plugins and themes store huge data or rarely used data with `autoload = 'yes'` in this table. Even worse, many plugins do not clean up their options after being deleted.

Over time, the volume of data loaded on every request becomes so large that it causes severe site slowness and increases server memory (**RAM**) usage.

-----

## How to Detect the Problem?

The first step is to understand how much data is being autoloaded. This can be done with a simple SQL query.

```sql
SELECT SUM(LENGTH(option_value)) / 1024 / 1024 AS autoload_size_mb
FROM wp_options
WHERE autoload = 'yes';
```

This query shows you the total size of autoloaded data in Megabytes.

* **General Rule:**
  * **Under 1 MB:** Excellent.
  * **Between 1 to 3 MB:** Acceptable, but room for optimization.
  * **Above 3-5 MB:** You have a serious performance issue.
  * **Above 10 MB:** Critical situation\!

-----

## How to Solve the Problem?

Solving the problem is a two-step process: first, we find the massive options, and then we optimize them.

### Step 1: Finding Massive Options

With the following query, you can find the top 20 largest options that are being autoloaded:

```sql
SELECT
    option_name,
    LENGTH(option_value) AS option_size_bytes
FROM
    wp_options
WHERE
    autoload = 'yes'
ORDER BY
    option_size_bytes DESC
LIMIT 20;
```

By looking at the `option_name`, you can usually guess which plugin or theme they belong to.

### Step 2: Optimization (Changing `autoload` to `no`)

For the options you identified (especially those belonging to inactive or deleted plugins, or those you know aren't needed on every page), you should change the `autoload` value from `yes` to `no`.

```sql
UPDATE wp_options SET autoload = 'no' WHERE option_name = 'some_bloated_plugin_option';
```

**⚠️ Very Important Warning:**

> Before running any `UPDATE` or `DELETE` command on this table, **make sure to take a full database backup.** Changing `autoload` for a critical option can break your site. Proceed with caution.

By changing this value to `no`, that option is removed from automatic loading, but its data remains in the database, and the relevant plugin can still read it directly using `get_option()` if needed.

-----

[⏪ Previous Lesson: Database Structure](../01-Database-Structure/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.sql) | [Next Lesson: $wpdb Class ⏩](../03-wpdb-class/README.md)
