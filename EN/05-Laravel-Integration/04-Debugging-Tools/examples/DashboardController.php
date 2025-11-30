<?php
namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Post;

class DashboardController extends Controller
{
    /**
     * This method renders a dashboard that intentionally contains
     * performance issues for detection with Debugbar/Telescope.
     */
    public function index()
    {
        // Scenario 1: N+1 Query Problem
        // Fetching latest 10 posts without Eager Loading
        $latestPosts = Post::latest()->take(10)->get();

        // In the view, accessing author name for each post triggers 10 extra queries.
        // Debugbar or Telescope will show 11 total queries.

        // Scenario 2: Duplicate Query
        // Imagine we need total user count in another part of the code.
        $totalUsers = User::count();
        $activeUsers = User::where('is_active', true)->count();
        // ... some other code ...
        $anotherTotalUsers = User::count(); // Duplicate Query!

        // Debugbar will detect and warn about this duplicate query.

        return view('dashboard.index', [
            'latestPosts' => $latestPosts,
            'totalUsers' => $totalUsers,
            'activeUsers' => $activeUsers,
        ]);
    }
}
