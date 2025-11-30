-- مرحله ۱: ساخت جدول محصولات
-- توجه کنید که برای تست واقعی ایندکس، نیاز به تعداد رکوردهای زیاد (هزاران یا میلیون‌ها) دارید.
CREATE TABLE IF NOT EXISTS `products` (
                                          `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                          `name` VARCHAR(200) NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    `brand_id` INT UNSIGNED NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB;

-- (در اینجا باید کدی برای درج تعداد زیادی رکورد رندوم قرار دهید)
-- INSERT INTO products (name, category_id, brand_id, price, is_active) VALUES ...

-- مرحله ۲: اجرای یک کوئری کند بدون ایندکس مناسب
-- فرض کنید این کوئری پرتکرارترین کوئری در صفحه لیست محصولات ماست.
-- "نمایش محصولات فعال از یک دسته‌بندی و برند خاص، مرتب‌شده بر اساس قیمت نزولی"

EXPLAIN SELECT id, name, price
        FROM products
        WHERE
            category_id = 5
          AND is_active = 1
          AND brand_id = 10
        ORDER BY price DESC;

-- خروجی EXPLAIN در این حالت احتمالاً type: ALL یا index را نشان می‌دهد و thousands of rows را اسکن می‌کند.
-- همچنین ممکن است در ستون Extra عبارت "Using filesort" را ببینید که نشانه بدی است.


-- مرحله ۳: ساخت ایندکس بهینه (چندستونی و پوششی)
-- ما بر اساس ستون‌های WHERE و ORDER BY ایندکس می‌سازیم.
-- ترتیب ستون‌ها: category_id و brand_id انتخاب‌های خوبی برای شروع هستند چون مقادیر را فیلتر می‌کنند.
-- price را هم اضافه می‌کنیم تا ORDER BY را پوشش دهد.
-- در نهایت id و name را برای پوشش دادن SELECT اضافه می‌کنیم تا ایندکس ما Covering شود.

CREATE INDEX `idx_product_query`
    ON `products` (category_id, brand_id, is_active, price DESC, id, name);


-- مرحله ۴: اجرای دوباره همان کوئری
EXPLAIN SELECT id, name, price
        FROM products
        WHERE
            category_id = 5
          AND is_active = 1
          AND brand_id = 10
        ORDER BY price DESC;

-- خروجی EXPLAIN جدید باید به شکل چشمگیری بهتر شده باشد.
-- type: ref یا range خواهد بود.
-- rows: تعداد ردیف‌های اسکن شده بسیار کمتر خواهد بود.
-- Extra: عبارت "Using index" را مشاهده خواهید کرد که نشان‌دهنده یک ایندکس پوششی است.
-- عبارت "Using filesort" باید حذف شده باشد.
