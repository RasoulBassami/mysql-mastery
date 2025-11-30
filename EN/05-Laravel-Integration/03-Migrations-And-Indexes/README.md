# Part 5, Lesson 3: Working with Indexes & Migrations

-----

Laravel Migrations are a fantastic tool for managing your database structure as code (Infrastructure as Code). This approach allows you to version control all database changes, share them with your team, and automate deployments reliably.

Knowing how to define indexes and relationships correctly from the start saves you from future performance headaches.

-----

## Defining Indexes in Migrations

You can define various index types directly in the `up()` method of your migration file.

### Primary Key & Foreign Key

* **Primary Key:** The `id()` or `bigIncrements('id')` method automatically creates a `BIGINT UNSIGNED AUTO_INCREMENT` primary key column.
* **Foreign Key:** The best and modern way in Laravel is using `foreignId()` combined with `constrained()`.

<!-- end list -->

```php
Schema::create('posts', function (Blueprint $table) {
    $table->id(); // Primary Key
    $table->foreignId('user_id')->constrained()->onDelete('cascade');
    // ...
});
```

The `onDelete('cascade')` method tells the database that if a user is deleted, all their related posts should also be automatically deleted.

### Simple & Unique Indexes

* **Simple Index (`index()`):** Speeds up searches on columns frequently used in `WHERE` clauses.
* **Unique Index (`unique()`):** Speeds up searches AND ensures no two rows have the same value in this column.

<!-- end list -->

```php
Schema::create('posts', function (Blueprint $table) {
    // ...
    $table->string('slug')->unique(); // Ensures every post has a unique slug
    $table->string('status')->index(); // Speeds up searches by status
    // ...
});
```

### Composite Index

As learned in previous sections, composite indexes are vital for optimizing complex queries with multiple conditions in `WHERE` or `ORDER BY`.

```php
Schema::create('posts', function (Blueprint $table) {
    // ...
    $table->string('status');
    $table->timestamp('published_at')->nullable();

    // Creating a composite index for queries filtering by both status and publish time
    $table->index(['status', 'published_at']);
});
```

-----

## Naming & Dropping Indexes

The `down()` method in a Migration should reverse everything done in `up()`. To drop indexes and foreign keys, you need their names. Laravel automatically generates names, but **Best Practice is to explicitly name important indexes.** This makes your code more readable and maintainable.

**Full Example with Naming:**

```php
public function up()
{
    Schema::table('posts', function (Blueprint $table) {
        $table->unique('slug', 'posts_slug_unique'); // Explicit name
        $table->index(['status', 'published_at'], 'posts_status_published_at_index'); // Explicit name
    });
}

public function down()
{
    Schema::table('posts', function (Blueprint $table) {
        $table->dropUnique('posts_slug_unique');
        $table->dropIndex('posts_status_published_at_index');
    });
}
```

-----

[⏪ Previous Lesson: Query Builder](../02-Query-Builder-And-Raw/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Code](examples/CreatePostsTableMigration.php) | [Next Lesson: Debugging Tools ⏩](../04-Debugging-Tools/README.md)
