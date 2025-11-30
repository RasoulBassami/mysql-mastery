CREATE TABLE IF NOT EXISTS `events` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_type` VARCHAR(50) NOT NULL, -- Cardinality پایین
    `user_id` INT UNSIGNED NOT NULL,   -- Cardinality بالا
    `payload` JSON,
    `created_at` TIMESTAMP NOT NULL
) ENGINE=InnoDB;

-- (در اینجا باید کدی برای درج تعداد زیادی رکورد رندوم قرار دهید)

-- ############## سناریو کاردینالیتی ##############

-- کوئری: پیدا کردن تمام رویدادهای یک کاربر از یک نوع خاص
EXPLAIN SELECT id, created_at FROM events WHERE user_id = 50 AND event_type = 'login_success';

-- ایندکس بد: ستون با کاردینالیتی پایین در ابتدا
CREATE INDEX idx_bad_cardinality ON events (event_type, user_id);

-- ایندکس خوب: ستون با کاردینالیتی بالا در ابتدا
CREATE INDEX idx_good_cardinality ON events (user_id, event_type);

-- با اجرای EXPLAIN روی کوئری بالا، مشاهده خواهید کرد که MySQL
-- ایندکس idx_good_cardinality را ترجیح می‌دهد و تعداد rows کمتری را اسکن می‌کند.


-- ############## سناریو ایندکس پوششی ##############

-- کوئری: پیدا کردن زمان تمام رویدادهای یک کاربر
EXPLAIN SELECT created_at FROM events WHERE user_id = 100;

-- ایندکس معمولی (غیر پوششی)
CREATE INDEX idx_user ON events (user_id);
-- >> نتیجه EXPLAIN: خوب است، اما ستون Extra خالی است.

-- ایندکس پوششی
CREATE INDEX idx_user_cover ON events (user_id, created_at);
-- >> نتیجه EXPLAIN: عالی! ستون Extra عبارت "Using index" را نشان می‌دهد.
-- این یعنی کوئری بدون لمس کردن جدول اصلی پاسخ داده شده است.
