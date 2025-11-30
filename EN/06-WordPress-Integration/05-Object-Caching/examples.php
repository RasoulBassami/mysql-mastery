<?php
/**
 * A function that generates a heavy report and stores it in Object Cache.
 *
 * @return array
 */
function get_complex_report() {
    $cache_key = 'my_complex_report'; // A unique key for the cache
    $cache_group = 'reports';         // (Optional) Cache group
    $expiration = 3600;               // 1 Hour in seconds

    // 1. First, try to get data from cache.
    $report_data = wp_cache_get($cache_key, $cache_group);

    // 2. If data is NOT in cache (Cache Miss)
    if (false === $report_data) {
        // Debug message: Shows we are generating new data.
        error_log('Cache miss! Generating new report.');

        // 3. Perform heavy, time-consuming operation (e.g., a complex $wpdb query).
        // Simulating data generation here.
        $report_data = [
            'generated_at' => current_time('mysql'),
            'data' => [
                'total_sales' => 15000,
                'top_product' => 'Awesome T-Shirt',
            ],
        ];

        // 4. Store result in cache for future requests.
        wp_cache_set($cache_key, $report_data, $cache_group, $expiration);
    }

    // 5. Return data (either from cache or freshly generated).
    return $report_data;
}

// The first time you call this function, you will see 'Cache miss!' in the error log.
// On subsequent calls (within 1 hour), data is read directly from cache, and no log is written.
