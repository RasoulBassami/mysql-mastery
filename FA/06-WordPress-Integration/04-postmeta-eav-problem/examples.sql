-- ############## مثال ۱: کوئری پیچیده‌ای که وردپرس برای meta_query تولید می‌کند (شبیه‌سازی شده) ##############
-- این کوئری برای پیدا کردن محصولات موجود با قیمت بین ۵۰ تا ۱۰۰ است.
-- به JOIN های تکراری و CAST کردن نوع داده توجه کنید.

SELECT DISTINCT p.ID
FROM wp_posts AS p
         INNER JOIN wp_postmeta AS pm1 ON (p.ID = pm1.post_id)
         INNER JOIN wp_postmeta AS pm2 ON (p.ID = pm2.post_id)
WHERE
    p.post_type = 'product'
  AND p.post_status = 'publish'
  AND (pm1.meta_key = '_stock_status' AND pm1.meta_value = 'instock')
  AND (pm2.meta_key = '_price' AND CAST(pm2.meta_value AS DECIMAL(10,2)) BETWEEN 50 AND 100);


-- ############## مثال ۲: ساختار یک جدول Lookup سفارشی (مانند ووکامرس) ##############
CREATE TABLE IF NOT EXISTS `wp_product_lookup` (
    `product_id` BIGINT(20) UNSIGNED NOT NULL,
    `price` DECIMAL(10, 2) NULL,
    `stock_status` VARCHAR(100) NULL,
    `stock_quantity` INT NULL,
    PRIMARY KEY (`product_id`),
    KEY `price` (`price`),
    KEY `stock_status` (`stock_status`)
) ENGINE=InnoDB;


-- ############## مثال ۳: کوئری ساده و سریع با استفاده از جدول Lookup ##############
-- همان نتیجه کوئری اول، اما به شکلی بسیار ساده‌تر و سریع‌تر.

SELECT p.ID
FROM wp_posts AS p
         INNER JOIN wp_product_lookup AS lookup ON p.ID = lookup.product_id
WHERE
    p.post_type = 'product'
  AND p.post_status = 'publish'
  AND lookup.stock_status = 'instock'
  AND lookup.price BETWEEN 50 AND 100;
