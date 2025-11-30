CREATE TABLE IF NOT EXISTS `events` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_type` VARCHAR(50) NOT NULL, -- Low Cardinality
    `user_id` INT UNSIGNED NOT NULL,   -- High Cardinality
    `payload` JSON,
    `created_at` TIMESTAMP NOT NULL
) ENGINE=InnoDB;

-- (Insert a large amount of random data here)

-- ############## Scenario: Cardinality ##############

-- Query: Find all events of a specific type for a user
EXPLAIN SELECT id, created_at FROM events WHERE user_id = 50 AND event_type = 'login_success';

-- Bad Index: Low cardinality column first
CREATE INDEX idx_bad_cardinality ON events (event_type, user_id);

-- Good Index: High cardinality column first
CREATE INDEX idx_good_cardinality ON events (user_id, event_type);

-- Running EXPLAIN will show MySQL prefers idx_good_cardinality and scans fewer rows.


-- ############## Scenario: Covering Index ##############

-- Query: Find timestamp of all events for a user
EXPLAIN SELECT created_at FROM events WHERE user_id = 100;

-- Standard Index (Non-Covering)
CREATE INDEX idx_user ON events (user_id);
-- >> EXPLAIN Result: Good, but Extra column is empty or just "Using where".

-- Covering Index
CREATE INDEX idx_user_cover ON events (user_id, created_at);
-- >> EXPLAIN Result: Excellent! Extra shows "Using index".
-- This means the query was answered without touching the main table.
