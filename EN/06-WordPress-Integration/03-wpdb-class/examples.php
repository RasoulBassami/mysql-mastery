<?php
/**
 * A secure function to find posts by an author containing a specific keyword in the title.
 *
 * @param int    $user_id   Author ID.
 * @param string $keyword   Keyword to search in title.
 * @return array|object|null
 */
function get_author_posts_with_keyword(int $user_id, string $keyword) {
    global $wpdb;

    // Preparing the query using prepare()
    $query = $wpdb->prepare(
        "SELECT ID, post_title
         FROM {$wpdb->posts}
         WHERE post_author = %d
         AND post_title LIKE %s
         AND post_status = 'publish'
         AND post_type = 'post'",
        $user_id,
        '%' . $wpdb->esc_like($keyword) . '%' // Escaping string for LIKE usage
    );

    $results = $wpdb->get_results($query);

    return $results;
}


/**
 * Example of a heavy query cached using Transients API.
 * This function generates a daily sales report.
 */
function get_daily_sales_report_cached() {
    // First, try to get data from cache.
    $report = get_transient('daily_sales_report');

    // If report exists in cache, return it.
    if (false !== $report) {
        return $report;
    }

    // If not in cache, run the heavy query.
    global $wpdb;
    $query = "
        SELECT DATE(p.post_date) AS sale_date, SUM(pm.meta_value) AS daily_total
        FROM {$wpdb->posts} p
        JOIN {$wpdb->postmeta} pm ON p.ID = pm.post_id
        WHERE p.post_type = 'shop_order'
        AND pm.meta_key = '_order_total'
        GROUP BY sale_date
        ORDER BY sale_date DESC
        LIMIT 30
    ";
    $report = $wpdb->get_results($query);

    // Store result in cache for 12 hours.
    set_transient('daily_sales_report', $report, 12 * HOUR_IN_SECONDS);

    return $report;
}
