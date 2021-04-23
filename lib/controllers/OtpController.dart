import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/driver/CompleteProfileScreen.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class OtpController extends BaseViewModel {
  TextEditingController first_value = TextEditingController();
  TextEditingController second_value = TextEditingController();
  TextEditingController third_value = TextEditingController();
  TextEditingController fourth_value = TextEditingController();

  setOtpValue(
    BuildContext context,
    String value,
  ) {
    List otp_array = value.split("");
    if (otp_array.length > 0) {
      first_value = TextEditingController(text: otp_array[0]);
      second_value = TextEditingController(text: otp_array[1]);
      third_value = TextEditingController(text: otp_array[2]);
      fourth_value = TextEditingController(text: otp_array[3]);
    }
    notifyListeners();

    //submit(context);
    if (globals.otp == value) {
      submit(context);
    }
  }

  resendOtpValue() {
    UserServices.sendOTP({"phone": globals.user.phoneNumber}, globals.token);
  }

  void submit(BuildContext context) async {
    var data = {
      "verify": "true",
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    dynamic response =
        await UserServices.updateOTPVerified(data, globals.token);

    if (response == "success") {
      Navigator.pop(context);

      /*showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Successfully",
              ));*/

      if (globals.user.userType == 1) {
        Navigate.to(context, CompleteProfileScreen());
      } else {
        Navigate.to(context, SearchScreen());
      }
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
} //end of class
