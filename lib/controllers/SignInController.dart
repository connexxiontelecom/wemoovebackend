import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/managers/push_notifications_manager.dart';
import 'package:wemoove/models/DriverDetail.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/utils/configs.dart' as utils;
import 'package:wemoove/utils/pref_util.dart';
import 'package:wemoove/views/ReservationDetailScreen/ReservationDetailScreen.dart';
import 'package:wemoove/views/driver/CompleteProfileScreen.dart';
import 'package:wemoove/views/otp/otp_screen.dart';
import 'package:wemoove/views/requests/RequestsScreen.dart';
import 'package:wemoove/views/search/SearchScreen.dart';

class SignInController extends BaseViewModel {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  DriverDetails details;
  final users = utils.users;
  bool _isLoginContinues = false;
  int _selectedUserId;

  void initCube(CubeUser user) {
    print(user.email);
    print(user.fullName);

    getUserByEmail(user.email).then((cubeUser) {
      CubeUser _cubeUser = CubeUser(
          email: user.email,
          id: cubeUser.id,
          password: user.password,
          fullName: user.fullName);
      _loginToCC(_cubeUser);
    }).catchError((error) {
      print("Hello User Cannot be found");
      cubeSignup(user.email, user.fullName);
    });
  }

  void cubeSignup(String email, String fullname) {
    CubeUser user = CubeUser(
      login: email,
      password: '!@wemoove',
      email: email,
      fullName: fullname,
    );
    signUp(user).then((cubeUser) {
      print(cubeUser.email + " " + cubeUser.fullName);
      CubeUser _user = CubeUser(
          email: user.email,
          id: cubeUser.id,
          password: user.password,
          fullName: user.fullName);
      _loginToCC(_user);
    }).catchError((error) {});
  }

  void signIn(BuildContext context) async {
    var data = {
      "username": usernameController.text,
      "password": passwordController.text,
    };
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    dynamic response = await UserServices.loginUser(data);
    if (response == "success") {
      print("user email:  " + globals.user.email);
      CubeUser user = CubeUser(
          email: globals.user.email,
          password: '!@wemoove',
          fullName: globals.user.fullName);

      initCube(user);

      Navigator.pop(context);
      // Navigate.to(context, SearchScreen());
      //Navigate.to(context, RequestsScreen());
      if (globals.user.verified != 1) {
        Navigate.to(context, OtpScreen());
      } else if (globals.user.userType == 1 && globals.user.hasvehicle != 1) {
        Navigate.to(context, CompleteProfileScreen());
      } else if (globals.user.userType == 1 &&
          globals.user.currentRideStatus == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RequestsScreen()),
            (Route<dynamic> route) => false);
      } else if ((globals.user.userType == 1 || globals.user.userType == 0) &&
          globals.user.currentRequestStatus == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ReservationDetailScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigate.to(context, SearchScreen());
      }
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

  _loginToCC(CubeUser user) {
    if (_isLoginContinues) {
      return;
    }
    if (CubeSessionManager.instance.isActiveSessionValid() &&
        CubeSessionManager.instance.activeSession.user != null) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        globals.currentUser = CubeSessionManager.instance.activeSession.user;
        PushNotificationsManager.instance.init();
        _isLoginContinues = false;
        _selectedUserId = 0;
      } else {
        _loginToCubeChat(user);
      }
    } else {
      createSession(user).then((cubeSession) {
        _loginToCubeChat(user);
      });
    }
  }

  void _loginToCubeChat(CubeUser user) {
    CubeChatConnection.instance.login(user).then((cubeUser) {
      SharedPrefs.instance.init().then((prefs) {
        prefs.saveNewUser(user);
      });
      print("Logged In CubeChat");
      globals.currentUser = cubeUser;
      PushNotificationsManager.instance.init();
      _isLoginContinues = false;
      _selectedUserId = 0;
    }).catchError(_processLoginError);
  }

  void _processLoginError(exception) {
    log("Login error $exception");
    _isLoginContinues = false;
    _selectedUserId = 0;
  }
}
