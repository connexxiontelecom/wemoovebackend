import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/controllers/CallController.dart';
import 'package:wemoove/controllers/ScheduleAlarm.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/MyRequest.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class ReservationController extends BaseViewModel {
  MyRequest reservation;
  BuildContext context;
  List<int> unreads = [];
  CallController callController = globals.callController;
  bool redirect = true;

  ScheduleAlarm alarm = ScheduleAlarm();

  String getTravelTime(List<Pickups> pickups) {
    String traveltime = "N/A";
    for (var pickup in pickups) {
      if (pickup.name.toLowerCase() == reservation.pickup.toLowerCase()) {
        traveltime = pickup.traveltime;
      }
    }
    return traveltime;
  }

  String shareDetails() {
    if (reservation != null) {
      String share =
          " ${globals.user.fullName}\'s, Wemoove ride details:\n \n Destination: ${reservation.destination} \n Pickup: ${reservation.pickup} \n Driver: ${reservation.driver.fullName} \n Contact: ${reservation.driver.phoneNumber.substring(0, 7)}*** \n Car : ${reservation.car.model} ${reservation.car.brand} \n ${reservation.car.plateNumber} \n Estimated Time of Arrival: ${getTravelTime(reservation.pickups)}";
      return share;
    } else {
      return "";
    }
  }

  updateReservation(/*MyRequest booking*/) {
    print("Reservation Status " + reservation.status.toString());
    print("Reservation Request Status " + reservation.requestStatus.toString());

    if (this.reservation != null && this.reservation is MyRequest) {
      notifyListeners();

      if (reservation.requestStatus == 2 && reservation.status == 4) {
        callController.destroy();
      } else {
        if (callController.realtimeInstance == null) {
          callController.init();
        }
      }

      if (reservation.requestStatus == 2) {
        alarm.zonedScheduleNotification(
            reservation.rideId, reservation.departureTime.toUpperCase());
      }
      if ((reservation.status != 1 || reservation.requestStatus == 3) &&
          redirect) {
        cancel();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchScreen()));
      }
    }
  }

  void cancel() async {
    await globals.flutterLocalNotificationsPlugin.cancelAll();
  }

  void makeCall() {
    callController.makeCall(reservation.driver.driverId,
        reservation.driver.profileImage, reservation.driver.fullName);
  }

  void init(bool isRedirect) {
    if (isRedirect != null) {
      this.redirect = isRedirect;
    } else {
      this.redirect = true;
    }
  }

  void fetchUnreadMessages() async {
    List<int> ids = [];
    ids.add(this.reservation.driver.driverId);
    var data = {"ids": jsonEncode(ids.toList()), "ride_id": reservation.rideId};
    dynamic response = await UserServices.fetchunread(data, globals.token);

    unreads = response;
    print(response);
    notifyListeners();
  }

  void Refresh() async {
    var data = {
      "id": globals.user.id,
    };

    dynamic response = await UserServices.myrequest(data, globals.token);

    if (response is MyRequest) {
      this.reservation = response;
      updateReservation();
      notifyListeners();
    }
  }

  void Fetch(BuildContext context) async {
    this.context = context;
    var data = {
      "id": globals.user.id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Fetching Reservation...",
            ));

    dynamic response = await UserServices.myrequest(data, globals.token);

    if (response is MyRequest) {
      this.reservation = response;
      Navigator.pop(context);
      updateReservation();
      fetchUnreadMessages();
      /*showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Successfully",
              ));*/
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
      String msg = "Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  void Decline(BuildContext context) async {
    var data = {
      "id": reservation.pid, //the ID of the request
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Canceling...",
            ));

    dynamic response = await UserServices.declineRequest(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);
      Navigate.to(context, SearchScreen());
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Reservation Canceled!",
              ));
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
      String msg = "Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }
}
