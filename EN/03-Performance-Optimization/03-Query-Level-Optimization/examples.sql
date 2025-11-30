CREATE TABLE IF NOT EXISTS `logs` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `message` VARCHAR(255),
    `log_time` DATETIME NOT NULL,
    KEY `idx_log_time` (`log_time`)
) ENGINE=InnoDB;

-- (Insert 1-2 million log records here)

-- ############## Scenario 1: Function in WHERE ##############

-- Bad Way: Using DATE() function
EXPLAIN SELECT id, message FROM logs WHERE DATE(log_time) = '2025-10-06';
-- >> Expected Result: Full table scan (type: ALL) or Full index scan (type: index).
-- MySQL cannot use idx_log_time efficiently.

-- Good Way: Using range condition
EXPLAIN SELECT id, message FROM logs WHERE log_time >= '2025-10-06 00:00:00' AND log_time < '2025-10-07 00:00:00';
-- >> Expected Result: Efficient range scan (type: range) using the index.


-- ############## Scenario 2: Pagination ##############

-- Assume logs table has millions of rows.

-- Slow Way: OFFSET on deep pages
-- Run this (not just EXPLAIN) and check execution time.
-- SELECT id, log_time FROM logs ORDER BY id LIMIT 100 OFFSET 500000;

-- Fast Way: Keyset Pagination
-- Assume last id on previous page was 500000.
-- Run this and compare time.
-- SELECT id, log_time FROM logs WHERE id > 500000 ORDER BY id LIMIT 100;

-- >> Expected Result: Second query should be drastically faster.
