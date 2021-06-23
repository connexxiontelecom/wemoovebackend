import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class SupportController extends BaseViewModel {
  TextEditingController subjectController = new TextEditingController();
  TextEditingController detailsController = new TextEditingController();
  void submit(context) async {
    var data = {
      'user_id': globals.user.id,
      'subject': subjectController.text,
      'details': detailsController.text
    };

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.requestSupport(data, globals.token);
    print(result);

    if (result == "success") {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Sent Successfully",
              ));
      subjectController.clear();
      detailsController.clear();
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
