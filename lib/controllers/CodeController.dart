import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/PasswordReset/PasswordResetScreen.dart';

class CodeController extends BaseViewModel {
  TextEditingController first_value = TextEditingController();
  TextEditingController second_value = TextEditingController();
  TextEditingController third_value = TextEditingController();
  TextEditingController fourth_value = TextEditingController();

  setOtpValue(
    BuildContext context,
    String value,
  ) {
    print(value);
    value = value.trim();
    List arr = value.split(".");
    List otp_array = arr[0].split("");
    print(otp_array);
    print("printing global otp");
    print(globals.otp);
    value = otp_array.join('');
    print("the value is " + value);
    submit(context, value);
  }

  resendOtpValue() {
    UserServices.resendCode({"phone": globals.currentPhoneNumber});
  }

  void submit(BuildContext context, dynamic value) async {
    print("printing global otp");
    print(globals.otp);
    if (globals.otp != value) {
      toast("Invalid Code", duration: Duration(seconds: 8));
      return;
    } else {
      Navigator.pop(context);
      Navigate.to(context, PasswordReset());
    }
  }
} //end of class
