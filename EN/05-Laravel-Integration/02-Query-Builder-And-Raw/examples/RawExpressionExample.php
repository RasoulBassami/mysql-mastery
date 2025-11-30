<?php
namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * ☠️ Vulnerable to SQL Injection ☠️
     * This is an example of what NEVER to do.
     */
    public function searchVulnerable(Request $request)
    {
        $name = $request->input('name');
        // User input is directly concatenated into the raw SQL string.
        return DB::select(DB::raw("SELECT * FROM users WHERE name = '$name'"));
    }

    /**
     * ✅ Secure using Bindings ✅
     * This is the correct and safe way to execute raw queries.
     */
    public function searchSecure(Request $request)
    {
        $name = $request->input('name');
        // Laravel safely replaces the '?' placeholder with the $name variable.
        return DB::select('SELECT * FROM users WHERE name = ?', [$name]);
    }
}
