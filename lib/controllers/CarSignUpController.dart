import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/CapacityModal.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class CarSignUpController extends BaseViewModel {
  TextEditingController brandController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();
  TextEditingController modelYearController = new TextEditingController();
  TextEditingController colourController = new TextEditingController();
  TextEditingController capacityController =
      new TextEditingController(text: "1");
  TextEditingController plateNumberController = new TextEditingController();
  TextEditingController licenseController = new TextEditingController();

  File file;

  bool showError = false;

  SelectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      file = File(result.files.single.path);
      licenseController =
          new TextEditingController(text: file.path.split('/').last);
      notifyListeners();
      print("file Selected");
    } else {
      print("file Selection cancelled");
    }
  }

  showCapacityModal(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CapacityModal(
              controller: this,
            ));
  }

  setCapacity(int capacity) {
    capacityController = new TextEditingController(text: capacity.toString());
    notifyListeners();
  }

  showLicenseError() {
    if (file == null) {
      showError = true;
      notifyListeners();
    } else {
      showError = false;
      notifyListeners();
    }
  }

  RegisterVehicle(BuildContext context) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      'brand': brandController.text,
      'model': modelController.text,
      'model_year': modelYearController.text,
      'colour': colourController.text,
      'capacity': capacityController.text,
      'plate_number': plateNumberController.text,
      'license': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.registerVehicle(formData, globals.token);

    print(result);

    if (result == "success") {
      Navigator.pop(context);
      Navigate.to(context, SearchScreen());
      /*showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Successfully",
              ));*/
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
}
