<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRidesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('rides', function (Blueprint $table) {
            $table->id();

            $table->tinyInteger('driver_id')->nullable(false);

            $table->string('amount')->nullable();

            $table->string('destination')->nullable(false);

            /* $table->string('pickup1')->nullable(false);

            $table->string('pickup2')->nullable(); */

            $table->json('pickups')->nullable();

            //departure
            $table->string('departure_time')->nullable(false);

            //knockoff locations
            $table->json('knockoffs')->nullable();

            //ride capacity
            $table->tinyInteger('capacity')->nullable(false);


            $table->Integer('status')->nullable(false);

            $table->Integer('car')->nullable(false);

            //ride capacity
            $table->tinyInteger('ride_status')->nullable(false);



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
        Schema::dropIfExists('rides');
    }
}
