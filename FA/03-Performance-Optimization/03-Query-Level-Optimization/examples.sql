CREATE TABLE IF NOT EXISTS `logs` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `message` VARCHAR(255),
    `log_time` DATETIME NOT NULL,
    KEY `idx_log_time` (`log_time`)
) ENGINE=InnoDB;

-- (در اینجا باید کدی برای درج تعداد بسیار زیادی رکورد لاگ، مثلا ۱-۲ میلیون، قرار دهید)

-- ############## سناریو ۱: تابع در WHERE ##############

-- روش بد: استفاده از تابع DATE()
EXPLAIN SELECT id, message FROM logs WHERE DATE(log_time) = '2025-10-06';
-- >> نتیجه مورد انتظار: یک اسکن کامل (type: ALL) یا اسکن کل ایندکس (type: index)
-- MySQL نمی‌تواند از ایندکس idx_log_time به صورت بهینه استفاده کند.

-- روش خوب: استفاده از شرط range
EXPLAIN SELECT id, message FROM logs WHERE log_time >= '2025-10-06 00:00:00' AND log_time < '2025-10-07 00:00:00';
-- >> نتیجه مورد انتظار: یک اسکن بهینه (type: range) با استفاده از ایندکس.


-- ############## سناریو ۲: صفحه‌بندی (Pagination) ##############

-- فرض کنید جدول logs میلیون‌ها رکورد دارد.

-- روش کند: OFFSET در صفحات بالا
-- این کوئری را اجرا کنید (نه فقط EXPLAIN) و زمان آن را بسنجید.
-- SELECT id, log_time FROM logs ORDER BY id LIMIT 100 OFFSET 500000;

-- روش سریع: Keyset Pagination
-- فرض کنید آخرین id در صفحه قبل 500000 بوده است.
-- این کوئری را اجرا کنید و زمان آن را با قبلی مقایسه کنید.
-- SELECT id, log_time FROM logs WHERE id > 500000 ORDER BY id LIMIT 100;

-- >> نتیجه مورد انتظار: کوئری دوم باید به صورت چشمگیری سریع‌تر باشد.
