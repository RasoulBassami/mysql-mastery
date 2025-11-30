-- Assume our application database is named `my_app`.
CREATE DATABASE IF NOT EXISTS `my_app`;
USE `my_app`;
CREATE TABLE IF NOT EXISTS `products` (id INT, name VARCHAR(100));
INSERT INTO products VALUES (1, 'Laptop'), (2, 'Mouse');

-- Step 1: Create users with strong passwords

-- App user connecting only from localhost
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'Str0ngP@ssw0rd!_App';

-- Reporting user connecting from any host (e.g., for BI tools)
CREATE USER 'reporter'@'%' IDENTIFIED BY 'Str0ngP@ssw0rd!_Report';


-- Step 2: Grant privileges based on Least Privilege

-- App user only gets CRUD access to my_app database.
-- DELETE privilege is NOT granted.
GRANT SELECT, INSERT, UPDATE ON `my_app`.* TO 'app_user'@'localhost';

-- Reporting user only gets SELECT access on the products table.
GRANT SELECT ON `my_app`.`products` TO 'reporter'@'%';


-- Step 3: Apply changes and view grants

-- Refresh privileges cache
FLUSH PRIVILEGES;

-- View grants for each user
SHOW GRANTS FOR 'app_user'@'localhost';
SHOW GRANTS FOR 'reporter'@'%';


-- Step 4 (Optional): Revoke access and delete user
-- REVOKE SELECT ON `my_app`.`products` FROM 'reporter'@'%';
-- DROP USER 'reporter'@'%';