<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePassengersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('passengers', function (Blueprint $table) {
            $table->id();
            $table->tinyInteger('ride_id');

            $table->tinyInteger('passenger_id');

            // status can be accepted, declined,cancelled or completed
            $table->tinyInteger('request_status');

            $table->tinyInteger('passenger_ride_status');

            $table->tinyInteger('seats');

            $table->string('pickup');

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
        Schema::dropIfExists('passengers');
    }
}
