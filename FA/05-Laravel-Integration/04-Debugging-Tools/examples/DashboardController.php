<?php
namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Post;

class DashboardController extends Controller
{
    /**
     * این متد یک داشبورد را نمایش می‌دهد که عمداً شامل
     * مشکلات عملکردی برای شناسایی با Debugbar/Telescope است.
     */
    public function index()
    {
        // سناریو ۱: مشکل N+1 Query
        // واکشی ۱۰ پست آخر بدون Eager Loading
        $latestPosts = Post::latest()->take(10)->get();

        // در ویو، برای هر پست، نام نویسنده آن نمایش داده می‌شود که باعث ۱۰ کوئری اضافه می‌شود.
        // Debugbar یا Telescope به شما ۱۱ کوئری را نشان خواهند داد.

        // سناریو ۲: کوئری تکراری
        // فرض کنید در بخش دیگری از کد، دوباره به تعداد کل کاربران نیاز داریم.
        $totalUsers = User::count();
        $activeUsers = User::where('is_active', true)->count();
        // ... چند خط کد دیگر ...
        $anotherTotalUsers = User::count(); // کوئری تکراری!

        // Debugbar این کوئری تکراری را شناسایی و به شما هشدار می‌دهد.

        return view('dashboard.index', [
            'latestPosts' => $latestPosts,
            'totalUsers' => $totalUsers,
            'activeUsers' => $activeUsers,
        ]);
    }
}