import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/controllers/AccountController.dart';

import '../../constants.dart';
import '../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountController>.reactive(
      viewModelBuilder: () => AccountController(),
      builder: (context, controller, child) => SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Image.asset(
                    "assets/images/logox.png",
                    height: getProportionateScreenHeight(30),
                    //width: getProportionateScreenWidth(235),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "Password Reset",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Your Account's Phone Number ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildPhoneFormField(controller: controller.phoneController),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  DefaultButton(
                    color: kPrimaryAlternateColor,
                    text: "Continue",
                    textColor: kPrimaryColor,
                    press: () {
                      controller.Validate(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneFormField({
    TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: "Phone Number",
          hintText: "Phone Number",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .user) //CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
    );
  }
}
