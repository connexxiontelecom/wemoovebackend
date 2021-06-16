import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/PasswordResetControllers.dart';
import 'package:wemoove/views/PasswordReset/password_reset_form.dart';

import '../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordResetController>.reactive(
      viewModelBuilder: () => PasswordResetController(),
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
                  /* Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.justify,
                ),*/
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  PasswordResetForm(
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
