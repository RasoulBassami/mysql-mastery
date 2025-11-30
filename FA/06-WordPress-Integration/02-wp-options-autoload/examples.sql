-- ############## شده Autoload مرحله ۱: تشخیص حجم کل داده‌های ##############
-- این کوئری را اجرا کنید تا وضعیت کلی سایت خود را بسنجید.
-- اگر نتیجه بالای ۲-۳ مگابایت بود، باید به سراغ مرحله بعد بروید.

SELECT CONCAT(ROUND(SUM(LENGTH(option_value)) / 1024 / 1024, 2), ' MB') AS autoload_size
FROM wp_options
WHERE autoload = 'yes';


-- ############## مرحله ۲: پیدا کردن بزرگترین گزینه‌ها ##############
-- این کوئری به شما کمک می‌کند مقصران اصلی کندی را شناسایی کنید.
--ها دقت کنید تا بفهمید مربوط به کدام پلاگین هستند option_name به .

SELECT
    option_name,
    CONCAT(ROUND(LENGTH(option_value) / 1024, 2), ' KB') AS option_size_kb,
    autoload
FROM
    wp_options
WHERE
    autoload = 'yes'
ORDER BY
    LENGTH(option_value) DESC
    LIMIT 20;


-- ############## مرحله ۳: بهینه‌سازی (اجرا با احتیاط فراوان) ##############
-- هشدار: قبل از اجرای این دستور، حتماً از دیتابیس خود بک‌آپ بگیرید.
-- را با نام گزینه‌ای که در مرحله قبل پیدا کرده‌اید، جایگزین کنید 'some_large_option_name' نام

-- UPDATE wp_options SET autoload = 'no' WHERE option_name = 'some_large_option_name';

-- پس از اجرای این دستور برای گزینه‌های مورد نظر، کوئری مرحله ۱ را دوباره اجرا کنید
-- و کاهش حجم autoload شده را مشاهده کنید.