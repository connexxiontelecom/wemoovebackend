<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();

            $table->string('full_name')->nullable(false);

            $table->string('email')->unique();

            $table->timestamp('email_verified_at')->nullable();

            $table->string('password')->nullable(false);

            $table->string('profile_image')->default('avatar.png');

            $table->string('phone_number')->nullable(false);

            //address of user
            $table->string('address')->nullable();

            //user type whether 0-passenger or  1-driver
            $table->tinyInteger('user_type')->default(0);
            //$table->tinyInteger('driver')->default(0);

            //Account Status suspended or active
            $table->tinyInteger('status')->default(0);

            //if user has been verified
            $table->tinyInteger('verified')->default(0);

            $table->string('device_token')->nullable();

            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
