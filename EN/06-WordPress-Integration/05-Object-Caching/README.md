# Part 6, Lesson 5: The Role of Object Caching & Connecting WordPress to Redis

-----

So far, we've tried to send *better* queries to the database. But what if we could ensure those queries **aren't executed at all**? This is exactly what Object Caching does.

## What is Object Cache in WordPress?

WordPress has an internal caching system called **WP\_Object\_Cache**. This system is designed to store the results of expensive operations (like database queries) in memory to prevent repeating them.

But there is a very important catch:

* **Default Cache (Non-persistent):** By default, this cache is **Not Persistent**. It means cached data lives only for the duration of **a single Request**. As soon as the page finishes loading, the cache is emptied. This type is useful for preventing the same query from running multiple times on a single page, but it doesn't help with subsequent requests.

* **Persistent Cache:** Our main goal is to turn this into a persistent cache. This is done by connecting WordPress to an external, ultra-fast cache server like **Redis** or **Memcached**. In this state, cached data remains available across different requests and different users.

**Analogy:** The default WordPress cache is like short-term memory that gets wiped every time you blink. A persistent cache is like long-term memory that recalls information instantly.

## Role of Redis and Memcached

Redis and Memcached are **In-Memory** storage servers. Since they store data in RAM, accessing information from them is thousands of times faster than a database working on disk.

By installing a special plugin (called a Drop-in), you tell WordPress to use Redis or Memcached as its long-term memory instead of its own short-term memory.

## What Gets Cached Automatically?

When a persistent cache is active, WordPress smartly stores many results in it:

* **All autoloaded options** from `wp_options`.
* **Results of `WP_Query`**.
* **Transients API data**.
* User information, taxonomy terms, and more.

**Final Result:**
Enabling a persistent cache is often the **Single Most Effective Optimization** you can do for a WordPress site. It can reduce database queries per page from dozens or hundreds to just a handful, drastically improving Time To First Byte (TTFB).

-----

[⏪ Previous Lesson: EAV Problem](../04-postmeta-eav-problem/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples.php) |  [🏁 Return to start point 🏁](../../README.md)

