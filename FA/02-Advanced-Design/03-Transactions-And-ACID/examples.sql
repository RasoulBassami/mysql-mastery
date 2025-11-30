-- مرحله ۱: ساخت جدول حساب‌ها و درج داده‌های اولیه
CREATE TABLE IF NOT EXISTS `accounts` (
                                          `id` VARCHAR(10) PRIMARY KEY,
    `owner_name` VARCHAR(100) NOT NULL,
    `balance` DECIMAL(10, 2) NOT NULL
    ) ENGINE=InnoDB;

TRUNCATE TABLE `accounts`; -- خالی کردن جدول برای هر بار اجرای تست

INSERT INTO `accounts` (`id`, `owner_name`, `balance`) VALUES
('A-101', 'Ali', 500.00),
('B-202', 'Maryam', 700.00);

-- مرحله ۲: شبیه‌سازی یک انتقال وجه موفق
START TRANSACTION;

UPDATE `accounts` SET `balance` = `balance` - 100 WHERE `id` = 'A-101';
UPDATE `accounts` SET `balance` = `balance` + 100 WHERE `id` = 'B-202';

COMMIT;

-- بررسی نتیجه: موجودی علی باید 400 و موجودی مریم باید 800 شده باشد.
SELECT * FROM `accounts`;


-- مرحله ۳: شبیه‌سازی یک انتقال وجه ناموفق و ROLLBACK
START TRANSACTION;

UPDATE `accounts` SET `balance` = `balance` - 50 WHERE `id` = 'A-101';
UPDATE `accounts` SET `balance` = `balance` + 50 WHERE `id` = 'B-202';

-- فرض کنید در این لحظه متوجه یک مشکل می‌شویم و تصمیم به لغو عملیات می‌گیریم.
ROLLBACK;

-- بررسی نتیجه: موجودی‌ها باید به حالت قبل از این تراکنش بازگشته باشند.
-- (علی 400 و مریم 800)
SELECT * FROM `accounts`;
