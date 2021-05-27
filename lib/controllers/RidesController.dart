import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class RidesController extends BaseViewModel {
  List<Ride> Rides;

  refresh() {
    Rides = [];
    notifyListeners();
  }

  Fetch(BuildContext context) async {
    var data = {'id': globals.user.id};

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProcessModal(
              title: "Retrieving...",
            ));

    dynamic response = await UserServices.fetchRides(data, globals.token);

    if (response is List<Ride>) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg:
                    response.length > 0 ? "Rides Retrieved!" : "No Ride Found!",
                heading: response.length > 0 ? "" : "Sorry!",
                icon: response.length > 0
                    ? null
                    : Image.asset(
                        "assets/images/sad.png",
                        height: 50,
                      ),
              ));
      Rides = response;
      notifyListeners();
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
