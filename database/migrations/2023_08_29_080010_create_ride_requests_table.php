<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRideRequestsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {

        Schema::create('ride_requests', function (Blueprint $table) {
            $table->id()->unique();
            $table->integer('user_id');
            $table->string('username');
            $table->string('status');
            $table->string('driver_id')->nullable();
            $table->string('destination_longitude');
            $table->string('destination_latitude');
            $table->string('destination_address');
            $table->string('pickup');
            $table->string('position_latitude');
            $table->string('position_longitude');
            $table->string('distance_text');
            $table->string('distance_value');
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
        Schema::dropIfExists('ride_requests');
    }
}
