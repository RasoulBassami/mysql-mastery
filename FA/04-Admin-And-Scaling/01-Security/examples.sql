-- تصور کنید دیتابیس اپلیکیشن ما `my_app` نام دارد.
CREATE DATABASE IF NOT EXISTS `my_app`;
USE `my_app`;
CREATE TABLE IF NOT EXISTS `products` (id INT, name VARCHAR(100));
INSERT INTO products VALUES (1, 'Laptop'), (2, 'Mouse');

-- مرحله ۱: ساخت کاربران با پسوردهای قوی

-- کاربر اپلیکیشن که فقط از لوکال‌هاست متصل می‌شود
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'Str0ngP@ssw0rd!_App';

-- کاربر گزارش‌گیری که از هر آدرسی می‌تواند متصل شود (مثلاً برای اتصال ابزارهای BI)
CREATE USER 'reporter'@'%' IDENTIFIED BY 'Str0ngP@ssw0rd!_Report';


-- مرحله ۲: اعطای دسترسی بر اساس اصل حداقل دسترسی

-- کاربر اپلیکیشن فقط به دیتابیس my_app و فقط دسترسی‌های لازم برای عملیات CRUD را دارد.
-- دسترسی DELETE به او داده نشده است.
GRANT SELECT, INSERT, UPDATE ON `my_app`.* TO 'app_user'@'localhost';

-- کاربر گزارش‌گیری فقط و فقط اجازه SELECT روی جدول محصولات را دارد.
GRANT SELECT ON `my_app`.`products` TO 'reporter'@'%';


-- مرحله ۳: اعمال تغییرات و مشاهده دسترسی‌ها

-- این دستور کش دسترسی‌ها را در MySQL تازه‌سازی می‌کند.
FLUSH PRIVILEGES;

-- مشاهده دسترسی‌هایی که به هر کاربر داده شده است
SHOW GRANTS FOR 'app_user'@'localhost';
SHOW GRANTS FOR 'reporter'@'%';


-- مرحله ۴ (اختیاری): لغو دسترسی و حذف کاربر
-- REVOKE SELECT ON `my_app`.`products` FROM 'reporter'@'%';
-- DROP USER 'reporter'@'%';
