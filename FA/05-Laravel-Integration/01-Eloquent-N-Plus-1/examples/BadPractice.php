<?php
namespace App\Http\Controllers;

use App\Models\Post;

class PostController extends Controller
{
    /**
     * این متد به دلیل عدم استفاده از Eager Loading،
     * باعث ایجاد مشکل N+1 Query می‌شود.
     */
    public function index()
    {
        // 1 Query to get all posts
        $posts = Post::latest()->take(50)->get();

        // حالا در ویو، برای هر پست یک کوئری جداگانه برای گرفتن نویسنده اجرا می‌شود.
        // 50 additional queries! Total = 51 queries.

        return view('posts.index', ['posts' => $posts]);
    }
}

/*
// Corresponding Blade View (resources/views/posts/index.blade.php)

@foreach ($posts as $post)
    <div class="post">
        <h2>{{ $post->title }}</h2>
        <p>By: {{ $post->user->name }}</p>
    </div>
@endforeach
*/