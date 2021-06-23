import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Bank.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class ManageAccountController extends BaseViewModel {
  TextEditingController bank = new TextEditingController();
  TextEditingController code = new TextEditingController();
  TextEditingController account = new TextEditingController();
  Bank selectedBank;

  String userBank = globals.user.bank;
  String userAccount = globals.user.account;
  BuildContext context;

  ManageAccountController() {
    userBank = globals.user.bank;
    userAccount = globals.user.account;
  }

  setSelectedBank(Bank bank) {
    selectedBank = bank;
    this.bank = TextEditingController(text: selectedBank.bank.toUpperCase());
    notifyListeners();
  }

  void SendCode() {
    UserServices.sendcode({"phone": globals.user.phoneNumber});
  }

  void ResendCode() {
    UserServices.resendCode({"phone": globals.user.phoneNumber});
  }

  void saveBank() async {
    if (code.text != globals.otp) {
      return;
    }

    var data = {
      'id': globals.user.id,
      'account': account.text,
      'bank': selectedBank.id,
    };

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.saveBank(data, globals.token);
    print(result);

    if (result == "success") {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Account Saved Successfully",
              ));
      userBank = globals.user.bank;
      userAccount = globals.user.account;
      notifyListeners();
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
