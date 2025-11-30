-- Step 1: Create table and sample data
CREATE TABLE IF NOT EXISTS `accounts` (
    `id` INT PRIMARY KEY,
    `balance` INT NOT NULL
) ENGINE=InnoDB;

TRUNCATE TABLE `accounts`;
INSERT INTO `accounts` VALUES (1, 1000), (2, 2000);

-- ############## Simulating a Deadlock ##############
-- For this test, you need two terminal windows or DB clients.
-- Run "Connection 1" commands in the first window, and "Connection 2" in the second.

-- ## Connection 1 (Window 1)
START TRANSACTION;
-- Locks account 1 for update
UPDATE `accounts` SET `balance` = `balance` - 100 WHERE `id` = 1;

-- Now wait and switch to Window 2...


-- ## Connection 2 (Window 2)
START TRANSACTION;
-- Locks account 2 for update
UPDATE `accounts` SET `balance` = `balance` + 100 WHERE `id` = 2;
-- This executes successfully as there is no conflict yet.


-- ## Connection 1 (Back to Window 1)
-- Now transaction 1 tries to lock account 2,
-- BUT account 2 is locked by transaction 2. So this transaction WAITS.
UPDATE `accounts` SET `balance` = `balance` + 100 WHERE `id` = 2;


-- ## Connection 2 (Back to Window 2)
-- Now transaction 2 tries to lock account 1,
-- BUT account 1 is locked by transaction 1.
UPDATE `accounts` SET `balance` = `balance` - 100 WHERE `id` = 1;

-- >> RESULT: Immediately, MySQL detects the Deadlock cycle.
-- One transaction receives an ERROR and is rollbacked. The other proceeds.

-- To view the deadlock report, run this immediately after the error:
-- SHOW ENGINE INNODB STATUS;
