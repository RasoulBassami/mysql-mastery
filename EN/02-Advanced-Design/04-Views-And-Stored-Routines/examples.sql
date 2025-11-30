-- Step 1: Create base tables
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `is_active` TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `orders` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT UNSIGNED NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `order_date` DATE NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB;

-- Insert sample data
TRUNCATE TABLE `orders`;
TRUNCATE TABLE `users`;

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `is_active`) VALUES
    (1, 'Ali', 'ali@example.com', 'hashed_pass_1', 1),
    (2, 'Maryam', 'maryam@example.com', 'hashed_pass_2', 1),
    (3, 'Reza', 'reza@example.com', 'hashed_pass_3', 0);

INSERT INTO `orders` (`id`, `user_id`, `amount`, `order_date`) VALUES
    (101, 1, 250.00, '2025-11-10'),
    (102, 2, 120.50, '2025-11-11'),
    (103, 1, 75.00, '2025-11-12');


-- Step 2: Create a View for Simplicity & Security

-- Example 1: Simplicity - Report of total spending per user
CREATE OR REPLACE VIEW `v_customer_sales_report` AS
SELECT
    u.id AS user_id,
    u.name,
    u.email,
    COUNT(o.id) AS total_orders,
    SUM(o.amount) AS total_spent
FROM
    users AS u
        LEFT JOIN
    orders AS o ON u.id = o.user_id
GROUP BY
    u.id, u.name, u.email;


-- Example 2: Security - Public user info (hiding password)
CREATE OR REPLACE VIEW `v_public_users` AS
SELECT
    id,
    name,
    email
FROM
    users
WHERE
    is_active = 1;


-- Step 3: Using Views like normal tables

-- Fetch report without writing complex JOIN/GROUP BY
SELECT * FROM `v_customer_sales_report` WHERE total_spent > 100;

-- Fetch public user data securely
SELECT * FROM `v_public_users`;


-- ############### Stored Procedure Example ###############
-- Procedure to archive a user and delete them from main tables
CREATE TABLE IF NOT EXISTS `archived_users` LIKE `users`;

DELIMITER $$
CREATE PROCEDURE `sp_archive_and_delete_user`(IN p_user_id INT)
BEGIN
    -- Copy user to archive
    INSERT INTO archived_users SELECT * FROM users WHERE id = p_user_id;
    -- Delete user (delete orders first due to FK)
    DELETE FROM orders WHERE user_id = p_user_id;
    DELETE FROM users WHERE id = p_user_id;
END$$
DELIMITER ;

-- Call procedure for user ID 3
-- CALL sp_archive_and_delete_user(3);


-- ############### Stored Function Example ###############
-- Function to return total spent amount for a user
DELIMITER $$
CREATE FUNCTION `fn_get_user_total_spent`(p_user_id INT)
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE total_spent DECIMAL(10, 2);
    SELECT SUM(amount) INTO total_spent FROM orders WHERE user_id = p_user_id;
    RETURN IFNULL(total_spent, 0);
END$$
DELIMITER ;

-- Use function in SELECT
SELECT id, name, fn_get_user_total_spent(id) AS total_spent FROM users;


-- ############### Trigger Example ###############
-- Log email changes
CREATE TABLE IF NOT EXISTS `audit_logs` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `log_message` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER `trg_after_user_email_update`
    AFTER UPDATE ON `users`
    FOR EACH ROW
BEGIN
    IF OLD.email <> NEW.email THEN
        INSERT INTO audit_logs (log_message)
        VALUES (CONCAT('User ID ', OLD.id, ' email changed from ', OLD.email, ' to ', NEW.email));
    END IF;
END$$
DELIMITER ;
