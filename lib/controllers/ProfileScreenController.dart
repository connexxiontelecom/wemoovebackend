import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class ProfileScreenController extends BaseViewModel {
  File file;

  TextEditingController homeController =
      new TextEditingController(text: globals.user.address);

  TextEditingController workController =
      new TextEditingController(text: globals.user.workAddress);

  SelectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      file = File(result.files.single.path);
      notifyListeners();
      print("file Selected");
    } else {
      toast("Selection Cancelled");
    }
  }

  SaveUpdates(BuildContext context) async {
    String filename;
    if (file != null) {
      filename = file.path.split('/').last;
    }
    FormData formData = FormData.fromMap({
      'work': workController.text,
      'home': homeController.text,
      if (file != null && filename.isNotEmpty)
        'profile_pic':
            await MultipartFile.fromFile(file.path, filename: filename),
    });

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal(
              title: "Updating",
            ));

    var response = await UserServices.updateProfile(formData, globals.token);

    print(response);

    if (response == "success") {
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Updated Successfully",
              ));
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
}
