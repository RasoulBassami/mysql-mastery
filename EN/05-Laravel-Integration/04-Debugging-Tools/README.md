# Part 5, Lesson 4: Debugging & Monitoring Tools

-----

Writing optimized code is one thing; ensuring it runs optimally in practice is another. Debugging tools give you a transparent view of what happens in the background of every Request in your application.

### Why do we need debugging tools?

* **Identify Performance Issues:** Quickly find N+1 queries, slow queries, or high memory usage.
* **Transparency:** See all executed SQL queries, events, jobs, etc., at a glance.
* **Improve Dev Experience:** Speed up the debugging and development process.

-----

## 1\. Local Development Tools

These tools have high overhead and **should NOT** be enabled on production servers (unless configured very specifically).

### Laravel Debugbar: Your Instant Dashboard

**Debugbar** is a very popular package that adds a powerful toolbar at the bottom of your application (in local env). It gives live insights into the current request.

**Key Database Features:**

* **Queries Tab:** Lists **all database queries** executed to render the current page along with their **execution time**.
* **N+1 Detection:** If you see many duplicate queries in this tab, it's a huge red flag for an N+1 problem.
* **Duplicate Queries:** Debugbar smartly detects exact duplicate queries and warns you.

Installation is simple via Composer:

```bash
composer require barryvdh/laravel-debugbar --dev
```

### Laravel Telescope: Your Command Center

**Telescope** is the official, powerful debug assistant for Laravel. It goes beyond a simple toolbar; it provides a full UI to monitor and debug **every aspect of your application** locally.

**Telescope vs. Debugbar:**

* **Request History:** Unlike Debugbar which shows only the current request, Telescope **stores** requests, allowing you to browse and analyze past requests (great for API/Ajax).
* **Dedicated UI:** Accessible at `/telescope`.
* **Comprehensive Monitoring:** Tracks Queries, Jobs, Exceptions, Events, HTTP Requests, and more.

Installation:

```bash
composer require laravel/telescope --dev
php artisan telescope:install
php artisan migrate
```

> **⚠️ Production Warning:** Telescope stores all data in the database. In high-traffic production, it can quickly fill up your DB and slow down the site. If you must use it in production, ensure you use **Pruning** and restrict access via **Gates**.

-----

## 2\. Production Monitoring Tools 🚀

In production, you can't use Debugbar. You need tools with **minimal overhead** to monitor system health.

### Laravel Pulse: Server Heartbeat ❤️

Laravel's new official tool for at-a-glance server health monitoring.

* **Use Case:** See slowest queries, queue status, slowest routes, and heavy users.
* **Advantage:** Unlike Telescope which stores details, Pulse **aggregates** data, resulting in very low overhead.

### Sentry: The Error Watchdog 🚨

The best tool for **Error Tracking**.

* **Use Case:** When a user hits a 500 error, Sentry captures all details (stack trace, variables, user info) and emails you.
* **Advantage:** Logs are stored on Sentry's cloud, putting zero load on your database.

-----

## Practical Tip: Viewing Final Eloquent Query with `toSql()`

Sometimes, before running a complex Eloquent query, you want to see exactly what SQL Laravel generates. The `toSql()` method is perfect for this.

```php
$query = Post::with('user')
    ->where('status', 'published')
    ->orderBy('published_at', 'desc');

// This DOES NOT execute the query, just returns the string.
dd($query->toSql());

// Output looks like:
// "select * from `posts` where `status` = ? order by `published_at` desc"
```

This technique is very useful for debugging complex queries without executing them and cluttering logs.

-----

[⏪ Previous Lesson: Migrations](../03-Migrations-And-Indexes/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples/DashboardController.php) | [Next Lesson: Scalability ⏩](../05-Scalability-And-Advanced-Patterns/README.md)
