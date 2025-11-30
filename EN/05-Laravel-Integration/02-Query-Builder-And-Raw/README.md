# Part 5, Lesson 2: Query Builder & Raw Expressions

-----

Eloquent is fantastic for everyday CRUD operations and working with Models. However, there are times when you need lower-level control or higher performance. This is where Query Builder and Raw Expressions come in.

-----

## Query Builder: SQL Power with Laravel Comfort

**Query Builder** is a fluent interface for building and running database queries. Unlike Eloquent, Query Builder doesn't deal with Models and returns results as an array of standard PHP objects.

### When to use Query Builder instead of Eloquent?

1.  **Complex Reporting:** When you need heavy queries with multiple `JOIN`s, `GROUP BY`, and aggregate functions (`SUM`, `AVG`, `COUNT`), Query Builder is usually faster because it skips the overhead of converting results into Eloquent Objects (Hydration).
2.  **Batch Operations:** For `UPDATE` or `DELETE` operations on thousands of rows based on a condition, Query Builder is much more efficient as it doesn't need to fetch models from the database first.
3.  **No Model Needed:** If you only need a few simple columns from a table for a list and don't need Model features (relationships, accessors, mutators), Query Builder is lighter.

### Syntax Comparison

Query Builder syntax is very similar to Eloquent, making it easy to learn.

**Eloquent:**

```php
use App\Models\User;
$users = User::where('status', 'active')->orderBy('created_at')->get();
```

**Query Builder:**

```php
use Illuminate\Support\Facades\DB;
$users = DB::table('users')->where('status', 'active')->orderBy('created_at')->get();
```

-----

## Raw Expressions (`DB::raw()`): Raw Power, High Responsibility

**Raw Expressions** are your escape hatch when neither Eloquent nor Query Builder can construct your desired query. This tool allows you to inject a raw SQL string directly into your query.

### When to use `DB::raw()`?

* To call specific database functions that have no Laravel equivalent (e.g., geographic functions like `ST_Distance_Sphere`).
* For complex calculations in `SELECT` or `ORDER BY`.

<!-- end list -->

```php
$users = DB::table('users')
    ->select(
        'status',
        DB::raw('COUNT(*) as user_count') // Using SQL function
    )
    ->groupBy('status')
    ->get();
```

### ☠️ Major Risk: SQL Injection

The most important thing to know: `DB::raw()` bypasses all of Laravel's automatic SQL Injection protection. Any user input placed directly into a `DB::raw()` string makes your application vulnerable.

**❌ Catastrophic Way (Vulnerable):**

```php
$status = $_GET['status']; // Input could be: 'active' OR 1=1
$users = DB::select(DB::raw("SELECT * FROM users WHERE status = '$status'"));
// Your app is hacked!
```

**✅ Secure Way (Using Bindings):**
Always pass user inputs as separate parameters (bindings) to the query. In this case, Laravel escapes the values, preventing them from being interpreted as SQL code.

```php
$status = $_GET['status'];
$users = DB::select('SELECT * FROM users WHERE status = ?', [$status]);
```

When using standard Query Builder methods like `where()`, Laravel automatically uses bindings, so your code is safe. The risk only exists when you concatenate user input directly inside `DB::raw()`.

-----

## Using Views: Best of Both Worlds

In Part 2, we learned how Views encapsulate complex queries in the database. In Laravel, you can easily use these Views and treat them as part of Eloquent.

This allows you to keep all complex logic (`JOIN`, `GROUP BY`) in the database (SQL Power) but work with it using a clean Eloquent Model in PHP (Laravel Simplicity).

**1. Create View in Migration:**
You can create your View using `DB::statement` in a Migration file.

```php
public function up()
{
    DB::statement("
        CREATE VIEW product_sales_report AS
        SELECT product_id, SUM(amount) as total_sales
        FROM orders
        GROUP BY product_id
    ");
}
```

**2. Create Eloquent Model for View:**
Now, create an Eloquent model as if `product_sales_report` were a normal table:

```php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class ProductSalesReport extends Model
{
    // 1. Define the view name as the table
    protected $table = 'product_sales_report';

    // 2. Disable timestamps since views don't have created_at/updated_at
    public $timestamps = false;
}
```

**3. Use the Model:**
Now you can use this View in your controller just like a normal Eloquent model:

```php
$reports = ProductSalesReport::where('total_sales', '>', 1000)
              ->orderBy('total_sales', 'desc')
              ->get();
```

This approach combines all benefits of Views with the simplicity of Eloquent.

-----

### Summary: What to Use When?

* **Eloquent (90%):** For all standard CRUD tasks, relationships, and working with models.
* **Query Builder:** For complex reporting, batch operations, and simple queries where models aren't needed.
* **View (with Eloquent Model):** To encapsulate very complex queries (JOIN/GROUP BY) in the database and consume them easily in code.
* **Raw Expressions:** As a last resort for very specific complex queries, **ALWAYS using bindings** for user input.

-----

[⏪ Previous Lesson: N+1 Query](../01-Eloquent-N-Plus-1/README.md) | [🔼 Back to Chapter Index](../README.md) | [📄 View Query Builder Example](examples/QueryBuilderExample.php) | [📄 View Raw Expression Example](examples/RawExpressionExample.php) | [Next Lesson: Migrations ⏩](../03-Migrations-And-Indexes/README.md)
