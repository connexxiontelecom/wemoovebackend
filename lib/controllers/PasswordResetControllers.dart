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
import 'package:wemoove/views/signin/SignInScreen.dart';

class PasswordResetController extends BaseViewModel {
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showerror(context, "The Required Fields cannot be empty");
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      showerror(context, "Passwords Do not Match!");
      return;
    } else {
      reset(context);
    }
  }

  void reset(BuildContext context) async {
    var data = {
      "password": passwordController.text,
      "phone": globals.currentPhoneNumber
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    dynamic response = await UserServices.resetPassword(data);
    if (response == "success") {
      Navigator.pop(context);
      Navigate.to(context, SignInScreen());
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
