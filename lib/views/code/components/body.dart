import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:read_otp_plugin/read_otp_plugin.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/CodeController.dart';
import 'package:wemoove/controllers/OtpController.dart';
import 'package:wemoove/globals.dart' as globals;

import '../../../constants.dart';
import '../../../size_config.dart';
import 'code_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _textContent = 'Waiting for messages...';
  OtpController otpController = OtpController();
  ReadOtpPlugin _smsReceiver;
  String channel = "wemoove";

  @override
  void initState() {
    super.initState();
    // _smsReceiver = ReadOtpPlugin(onSmsReceived);
    // _startListening(channel);
  }

  /*void onSmsReceived(String message) {
    setState(() {
      _textContent = message;
      otpController.setOtpValue(context, _textContent);
      print(message);
    });
  }

  void onTimeout() {
    setState(() {
      _textContent = "Timeout!!!";
      print(_textContent);
    });
  }*/

  void _startListening(String sender) {
    _smsReceiver.startListening(providerName: sender, otpLength: 4);
    setState(() {
      _textContent = "Waiting for messages...";
    });
  }

  @override
  void dispose() async {
    //_unRegisterListening();
    super.dispose();
  }

  void _unRegisterListening() async {
    await _smsReceiver.unRegisterListening();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CodeController>.reactive(
        viewModelBuilder: () => CodeController(),
        builder: (context, controller, child) => SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/logox.png",
                        height: getProportionateScreenHeight(35),
                        //width: getProportionateScreenWidth(235),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.05),
                      Text(
                        "Code Verification",
                        style: SmallHeadingStyle,
                      ),
                      Text(
                          "We sent your code to ${globals.currentPhoneNumber}"),
                      buildTimer(),
                      CodeForm(
                        controller: controller,
                      ),
                      /* Text(
                        _textContent,
                        style: TextStyle(fontSize: 20),
                      ),*/
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                      GestureDetector(
                        onTap: () {
                          //_smsReceiver.unRegisterListening();
                          controller.resendOtpValue();
                          //_startListening("N-Alert");
                          toast("confirmation code sent",
                              duration: Duration(seconds: 5));
                        },
                        child: Text(
                          "Resend OTP Code",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expire in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
