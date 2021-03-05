import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/components/social_card.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/views/signup/components/signUpForm.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.1), // 4%

                Image.asset(
                  "assets/images/logox.png",
                  height: getProportionateScreenHeight(35),
                  //width: getProportionateScreenWidth(235),
                ),

                SizedBox(height: SizeConfig.screenHeight * 0.04),

                //Text("Sign Up", style: headingStyle),
                Text(
                  "Let\'s get you signed up!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* Text(
                  "Let\'s get you signed up!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      //color: kPrimaryAlternateColor,
                      fontWeight: FontWeight.w400),
                ),*/
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
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
                    /*SocalCard(
                      icon: Icon(LineAwesomeIcons
                          .twitter), //"assets/icons/twitter.svg",
                      press: () {},
                    ),*/
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Have an Account ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        ' Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
