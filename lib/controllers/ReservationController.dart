import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
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

  bool redirect = true;

  ScheduleAlarm alarm = ScheduleAlarm();
  updateReservation(/*MyRequest booking*/) {
    print("Reservation Status " + reservation.status.toString());
    print("Reservation Request Status " + reservation.requestStatus.toString());

    if (this.reservation != null && this.reservation is MyRequest) {
      notifyListeners();
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
