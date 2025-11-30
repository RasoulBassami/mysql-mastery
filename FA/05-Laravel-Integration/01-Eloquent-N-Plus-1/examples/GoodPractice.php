<?php
namespace App\Http\Controllers;

use App\Models\Post;

class PostController extends Controller
{
    /**
     * این متد با استفاده از Eager Loading (`with()`)
     * مشکل N+1 Query را حل کرده است.
     */
    public function index()
    {
        // با استفاده از with('user')، لاراول تمام نویسندگان مورد نیاز را
        // فقط با یک کوئری اضافه واکشی می‌کند.
        $posts = Post::with('user')->latest()->take(50)->get();

        // Total queries = 2 (یکی برای پست‌ها، یکی برای نویسندگان)
        // این روش بسیار بهینه‌تر است.

        return view('posts.index', ['posts' => $posts]);
    }
}