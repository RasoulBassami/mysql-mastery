<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('posts', function (Blueprint $table) {
            // 1. کلید اصلی
            $table->id();

            // 2. کلید خارجی به جدول کاربران
            // با نام‌گذاری صریح و تعریف رفتار onDelete
            $table->foreignId('user_id')
                ->constrained('users')
                ->onDelete('cascade')
                ->onUpdate('cascade');

            // 3. ستون‌های داده
            $table->string('title');
            $table->string('slug');
            $table->text('body');
            $table->string('status', 20); // e.g., 'draft', 'published', 'archived'
            $table->timestamp('published_at')->nullable();
            $table->timestamps();

            // 4. تعریف ایندکس‌ها
            $table->unique('slug', 'posts_slug_unique');
            $table->index('status', 'posts_status_index');
            $table->index(['status', 'published_at'], 'posts_status_published_at_index');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('posts');
    }
}