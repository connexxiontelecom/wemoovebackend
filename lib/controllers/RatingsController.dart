import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/ValidationErrorModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class RatingsController extends BaseViewModel {
  int Rating = -1;
  TextEditingController commentController = TextEditingController();

  setSelectedRating(int index) {
    this.Rating = index;
  }

  submit(BuildContext context, Boarded boarded) async {
    // print(knockoffs.length);
    String error = "";
    if (Rating < 0) {
      error = "Please Rate";
      showerror(context, error);
      return;
    }

    var data = {
      "driver_id": boarded.driver.driverId,
      "passenger_id": boarded.passengerId,
      "ride_id": boarded.rideId,
      "rating": this.Rating,
      if (commentController.text.isNotEmpty) "comment": commentController.text
    };

    print(data);
    //return;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Saving Response",
            ));

    var result = await UserServices.saveRating(data, globals.token);

    print(result);

    if (result == "success") {
      Navigator.pop(context);
      // Navigate.to(context, SearchScreen());
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Response Saved",
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

  showerror(BuildContext context, String error) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ValidationErrorModal(
              error_message: error,
            ));
  }
}
