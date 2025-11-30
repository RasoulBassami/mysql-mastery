-- Step 1: Create tables and insert sample data
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(150) NOT NULL,
    `status` TINYINT NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP
) ENGINE=InnoDB;

-- (Insert a large number of random records here to see performance differences)

-- ############## Scenario 1: Query without Index ##############

-- Run EXPLAIN on a query where no index exists for the email column
EXPLAIN SELECT id, email FROM users WHERE email = 'some-random-email@example.com';
-- >> Expected Result: type: ALL, key: NULL, rows: (total rows in table)
-- This is a disaster! Full table scan.

-- Now add the index
CREATE INDEX `idx_email` ON `users` (`email`);

-- Run the same EXPLAIN again
EXPLAIN SELECT id, email FROM users WHERE email = 'some-random-email@example.com';
-- >> Expected Result: type: ref, key: idx_email, rows: 1
-- Huge improvement!


-- ############## Scenario 2: Filesort issue in Sorting ##############

-- Run EXPLAIN on a query sorted by a non-indexed column
EXPLAIN SELECT id, email FROM users WHERE status = 1 ORDER BY created_at DESC;
-- >> Expected Result: Extra: "Using where; Using filesort"
-- This means MySQL found the data but had to sort it in a separate step.

-- Now create a proper composite index covering both filtering and sorting
CREATE INDEX `idx_status_created` ON `users` (`status`, `created_at`);

-- Run the same EXPLAIN again
EXPLAIN SELECT id, email FROM users WHERE status = 1 ORDER BY created_at DESC;
-- >> Expected Result: "Using filesort" should be gone.
-- MySQL can now read results directly from the index in sorted order.
