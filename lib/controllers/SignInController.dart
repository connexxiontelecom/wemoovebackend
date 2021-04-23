import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/DriverDetail.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/ReservationDetailScreen/ReservationDetailScreen.dart';
import 'package:wemoove/views/driver/CompleteProfileScreen.dart';
import 'package:wemoove/views/otp/otp_screen.dart';
import 'package:wemoove/views/requests/RequestsScreen.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class SignInController extends BaseViewModel {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  DriverDetails details;

  void signIn(BuildContext context) async {
    var data = {
      "email": usernameController.text,
      "password": passwordController.text,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    dynamic response = await UserServices.loginUser(data);

    if (response == "success") {
      Navigator.pop(context);
      // Navigate.to(context, SearchScreen());
      //Navigate.to(context, RequestsScreen());
      if (globals.user.verified != 1) {
        Navigate.to(context, OtpScreen());
      } else if (globals.user.userType == 1 && globals.user.hasvehicle != 1) {
        Navigate.to(context, CompleteProfileScreen());
      } else if (globals.user.userType == 1 &&
          globals.user.currentRideStatus == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RequestsScreen()),
            (Route<dynamic> route) => false);
      } else if ((globals.user.userType == 1 || globals.user.userType == 0) &&
          globals.user.currentRequestStatus == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ReservationDetailScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigate.to(context, SearchScreen());
      }

      /* showDialog(
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
    } else if (response is List<String>) {
      print("hello");
      Navigator.pop(context);
      //displayErrors(response);
    } else {
      Navigator.pop(context);
      String msg = response;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }
}
