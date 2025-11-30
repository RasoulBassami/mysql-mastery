# Part 6, Lesson 1: Understanding WordPress Database Structure

-----

Before we can solve WordPress performance problems, we must understand how WordPress organizes its data. The WordPress database structure is designed to be extremely **Flexible** to accommodate various types of content, but this very flexibility is the source of many performance issues.

By default, all WordPress tables start with the `wp_` prefix. Let's get to know the most important tables.

-----

## Key Tables

In a standard WordPress installation, there are 12 tables. We will focus on the most critical ones:

### `wp_posts`

This table is the beating heart of WordPress. Despite its name, this table doesn't just store blog posts; almost **all types of content** reside here:

* **Posts:** Blog articles.
* **Pages:** Static pages like "About Us".
* **Navigation Menus:** Each menu item is a row in this table.
* **Media (Attachments):** Every image or file you upload.
* **Custom Post Types:** For example, `products` in WooCommerce.

A key column in this table is `post_type`, which defines the type of content for each row.

-----

### `wp_postmeta`

This table allows `wp_posts` to be infinitely flexible. Any extra information or **"Metadata"** related to a post is stored in this table. For example:

* A product's price in WooCommerce.
* A post's featured image.
* Custom Fields added by plugins.

This table uses a model called **EAV (Entity-Attribute-Value)**, and we will examine its performance issues in upcoming lessons.

-----

### `wp_users` & `wp_usermeta`

* **`wp_users`:** Stores core user information like username, hashed password, and email.
* **`wp_usermeta`:** Like `wp_postmeta`, this table stores metadata related to users. For example, first name, last name, biography, or profile settings added by plugins.

-----

### `wp_options`

This table stores general site settings and plugins configuration. Everything from the site title to a caching plugin's settings resides here. This table has a key column named `autoload`, which is one of the **most common causes of WordPress slowness**, and we will cover it fully in the next lesson.

-----

### `wp_terms`, `wp_term_taxonomy`, `wp_term_relationships` (Taxonomy Tables)

These three tables together form the WordPress **Taxonomy** system.

* **`wp_terms`:** Stores the names of Categories, Tags, and any other classification (e.g., 'News' or 'Tutorial').
* **`wp_term_taxonomy`:** Defines whether a `term` is a category or a tag.
* **`wp_term_relationships`:** This pivot table connects posts to their categories and tags (Many-to-Many relationship between `wp_posts` and `wp_terms`).

-----

### `wp_comments` & `wp_commentmeta`

These tables store comments made on posts and metadata related to those comments, respectively.

### Summary & Overview

The WordPress database structure is built on a few main tables and `meta` tables for flexibility. This design allows plugins to easily store their data without altering the main database structure, but this same feature, if not managed correctly, leads to heavy and inefficient queries. In the following lessons, we will learn how to identify and solve these problems.

-----

[⏪ Previous Chapter: Laravel Integration](../../05-Laravel-Integration/README.md) | [🔼 Back to Chapter Index](../README.md) | [Next Lesson: Autoload Issue ⏩](../02-wp-options-autoload/README.md)
