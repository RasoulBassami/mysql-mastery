<?php
namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    /**
     * این متد یک گزارش پیچیده از مجموع فروش به تفکیک دسته‌بندی
     * با استفاده از Query Builder تولید می‌کند.
     */
    public function categorySalesReport()
    {
        $report = DB::table('categories')
            ->join('products', 'categories.id', '=', 'products.category_id')
            ->join('order_items', 'products.id', '=', 'order_items.product_id')
            ->select(
                'categories.name as category_name',
                DB::raw('SUM(order_items.price * order_items.quantity) as total_revenue'),
                DB::raw('COUNT(DISTINCT order_items.order_id) as total_orders')
            )
            ->groupBy('categories.name')
            ->orderBy('total_revenue', 'desc')
            ->get();

        return view('reports.category_sales', ['report' => $report]);
    }
}