-- This script creates a `users` table with optimal data type selection.
-- Compare this with bad designs (e.g., using INT for status).

CREATE TABLE IF NOT EXISTS `users` (
    -- BIGINT for future-proofing and preventing ID exhaustion
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    -- VARCHAR for variable data, NOT NULL as name is required
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,

    -- TINYINT for small, specific numeric data (e.g., 0=Inactive, 1=Active, 2=Suspended)
    `status` TINYINT UNSIGNED NOT NULL DEFAULT 0,

    -- DATE for birthday, as time and timezone are irrelevant
    `birth_date` DATE NULL,

    -- JSON for user settings that lack a fixed structure
    `settings` JSON NULL,

    -- TIMESTAMP for audit logs that should be timezone-aware
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Primary Key and Unique Constraint for Email
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB;