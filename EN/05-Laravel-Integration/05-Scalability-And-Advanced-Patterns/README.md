# Part 5, Lesson 5: Scalability & Advanced Patterns in Laravel

-----

When your application grows and traffic spikes, code that worked fine for 100 users suddenly causes slowness or server crashes. In this lesson, we learn how to use Laravel's built-in tools to prepare your app for heavy load and large datasets.

-----

## 1\. Load Distribution with Read/Write Splitting

In Part 4, we learned about **Replication (Master-Slave)**. Laravel supports this architecture out of the box, allowing you to distribute the heavy load of `SELECT` queries among multiple Slave servers.

**Config in `config/database.php`:**
Simply split your mysql connection configuration into `read` and `write` arrays:

```php
'mysql' => [
    'read' => [
        'host' => ['192.168.1.2', '192.168.1.3'], // Slave IPs (Load Balancing)
    ],
    'write' => [
        'host' => ['192.168.1.1'], // Master IP (Write Only)
    ],
    'sticky'    => true, // <--- CRITICAL!
    'driver'    => 'mysql',
    // ...
],
```

**The Magic of `sticky => true` (Solving Lag):**
As we know, syncing data between Master and Slave might take a few milliseconds (Replication Lag).
The `sticky` option tells Laravel: *"If the user performs a Write operation in this Request, force all subsequent Reads in this request to use the **Master** server."*
This guarantees the user always sees their own changes immediately, avoiding stale data issues.

-----

## 2\. Memory Management for Large Datasets

Suppose you want to send an email to all 100,000 users. The following code is a disaster:

**❌ Wrong Way (Consumes all Server RAM):**

```php
$users = User::all(); // Loads ALL 100k records into RAM at once!
foreach ($users as $user) {
    // ...
}
```

This code will cause `Allowed memory size exhausted` error.

**✅ Correct Way 1: Using `chunk()`**
This method fetches and processes data in small chunks (e.g., 1000 at a time).

```php
User::chunk(1000, function ($users) {
    foreach ($users as $user) {
        // Process 1000 users
    }
}); // Memory is freed after each chunk
```

**✅ Correct Way 2: Using `cursor()` (For Higher Speed)**
If you only need to read data and iterate through it, `cursor` is even more memory-efficient than `chunk`. It uses **PHP Generators** to keep only **one record** in memory at a time.

```php
foreach (User::cursor() as $user) {
    // Process user
}
```

-----

## 3\. Smart Query Caching

The fastest query is the one that never runs. Laravel makes caching patterns very simple with `Cache::remember`.

**Scenario:** Calculating a daily sales report is very heavy.

```php
$salesReport = Cache::remember('daily_sales', 3600, function () {
    // This heavy query runs ONLY ONCE.
    // Result is stored in Redis for 3600 seconds (1 hour).
    return DB::table('orders')
        ->selectRaw('SUM(amount) as total, date(created_at) as day')
        ->groupBy('day')
        ->get();
});
```

For all subsequent requests, Laravel fetches data directly from Cache (Redis) and never touches the database.

-----

### Summary: Scalability Strategies

1.  **High Read Traffic?** Use `read/write` config in Laravel to spread `SELECT` load across Slave servers.
2.  **Huge Dataset?** Never use `all()` or `get()` on large tables. Always use `chunk()` or `cursor()`.
3.  **Heavy Repetitive Queries?** Cache the result using `Cache::remember`.

-----

[⏪ Previous Lesson: Debugging Tools](../04-Debugging-Tools/README.md) | [🔼 Back to Chapter Index](../README.md) | [Next Chapter: WordPress Integration ⏩](../../06-WordPress-Integration/README.md)
