import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/AddAmountModal.dart';
import 'package:wemoove/components/AddDestinationModal.dart';
import 'package:wemoove/components/AddPickupModal.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/SelectCarModal.dart';
import 'package:wemoove/components/ValidationErrorModal.dart';
import 'package:wemoove/components/WalletBalanceError.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/controllers/ScheduleAlarm.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/Vehicle.dart';
import 'package:wemoove/models/marked_place.dart';
import 'package:wemoove/models/place.dart';
import 'package:wemoove/models/place_search.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/services/geolocator_service.dart';
import 'package:wemoove/services/marker_service.dart';
import 'package:wemoove/services/places_service.dart';
import 'package:wemoove/views/requests/RequestsScreen.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class PostRideController extends BaseViewModel {
  TextEditingController pickupController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  Vehicles car = globals.user.vehicles[0];
  String SelectedCar;

  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  List<String> pickups = [];
  List<MarkedPlace> locations = [];
  String destination = "";
  List<String> dropoffs = [];
  int seats = 3;
  bool airConditioner = false;
  String fare = "";
  String selectedPlaceId;
  int isCarSelected = -1;
  String timerror = "at least 1 hour before departure";
  ScheduleAlarm alarm = ScheduleAlarm();
  String _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place selectedLocationStatic;
  String placeType;
  List<Place> placeResults;
  List<Marker> markers = [];

  int SelectedCarId;

  PostRideController() {
    // print(globals.user.vehicles.length.toString());
    if (globals.user.vehicles.length == 1) {
      SelectedCar = car.brand + " " + car.model;
      SelectedCarId = globals.user.vehicles[0].id;
    }

    TimeOfDay now = TimeOfDay.now();
    now = now.replacing(hour: now.hour + 1);
    timeController.text = formatTimeOfDay(now);
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      selectedTime = picked;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = _hour + ' : ' + _minute;

      TimeOfDay now = TimeOfDay.now();

      double starttime = timeOfDayToDouble(now);
      double selected = timeOfDayToDouble(selectedTime);

      if (selected > starttime) {
        int hours = converToDateTime(selectedTime)
            .difference(converToDateTime(now))
            .inHours;
        if (hours >= 1) {
          timeController.text = formatTimeOfDay(selectedTime);
          notifyListeners();
        } else {
          selectedTime = selectedTime.replacing(hour: selectedTime.hour + 1);
          timeController.text = formatTimeOfDay(selectedTime);
          notifyListeners();
        }
      } else {
        timeController.text = "";
        notifyListeners();
      }
      return;
    }
  }

  double timeOfDayToDouble(TimeOfDay tod) => tod.hour + tod.minute / 60.0;

  DateTime converToDateTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return dt;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    //print("Hello");
    print("Length" + searchResults.length.toString());
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    selectedPlaceId = placeId;
    // searchResults = null;
    notifyListeners();
  }

  setSelectedPickup(String selected_pickup) {
    pickupController = new TextEditingController(text: selected_pickup);
    searchResults = null;
    notifyListeners();
  }

  setSelectedCar(value) {
    SelectedCar = globals.user.vehicles[value].brand +
        " " +
        globals.user.vehicles[value].model;
    isCarSelected = value;
    SelectedCarId = globals.user.vehicles[value].id;
    notifyListeners();
  }

  setSelectedDestination(String destination) {
    destinationController = new TextEditingController(text: destination);
    searchResults = null;
    notifyListeners();
  }

  clearSelectedDestination() {
    destinationController = new TextEditingController();
    notifyListeners();
  }

  clearSelectedPickup() {
    pickupController = new TextEditingController();
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  chooseCar(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => SelectCarModal(
              controller: this,
            ));
  }

  showAddPickupModal(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AddPickupModal(
              controller: this,
            ));
  }

  showAddAmountModal(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AddAmountModal(
              controller: this,
            ));
  }

  showAddDestinationModal(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => DestinationModal(
              controller: this,
            ));
  }

  addtoPickup(value) {
    print(value);
    if (pickups.length < 2) {
      pickups.add(value);
      locations.add(new MarkedPlace(
          name: value,
          place:
              selectedPlaceId /*points: selectedLocationStatic.geometry.location*/));
      print("Location Length" + locations.length.toString());
      selectedPlaceId = "";
      pickupController = new TextEditingController();
    } else {
      pickupController = new TextEditingController();
    }
    notifyListeners();
  }

  removefromPickup(value) {
    if (pickups.length >= 1) {
      pickups.removeAt(value);
      locations.removeAt(value);
      notifyListeners();
    }
  }

  updateDropOffs(List<String> values) {
    // print(values.length);
    dropoffs = values;
  }

  updateDestination(value) {
    destinationController = new TextEditingController(text: value);
    notifyListeners();
  }

  increment() {
    seats++;
    notifyListeners();
  }

  decrement() {
    if (seats > 1) {
      seats--;
      notifyListeners();
    }
  }

  turnOnairConditioner() {
    airConditioner = !airConditioner;
    notifyListeners();
  }

  setFare(value) {
    fare = value;
    notifyListeners();
  }

  double calculatePercentage(price, seats) {
    double rate = double.parse(price);
    int totalSeats = seats;
    double percentage = globals.config.chargeRate;
    double fee = (percentage / 100) * (rate * totalSeats);
    return fee;
  }

  PublishRide(BuildContext context) async {
    // print(dropoffs.length);
    String error = "";
    if (pickups.isEmpty || pickups.length <= 0) {
      error = "Provide at least one Pick-Up location";
      showerror(context, error);
      return;
    } else if (destinationController.text.isEmpty) {
      error = "Provide destination";
      showerror(context, error);
      return;
    } /* else if (dropoffs.isEmpty || dropoffs.length <= 0) {
      error = "Provide at least a knockoff location";
      showerror(context, error);
      return;
    }*/
    else if (fare.isEmpty) {
      error = "Specify fee for the trip";
      showerror(context, error);
      return;
    } else if (timeController.text.isEmpty) {
      error = "Provide departure time";
      showerror(context, error);
      return;
    } else if (globals.Balance < calculatePercentage(fare, seats)) {
      error =
          "Your wallet balance is insufficient for the expected charged percentage for this Trip";
      showBalanceError(context, error, calculatePercentage(fare, seats));
      return;
    }

    var data = {
      "pickups": locations,
      "dropoffs": dropoffs.length > 0 ? dropoffs.join(",") : "NIL",
      "destination": destinationController.text,
      "destination_place_id": selectedPlaceId,
      "capacity": seats,
      "airconditioner": airConditioner ? "1" : "0",
      "amount": fare,
      "departure": timeController.text,
      "car": SelectedCarId,
    };

    print(data);
    //return;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.postRide(data, globals.token);

    print(result);

    if (result == "success") {
      Navigator.pop(context);
      Navigate.to(context, SearchScreen());
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Ride Posted Successfully",
              ));
      alarm.zonedScheduleNotification(
          globals.postedRide, timeController.text.toUpperCase());

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RequestsScreen()),
          (Route<dynamic> route) => false);
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  showerror(BuildContext context, String error) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => ValidationErrorModal(
              error_message: error,
            ));
  }

  showBalanceError(BuildContext context, String error, double percentage) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => WalletBalanceError(
              error_message: error,
              percentage: percentage,
            ));
  }
} //end of class
