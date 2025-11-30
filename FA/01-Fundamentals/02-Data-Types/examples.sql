-- این دستور یک جدول `users` با انتخاب بهینه نوع داده‌ها ایجاد می‌کند.
-- این مثال را با طراحی‌های اشتباه (مثلاً استفاده از INT برای status) مقایسه کنید.

CREATE TABLE IF NOT EXISTS `users` (
    -- BIGINT برای آینده‌نگری و جلوگیری از تمام شدن ID ها
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    -- VARCHAR برای داده‌های متغیر، NOT NULL چون نام ضروری است
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,

    -- TINYINT برای داده عددی کوچک و مشخص (مثلا: 0 = غیرفعال,  1= فعال, 2 =معلق)
    `status` TINYINT UNSIGNED NOT NULL DEFAULT 0,

    -- DATE برای تاریخ تولد، چون ساعت و Timezone مهم نیست
    `birth_date` DATE NULL,

    -- JSON برای تنظیمات کاربر که ساختار ثابتی ندارند
    `settings` JSON NULL,

    -- TIMESTAMP برای لاگ‌های زمانی که باید وابسته به Timezone باشند
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- کلید اصلی و محدودیت یکتا بودن ایمیل
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB;