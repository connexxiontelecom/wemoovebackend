import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/ValidationErrorModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/DriverDetail.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/code/code_screen.dart';

class AccountController extends BaseViewModel {
  TextEditingController phoneController = new TextEditingController();

  DriverDetails details;

  showerror(BuildContext context, String error) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ValidationErrorModal(
              error_message: error,
            ));
  }

  Validate(BuildContext context) {
    if (phoneController.text.isEmpty) {
      showerror(context, "Provide Account's Phone-number");
      return;
    } else {
      reset(context);
    }
  }

  void reset(BuildContext context) async {
    var data = {
      "phone": phoneController.text,
      //"phone": globals.currentPhoneNumber
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    dynamic response = await UserServices.identifyAccount(data);
    if (response == "success") {
      globals.currentPhoneNumber = phoneController.text;
      Navigator.pop(context);
      UserServices.sendcode({"phone": phoneController.text});
      Navigate.to(context, CodeScreen());
    } else if (response == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else if (response == RequestError.RESPONSE_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "error processing request",
              ));
    } else {
      Navigator.pop(context);
      String msg = response;
      print(response);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }
}
