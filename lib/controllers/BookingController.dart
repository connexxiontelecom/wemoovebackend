import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/NegotiationModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/SelectPickupModal.dart';
import 'package:wemoove/components/ValidationErrorModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/ReservationDetailScreen/ReservationDetailScreen.dart';

class BookingController extends BaseViewModel {
  Ride ride;
  String pickup;
  int isPickupSelected = -1;
  BookingController(this.ride);
  BuildContext context;
  int seats = 1;

  List<String> paymentModes = ["Cash", "Wallet"];

  int mode = -1;

  TextEditingController amountController = new TextEditingController();
  TextEditingController dropoffController = new TextEditingController();

  increment() {
    if (seats < this.ride.capacity) {
      seats++;
      notifyListeners();
    }
  }

  decrement() {
    if (seats > 1) {
      seats--;
      notifyListeners();
    }
  }

  modeSelected(int value) {
    mode = value;
    notifyListeners();
  }

  setBuildContext(BuildContext context) {
    this.context = context;
  }

  setSelectedPickup(value) {
    pickup = ride.pickups[value].name;
    isPickupSelected = value;
    notifyListeners();
  }

  showPickupsModal(BuildContext context, BookingController controller) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => SelectPickupModal(
              controller: controller,
            ));
  }

  ShowNegotiationModal(BuildContext context, BookingController controller) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => NegotiationModal(
              controller: controller,
            ));
  }

  bookRide() async {
    String error = "";
    if (this.pickup == null || this.pickup.isEmpty) {
      error = "Select a pickup location";
      showerror(context, error);
      return;
    }

    if (this.mode == null || mode == -1) {
      error = "Please indicate Mode of Payment";
      showerror(context, error);
      return;
    }

    var data = {
      'ride_id': this.ride.id,
      'passenger_id': globals.user.id,
      'status': 1, //pending acceptance
      'seats': seats,
      'pickup': this.pickup,
      'payment_mode': this.mode + 1,
      if (amountController.text.isNotEmpty) 'amount': amountController.text,
      if (dropoffController.text.isNotEmpty) 'dropoff': dropoffController.text
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Sending Request",
            ));

    dynamic response = await UserServices.bookRide(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Booking request sent successfully!",
              ));

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ReservationDetailScreen()),
          (Route<dynamic> route) => false);
    } else if (response == RequestError.CONNECTION_ERROR) {
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
        barrierDismissible: false,
        context: context,
        builder: (_) => ValidationErrorModal(
              error_message: error,
            ));
  }
}
