![MySQL Mastery Cover](../assets/cover.jpg)

# 🚀 MySQL Mastery: From Beginner to Monster Level

This repository hosts a **comprehensive and free MySQL course** designed to transform you from a Junior/Mid-level developer (familiar with basic `SELECT` and `INSERT`) into a **Senior Database Engineer** mastering **Query Optimization**, Advanced Architecture, and Real-world MySQL Management.

The focus is on deeply understanding the **"WHY"**, not just memorizing commands. We learn how to design databases that are fast, scalable, and reliable.

This course is specifically tailored for **PHP Developers**, featuring dedicated sections for implementing these concepts in **Laravel** and **WordPress**.

All lessons are provided as Markdown files (`README.md`), with practical examples in `.sql` or `.php` files within their respective folders.

-----

## 🎯 Course Roadmap

The course is divided into 6 standalone modules, building upon each other:

### [Part 1: MySQL Fundamentals & Key Concepts](./01-Fundamentals/README.md)

Revisiting the basics with a deeper perspective to ensure a solid foundation.

* Deep Dive into Storage Engines (InnoDB vs. MyISAM)
* Data Types & Optimal Selection for Space/Speed
* Relationships, Keys, and Joins

### [Part 2: Advanced Database Design & Architecture](./02-Advanced-Design/README.md)

Learning to think like a Database Architect. Designing stable and scalable schemas.

* Normalization vs. Denormalization
* Advanced Indexing Strategies (B-Tree, Composite Indices)
* Transactions & Understanding ACID
* Views & Stored Routines (Procedures, Functions, Triggers)

### [Part 3: Comprehensive Performance Optimization](./03-Performance-Optimization/README.md)

The heart of the course. Skills that distinguish a Senior Engineer.

* Analyzing Slow Queries with `EXPLAIN`
* Index-Level Optimization (Cardinality, Covering Index)
* Query-Level Optimization (Avoiding Anti-Patterns, Keyset Pagination)
* Architecture-Level Optimization (Caching Strategies, Data Types at Scale)
* Server-Level Optimization (Slow Query Log & `my.cnf`)

### [Part 4: Management, Scalability & Security](./04-Admin-And-Scaling/README.md)

Topics every Senior Engineer must know to maintain and grow a large system.

* Security: User Management, Privileges, Preventing SQL Injection
* Backup & Recovery: Logical vs. Physical Backups
* Scalability: Replication (Master-Slave) & Sharding Concepts
* Operations: Managing Locking, Bulk Data Import, Zero-Downtime Schema Changes

### [Part 5: Integration & Optimization in Laravel](./05-Laravel-Integration/README.md)

Applying theoretical knowledge within the Laravel framework.

* Optimizing Eloquent ORM & Solving N+1 Query Problem
* Smart usage of Query Builder, Raw Expressions & View Models
* Defining Indexes & Foreign Keys correctly in Migrations
* Debugging & Monitoring Tools (Debugbar, Telescope, Pulse, Sentry)
* Scalability & Advanced Patterns (Read/Write Splitting, Chunking)

### [Part 6: Integration & Optimization in WordPress](./06-WordPress-Integration/README.md)

Addressing unique performance challenges of the world's most popular CMS.

* Understanding WordPress Database Schema & Key Tables
* Solving the `wp_options` & `autoload` Performance Issue
* Writing Secure & Optimized Queries with `$wpdb`
* Understanding the EAV Problem in `wp_postmeta` & Solutions
* Object Caching & Connecting WordPress to Redis

-----

## 👨‍💻 About the Author

This course is curated and written by **Rasoul Bassami**.
Feel free to connect, suggest improvements, or report issues:

* Email: `rasoul.bassami@gmail.com`
* LinkedIn: [Rasoul Bassami](https://www.linkedin.com/in/rasoul-bassami/)

## 🛠️ How to Study

1.  **Step-by-Step:** The course is divided into 6 parts. It is recommended to study them in order. *Note:* Deep questions encountered early on (e.g., "What's the cost of this?") are fully answered in later specialized sections (like Optimization).
2.  **Structure:** Each lesson has its own folder containing a `README.md` (the lesson) and example code files (`.sql` or `.php`).
3.  **Run the Examples:** To fully grasp the concepts, execute the provided code examples in your local development environment (XAMPP, Laragon, Docker, etc.).

## 🤝 Contributing

This is an educational project open to improvements. If you spot typos, technical errors, or have better examples, please contribute via **Pull Requests** or **Issues**.

## 📜 License

This course is open-sourced software licensed under the **MIT license**. You are free to use, copy, and share this content (even commercially), provided the original author (Rasoul Bassami) is credited.
