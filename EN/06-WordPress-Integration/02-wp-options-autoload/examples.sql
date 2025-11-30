-- ############## Step 1: Detect Total Autoloaded Data Size ##############
-- Run this query to assess your site's overall health.
-- If the result is above 2-3 MB, proceed to the next step.

SELECT CONCAT(ROUND(SUM(LENGTH(option_value)) / 1024 / 1024, 2), ' MB') AS autoload_size
FROM wp_options
WHERE autoload = 'yes';


-- ############## Step 2: Find the Largest Options ##############
-- This query helps you identify the main culprits of slowness.
-- Look at option_name to figure out which plugin they belong to.

SELECT
    option_name,
    CONCAT(ROUND(LENGTH(option_value) / 1024, 2), ' KB') AS option_size_kb,
    autoload
FROM
    wp_options
WHERE
    autoload = 'yes'
ORDER BY
    LENGTH(option_value) DESC
    LIMIT 20;


-- ############## Step 3: Optimization (Execute with Extreme Caution) ##############
-- Warning: Before running this command, ensure you have a database backup.
-- Replace 'some_large_option_name' with the option name you found in the previous step.

-- UPDATE wp_options SET autoload = 'no' WHERE option_name = 'some_large_option_name';

-- After running this for target options, run the Step 1 query again
-- to observe the reduction in autoload size.
