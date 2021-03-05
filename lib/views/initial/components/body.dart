import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/constants.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.3),
                      Image.asset(
                        "assets/images/logox.png",
                        height: getProportionateScreenHeight(50),
                        //width: getProportionateScreenWidth(235),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.25),
                      DefaultButton(
                        text: "Sign Up",
                        press: () {},
                        color: kPrimaryAlternateColor,
                        textColor: kPrimaryColor,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DefaultButton(
                        text: "Sign In",
                        press: () {},
                        outline: true,
                        textColor: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
