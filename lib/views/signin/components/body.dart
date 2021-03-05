import 'package:flutter/material.dart';
import 'package:wemoove/components/no_account_text.dart';
import 'package:wemoove/components/social_card.dart';
import 'package:wemoove/views/signin/components/signin_form.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
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
                  "Let\'s get you moving again",
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
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    /* SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),*/
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
