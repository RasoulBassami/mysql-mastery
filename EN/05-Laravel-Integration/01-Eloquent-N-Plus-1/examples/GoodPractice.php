<?php
namespace App\Http\Controllers;

use App\Models\Post;

class PostController extends Controller
{
    /**
     * This method solves the N+1 Query problem
     * using Eager Loading (`with()`).
     */
    public function index()
    {
        // Using with('user'), Laravel fetches all required authors
        // with just one extra query.
        $posts = Post::with('user')->latest()->take(50)->get();

        // Total queries = 2 (One for posts, one for authors)
        // This is much more optimized.

        return view('posts.index', ['posts' => $posts]);
    }
}
