<?php
namespace App\Http\Controllers;

use App\Models\Post;

class PostController extends Controller
{
    /**
     * This method causes an N+1 Query problem due to
     * missing Eager Loading.
     */
    public function index()
    {
        // 1 Query to get all posts
        $posts = Post::latest()->take(50)->get();

        // In the view, a separate query runs for each post to get the author.
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