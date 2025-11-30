<?php
/**
 * یک تابع امن برای پیدا کردن پست‌های یک نویسنده که کلمه خاصی در عنوانشان وجود دارد.
 *
 * @param int    $user_id   ID نویسنده.
 * @param string $keyword   کلمه کلیدی برای جستجو در عنوان.
 * @return array|object|null
 */
function get_author_posts_with_keyword(int $user_id, string $keyword) {
    global $wpdb;

    // آماده‌سازی کوئری با استفاده از prepare
    $query = $wpdb->prepare(
        "SELECT ID, post_title
         FROM {$wpdb->posts}
         WHERE post_author = %d
         AND post_title LIKE %s
         AND post_status = 'publish'
         AND post_type = 'post'",
        $user_id,
        '%' . $wpdb->esc_like($keyword) . '%' // آماده‌سازی رشته برای استفاده در LIKE
    );

    $results = $wpdb->get_results($query);

    return $results;
}


/**
 * مثالی از یک کوئری سنگین که نتایج آن با استفاده از Transients API کش می‌شود.
 * این تابع گزارش فروش روزانه را تولید می‌کند.
 */
function get_daily_sales_report_cached() {
    // ابتدا در کش جستجو می‌کنیم.
    $report = get_transient('daily_sales_report');

    // اگر گزارش در کش موجود بود، همان را برمی‌گردانیم.
    if (false !== $report) {
        return $report;
    }

    // اگر در کش نبود، کوئری سنگین را اجرا می‌کنیم.
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

    // نتیجه را در کش برای ۱۲ ساعت ذخیره می‌کنیم.
    set_transient('daily_sales_report', $report, 12 * HOUR_IN_SECONDS);

    return $report;
}
