-- مرحله ۱: ساخت جدول و داده‌های نمونه
CREATE TABLE IF NOT EXISTS `accounts` (
    `id` INT PRIMARY KEY,
    `balance` INT NOT NULL
) ENGINE=InnoDB;

TRUNCATE TABLE `accounts`;
INSERT INTO `accounts` VALUES (1, 1000), (2, 2000);

-- ############## شبیه‌سازی Deadlock ##############
-- برای این تست، شما به دو پنجره ترمینال یا دو کلاینت دیتابیس نیاز دارید.
-- دستورات "Connection 1" را در پنجره اول و "Connection 2" را در پنجره دوم اجرا کنید.

-- ## Connection 1 (پنجره اول)
START TRANSACTION;
-- ابتدا حساب شماره ۱ را برای آپدیت قفل می‌کند.
UPDATE `accounts` SET `balance` = `balance` - 100 WHERE `id` = 1;

-- حالا منتظر بمانید و به سراغ پنجره دوم بروید...


-- ## Connection 2 (پنجره دوم)
START TRANSACTION;
-- ابتدا حساب شماره ۲ را برای آپدیت قفل می‌کند.
UPDATE `accounts` SET `balance` = `balance` + 100 WHERE `id` = 2;
-- این دستور باید با موفقیت اجرا شود چون با تراکنش اول تداخلی ندارد.


-- ## Connection 1 (بازگشت به پنجره اول)
-- حالا تراکنش اول تلاش می‌کند حساب شماره ۲ را قفل کند،
-- اما این حساب توسط تراکنش دوم قفل شده است. پس این تراکنش منتظر می‌ماند.
UPDATE `accounts` SET `balance` = `balance` + 100 WHERE `id` = 2;


-- ## Connection 2 (بازگشت به پنجره دوم)
-- حالا تراکنش دوم تلاش می‌کند حساب شماره ۱ را قفل کند،
-- اما این حساب توسط تراکنش اول قفل شده است.
UPDATE `accounts` SET `balance` = `balance` - 100 WHERE `id` = 1;

-- >> نتیجه: بلافاصله، MySQL یک Deadlock را تشخیص داده و یکی از این دو تراکنش
-- با خطا مواجه شده و ROLLBACK می‌شود. تراکنش دیگر می‌تواند COMMIT شود.

-- برای دیدن گزارش Deadlock، بلافاصله بعد از خطا دستور زیر را اجرا کنید:
-- SHOW ENGINE INNODB STATUS;
