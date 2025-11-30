-- Step 1: Create tables with Primary and Foreign Keys

CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `orders` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_date` DATE NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `user_id` BIGINT UNSIGNED, -- Can be NULL if an order doesn't belong to a specific user (optional)
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`), -- A standard index to improve join speed
    CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;


-- Step 2: Insert sample data

-- We have users, one of whom has no orders
INSERT INTO `users` (`id`, `name`) VALUES (1, 'Alice Smith'), (2, 'Bob Jones'), (3, 'Charlie Brown');

-- We have orders, one of which belongs to no user (user_id is NULL)
INSERT INTO `orders` (`id`, `order_date`, `amount`, `user_id`) VALUES
    (101, '2025-10-01', 150.00, 1),
    (102, '2025-10-02', 75.50, 2),
    (103, '2025-10-03', 200.00, 1),
    (104, '2025-10-04', 50.00, NULL);


-- Step 3: Execute JOIN queries

-- INNER JOIN: Show orders along with the name of the user who placed them
-- (Only users with orders are shown)
SELECT
    o.id AS order_id,
    o.amount,
    u.name AS customer_name
FROM orders AS o
INNER JOIN users AS u ON o.user_id = u.id;
-- Expected: 3 rows returned.


-- LEFT JOIN: Show all users and their orders (if any)
-- (User "Charlie Brown" who has no orders is also shown with NULL values)
SELECT
    u.name AS customer_name,
    o.id AS order_id,
    o.amount
FROM users AS u
LEFT JOIN orders AS o ON u.id = o.user_id;
-- Expected: 4 rows returned.