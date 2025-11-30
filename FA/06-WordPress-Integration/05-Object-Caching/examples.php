<?php
/**
 * تابعی که یک گزارش سنگین را تولید کرده و آن را در Object Cache ذخیره می‌کند.
 *
 * @return array
 */
function get_complex_report() {
    $cache_key = 'my_complex_report'; // یک کلید یکتا برای کش
    $cache_group = 'reports';         // (اختیاری) گروه‌بندی کش‌ها
    $expiration = 3600;               // ۱ ساعت به ثانیه

    // ۱. ابتدا سعی می‌کنیم داده را از کش بخوانیم.
    $report_data = wp_cache_get($cache_key, $cache_group);

    // ۲. اگر داده در کش نبود (Cache Miss)
    if (false === $report_data) {
        // پیام برای دیباگ: نشان می‌دهد که ما در حال تولید داده جدید هستیم.
        error_log('Cache miss! Generating new report.');

        // ۳. عملیات سنگین و زمان‌بر را انجام می‌دهیم (مثلاً یک کوئری پیچیده $wpdb).
        // در اینجا فقط آن را شبیه‌سازی می‌کنیم.
        $report_data = [
            'generated_at' => current_time('mysql'),
            'data' => [
                'total_sales' => 15000,
                'top_product' => 'Awesome T-Shirt',
            ],
        ];

        // ۴. نتیجه را در کش ذخیره می‌کنیم تا در درخواست بعدی استفاده شود.
        wp_cache_set($cache_key, $report_data, $cache_group, $expiration);
    }

    // ۵. داده را (از کش یا تازه تولید شده) برمی‌گردانیم.
    return $report_data;
}

// بار اول که این تابع را صدا بزنید، پیام 'Cache miss!' را در لاگ خطا خواهید دید.
// در دفعات بعدی (تا قبل از ۱ ساعت)، داده مستقیماً از کش خوانده می‌شود و هیچ پیامی در لاگ ثبت نخواهد شد.
