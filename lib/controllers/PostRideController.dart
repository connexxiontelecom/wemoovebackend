import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/AddAmountModal.dart';
import 'package:wemoove/components/AddDestinationModal.dart';
import 'package:wemoove/components/AddPickupModal.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class PostRideController extends BaseViewModel {
  TextEditingController pickupController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();

  List<String> pickups = [];
  String destination = "";
  List<String> knockoffs = [];
  int seats = 3;
  bool airConditioner = false;
  String fare = "";

  String timerror = "at least 1 hour before departure";

  String _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

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

  showAddPickupModal(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AddPickupModal(
              controller: this,
            ));
  }

  showAddAmountModal(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AddAmountModal(
              controller: this,
            ));
  }

  showAddDestinationModal(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => DestinationModal(
              controller: this,
            ));
  }

  addtoPickup(value) {
    if (pickups.length < 2) {
      pickups.add(value);
      notifyListeners();
    }
  }

  removefromPickup(value) {
    if (pickups.length >= 1) {
      pickups.removeAt(value);
      notifyListeners();
    }
  }

  updateKnockOffs(List<String> values) {
    knockoffs = values;
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

  PublishRide(BuildContext context) async {
    var data = {
      "pickup1": pickups[0],
      "pickup2": pickups.length > 1 ? pickups[1] : null,
      "knockoffs": knockoffs.join(","),
      "destination": destinationController.text,
      "capacity": seats,
      "airconditioner": airConditioner ? "1" : "0",
      "amount": fare,
      "departure": destinationController.text
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result =
        ""; //await UserServices.registerVehicle(formData, globals.token);

    print(result);

    if (result == "success") {
      Navigator.pop(context);
      Navigate.to(context, SearchScreen());
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Successfully",
              ));
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
}
