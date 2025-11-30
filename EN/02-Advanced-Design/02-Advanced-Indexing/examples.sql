-- Step 1: Create Products Table
-- Note: To test real indexing performance, you need thousands or millions of records.
CREATE TABLE IF NOT EXISTS `products` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    `brand_id` INT UNSIGNED NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- (Insert a large amount of random data here for testing)
-- INSERT INTO products (name, category_id, brand_id, price, is_active) VALUES ...

-- Step 2: Run a slow query without a proper index
-- Scenario: "Show active products from a specific category and brand, sorted by price descending"

EXPLAIN SELECT id, name, price
    FROM products
    WHERE
        category_id = 5
        AND is_active = 1
        AND brand_id = 10
    ORDER BY price DESC;

-- The EXPLAIN output will likely show `type: ALL` or `index`, scanning thousands of rows.
-- You might also see "Using filesort" in the Extra column, which is bad.


-- Step 3: Create an Optimal Index (Composite & Covering)
-- We build the index based on columns in WHERE and ORDER BY.
-- Order: category_id and brand_id are good starts for filtering.
-- price is added to cover the ORDER BY.
-- id and name are added to cover the SELECT part, making it a Covering Index.

CREATE INDEX `idx_product_query`
    ON `products` (category_id, brand_id, is_active, price DESC, id, name);


-- Step 4: Run the query again
EXPLAIN SELECT id, name, price
FROM products
    WHERE
        category_id = 5
        AND is_active = 1
        AND brand_id = 10
    ORDER BY price DESC;

-- The new EXPLAIN output should be significantly better.
-- type: ref or range.
-- rows: The number of scanned rows will be much lower.
-- Extra: You will see "Using index", indicating a Covering Index.
-- "Using filesort" should be gone.
