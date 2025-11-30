<?php
namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * ☠️ آسیب‌پذیر در برابر SQL Injection ☠️
     * این یک مثال از کاری است که هرگز نباید انجام دهید.
     */
    public function searchVulnerable(Request $request)
    {
        $name = $request->input('name');
        // ورودی کاربر مستقیماً در رشته SQL خام قرار گرفته است.
        return DB::select(DB::raw("SELECT * FROM users WHERE name = '$name'"));
    }

    /**
     * ✅ امن با استفاده از Bindings ✅
     * این روش صحیح و امن برای اجرای کوئری‌های خام است.
     */
    public function searchSecure(Request $request)
    {
        $name = $request->input('name');
        // لاراول مقدار متغیر name$ را به صورت امن جایگزین علامت سوال می‌کند.
        return DB::select('SELECT * FROM users WHERE name = ?', [$name]);
    }
}