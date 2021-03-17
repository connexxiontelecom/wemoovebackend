import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class SignUpController extends BaseViewModel {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isDriver = false;

  void isDriverChecked() {
    isDriver = !isDriver;
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

  void signUp() async {
    resetErrors();
    var data = {
      "name": usernameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "password": passwordController.text
    };

    dynamic response = await UserServices.registerUser(data);

    if (response is List<String>) {
      print("hello");
      displayErrors(response);
    } else if (response.runtimeType == RequestError.RESPONSE_ERROR) {}
  }
}
