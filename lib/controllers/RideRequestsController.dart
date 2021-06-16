import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/list_extension.dart';
import 'package:wemoove/models/request.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class RideRequestController extends BaseViewModel {
  List<Request> requests = [];
  List<int> unreads = [];

  int ride_current_status;

  updateRides(List<Request> requests) {
    this.requests = requests;
    notifyListeners();
    fetchUnreadMessages();
  }

  void currentStatus() async {
    dynamic response = await UserServices.fetchridestatus(globals.token);
    print(response);
    ride_current_status = response;
    notifyListeners();
  }

  void Accept(BuildContext context, id) async {
    print(id);
    var data = {
      "id": id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Accepting...",
            ));

    dynamic response = await UserServices.acceptRequest(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);
      //updateRides(response);
      var data = {
        "id": globals.user.id,
      };
      dynamic response = await UserServices.rideRequests(data, globals.token);
      updateRides(response);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Request Accepted",
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

//marks the index that represents a user's unread as Zero
  void updateUnread(int index) {
    unreads[index] = 0;
    notifyListeners();
  }

  bool containsIndex(int index) {
    return unreads.indices.contains(index);
  }

  bool aboveZero(int index) {
    return unreads.indices.contains(index) && unreads[index] > 0;
  }

  void fetchUnreadMessages() async {
    List<int> ids = [];
    if (requests != null && requests.length > 0) {
      for (Request request in requests) {
        ids.add(request.passengerId);
        print(request.passengerId);
      }
      var data = {
        "ids": jsonEncode(ids.toList()),
        "ride_id": globals.postedRide
      };
      print(data);
      dynamic response = await UserServices.fetchunread(data, globals.token);
      print(response);
      unreads = response;
      notifyListeners();
    }
    // print(response);
  }

  void Decline(BuildContext context, id) async {
    print(id);
    var data = {
      "id": id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Rejecting...",
            ));

    dynamic response = await UserServices.declineRequest(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);
      var data = {
        "id": globals.user.id,
      };
      dynamic response = await UserServices.rideRequests(data, globals.token);
      updateRides(response);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Request Declined!",
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

  void RefreshData() async {
    var data = {
      "id": globals.user.id,
    };
    dynamic response = await UserServices.rideRequests(data, globals.token);
    if (response is List<Request>) {
      updateRides(response);
    }
  }

  void Fetch(BuildContext context) async {
    var data = {
      "id": globals.user.id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Fetching Requests...",
            ));

    dynamic response = await UserServices.rideRequests(data, globals.token);

    if (response is List<Request>) {
      Navigator.pop(context);
      updateRides(response);
      currentStatus();
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

  void Cancel(BuildContext context) async {
    //print(id);
    var data = {
      "id": globals.user.id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Canceling...",
            ));

    dynamic response = await UserServices.cancelRide(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);
      var data = {
        "id": globals.user.id,
      };

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Ride Canceled!",
              ));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SearchScreen()),
          (Route<dynamic> route) => false);
      // Navigate.to(context, SearchScreen());
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

  void Finish(BuildContext context) async {
    //print(id);
    var data = {
      "id": globals.user.id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Please Wait",
            ));

    dynamic response = await UserServices.FinishRide(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);
      var data = {
        "id": globals.user.id,
      };

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Ride is Finished",
              ));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SearchScreen()),
          (Route<dynamic> route) => false);
      // Navigate.to(context, SearchScreen());
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

  void Start(BuildContext context) async {
    //print(id);
    var data = {
      "id": globals.user.id,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Starting...",
            ));

    dynamic response = await UserServices.startRide(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);
      var data = {
        "id": globals.user.id,
      };
      currentStatus();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Ride Started!",
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
