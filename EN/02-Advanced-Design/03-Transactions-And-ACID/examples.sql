-- Step 1: Create accounts table and insert initial data
CREATE TABLE IF NOT EXISTS `accounts` (
    `id` VARCHAR(10) PRIMARY KEY,
    `owner_name` VARCHAR(100) NOT NULL,
    `balance` DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB;

TRUNCATE TABLE `accounts`; -- Reset table for testing

INSERT INTO `accounts` (`id`, `owner_name`, `balance`) VALUES
    ('A-101', 'Ali', 500.00),
    ('B-202', 'Maryam', 700.00);

-- Step 2: Simulate a successful transfer
START TRANSACTION;

UPDATE `accounts` SET `balance` = `balance` - 100 WHERE `id` = 'A-101';
UPDATE `accounts` SET `balance` = `balance` + 100 WHERE `id` = 'B-202';

COMMIT;

-- Verify result: Ali should have 400, Maryam 800.
SELECT * FROM `accounts`;


-- Step 3: Simulate a failed transfer and ROLLBACK
START TRANSACTION;

UPDATE `accounts` SET `balance` = `balance` - 50 WHERE `id` = 'A-101';
UPDATE `accounts` SET `balance` = `balance` + 50 WHERE `id` = 'B-202';

-- Assume we detect an error here and decide to cancel.
ROLLBACK;

-- Verify result: Balances should revert to state before this transaction.
-- (Ali 400, Maryam 800)
SELECT * FROM `accounts`;