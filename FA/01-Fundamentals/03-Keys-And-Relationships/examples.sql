-- مرحله ۱: ساخت جداول با کلیدهای اصلی و خارجی

CREATE TABLE IF NOT EXISTS `users` (
       `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
       `name` VARCHAR(100) NOT NULL,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `orders` (
        `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        `order_date` DATE NOT NULL,
        `amount` DECIMAL(10, 2) NOT NULL,
        `user_id` BIGINT UNSIGNED, -- می‌تواند NULL باشد اگر سفارشی به کاربر خاصی تعلق نداشته باشد
        PRIMARY KEY (`id`),
        KEY `idx_user_id` (`user_id`), -- یک ایندکس معمولی برای بهبود سرعت join
        CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
    ) ENGINE=InnoDB;


-- مرحله ۲: درج داده‌های نمونه

-- کاربرانی داریم که یکی از آن‌ها هیچ سفارشی ندارد
INSERT INTO `users` (`id`, `name`) VALUES (1, 'علی رضایی'), (2, 'مریم احمدی'), (3, 'رضا حسینی');

-- سفارشاتی داریم که یکی از آن‌ها به هیچ کاربری تعلق ندارد (user_id is NULL)
INSERT INTO `orders` (`id`, `order_date`, `amount`, `user_id`) VALUES
   (101, '2025-10-01', 150.00, 1),
   (102, '2025-10-02', 75.50, 2),
   (103, '2025-10-03', 200.00, 1),
   (104, '2025-10-04', 50.00, NULL);


-- مرحله ۳: اجرای کوئری‌های JOIN

-- INNER JOIN: نمایش سفارشات به همراه نام کاربری که آن را ثبت کرده
-- (فقط کاربرانی که سفارش دارند نمایش داده می‌شوند)
SELECT
    o.id AS order_id,
    o.amount,
    u.name AS customer_name
FROM orders AS o
     INNER JOIN users AS u ON o.user_id = u.id;
-- انتظار می‌رود ۳ ردیف برگردانده شود.


-- LEFT JOIN: نمایش تمام کاربران و سفارشات آن‌ها (در صورت وجود)
-- (کاربر "رضا حسینی" که سفارشی ندارد هم با مقادیر NULL نمایش داده می‌شود)
SELECT
    u.name AS customer_name,
    o.id AS order_id,
    o.amount
FROM users AS u
     LEFT JOIN orders AS o ON u.id = o.user_id;
-- انتظار می‌رود ۴ ردیف برگردانده شود.