-- مرحله ۱: ساخت جداول و درج داده‌های نمونه
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(150) NOT NULL,
    `status` TINYINT NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP
) ENGINE=InnoDB;

-- (در اینجا باید کدی برای درج تعداد زیادی رکورد رندوم قرار دهید تا تفاوت عملکرد مشخص شود)

-- ############## سناریو اول: کوئری بدون ایندکس ##############

-- اجرای EXPLAIN روی کوئری که هیچ ایندکسی برای ستون email وجود ندارد
EXPLAIN SELECT id, email FROM users WHERE email = 'some-random-email@example.com';
-- >> نتیجه مورد انتظار: type: ALL, key: NULL, rows: (تعداد کل ردیف‌های جدول)
-- این یعنی فاجعه! کل جدول اسکن می‌شود.

-- حالا ایندکس را اضافه می‌کنیم
CREATE INDEX `idx_email` ON `users` (`email`);

-- دوباره همان EXPLAIN را اجرا می‌کنیم
EXPLAIN SELECT id, email FROM users WHERE email = 'some-random-email@example.com';
-- >> نتیجه مورد انتظار: type: ref, key: idx_email, rows: 1
-- بهبود فوق‌العاده!


-- ############## سناریو دوم: مشکل Filesort در مرتب‌سازی ##############

-- اجرای EXPLAIN روی کوئری که بر اساس یک ستون غیر ایندکس شده مرتب می‌شود
EXPLAIN SELECT id, email FROM users WHERE status = 1 ORDER BY created_at DESC;
-- >> نتیجه مورد انتظار: Extra: "Using where; Using filesort"
-- این یعنی MySQL داده‌ها را پیدا کرده و سپس در یک مرحله جداگانه مرتب کرده است.

-- حالا یک ایندکس چندستونی مناسب می‌سازیم که هم فیلتر و هم مرتب‌سازی را پوشش دهد
CREATE INDEX `idx_status_created` ON `users` (`status`, `created_at`);

-- دوباره همان EXPLAIN را اجرا می‌کنیم
EXPLAIN SELECT id, email FROM users WHERE status = 1 ORDER BY created_at DESC;
-- >> نتیجه مورد انتظار: عبارت "Using filesort" باید حذف شده باشد.
-- MySQL حالا می‌تواند نتایج را مستقیماً از ایندکس به صورت مرتب‌شده بخواند.
