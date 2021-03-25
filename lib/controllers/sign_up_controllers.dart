import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/otp/otp_screen.dart';

class SignUpController extends BaseViewModel {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  int isDriver = -1;
  bool show_error = false;
  void isDriverChecked(value) {
    isDriver = value;
    showSelectionError();
    print(value);
    notifyListeners();
  }

  void showSelectionError() {
    if (isDriver == -1) {
      show_error = true;
    } else {
      show_error = false;
    }
    notifyListeners();
  }

  void updateBasicControllers(String name, String email) {
    usernameController = new TextEditingController(text: name);
    emailController = new TextEditingController(text: email);
    notifyListeners();
  }

  List<String> errors = [];

  void displayErrors(List<String> errors) {
    this.errors = List.from(errors);
    print(errors.length);
    notifyListeners();
  }

  void resetErrors() {
    this.errors = [];
    notifyListeners();
  }

  void signUp(BuildContext context) async {
    resetErrors();
    var data = {
      "name": usernameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "password": passwordController.text,
      "usertype": this.isDriver, // defaults to passenger
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    dynamic response = await UserServices.registerUser(data);

    if (response == "success") {
      Navigator.pop(context);
      Navigate.to(context, OtpScreen());
      UserServices.sendOTP({"phone": phoneController.text}, globals.token);
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
      displayErrors(response);
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
}
