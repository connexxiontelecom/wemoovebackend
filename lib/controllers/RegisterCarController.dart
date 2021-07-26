import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/CapacityModal.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Vehicle.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class RegistarCarController extends BaseViewModel {
  TextEditingController brandController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();
  TextEditingController modelYearController = new TextEditingController();
  TextEditingController colourController = new TextEditingController();
  TextEditingController capacityController =
      new TextEditingController(text: "1");
  TextEditingController plateNumberController = new TextEditingController();

  File file;
  File profileImage;

  List<Vehicles> vehicles = globals.user != null ? globals.user.vehicles : 0;

  bool showError = false;
  List<dynamic> cameras;
  dynamic firstCamera;

  dynamic capturedPicture;

  CameraDescription camera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  RegistarCarController() {
    vehicles = globals.user != null ? globals.user.vehicles : 0;
    initCamera();
  }

  refresh() {
    vehicles = globals.user.vehicles;
    notifyListeners();
  }

  void initCamera() async {
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  void saveCaptureImage(dynamic image) {
    capturedPicture = image;
    notifyListeners();
  }

  showCapacityModal(BuildContext context) {
    showDialog(
        barrierDismissible: true,
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
    String fileName = capturedPicture.split('/').last;
    FormData formData = FormData.fromMap({
      'brand': brandController.text,
      'model': modelController.text,
      'model_year': modelYearController.text,
      'colour': colourController.text,
      'capacity': capacityController.text,
      'plate_number': plateNumberController.text,
      'carpicture':
          await MultipartFile.fromFile(capturedPicture, filename: fileName),
    });

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.registerCar(formData, globals.token);

    print(result);

    if (result == "success") {
      Navigator.pop(context);
      Navigator.pop(context);
      vehicles = globals.user.vehicles;
      notifyListeners();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "New Car Added Successfully",
              ));
      vehicles = globals.user.vehicles;
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
