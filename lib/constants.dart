import 'dart:io';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/controllers/SearchScreenController.dart';
import 'package:wemoove/size_config.dart';

//const kPrimaryColor = Color(0xFFFFCC00);
const kPrimaryColor = Color(0xFFF9B233);
const kVariationColor = Color(0xFFFABC51);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryAlternateColor = Color(0xFF000000);
const kprimarywhite = Color(0xFFFFFFFF);
const kprimarywhiteshade = Color(0xFFF9FAFB);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final SmallHeadingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String kNameNullError = "Please Enter your full name";
const String kNameInvalidError =
    "Please your full-name must be first name and last name";
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter a Valid Email";
const String kPhonenumberNullError = "Please Enter your phone number";
const String kInvalidPhonenumberError = "Please Enter a Valid phone number";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
    contentPadding:
        EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
    border: outlineInputBorder(),
    focusedBorder: outlineInputBorder(),
    enabledBorder: outlineInputBorder(),
    counterText: "");

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(8)),
    borderSide: BorderSide(color: kTextColor),
  );
}

InputDecoration noborderInputDecoration(
    {SearchScreenController controller, BuildContext context}) {
  return InputDecoration(
      filled: true,
      fillColor: kprimarywhiteshade,
      hintStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      hintText: "Where to ?",
      contentPadding:
          EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
      border: outlineInputBorder(),
      focusedBorder: noOutlineInputBorder(),
      enabledBorder: noOutlineInputBorder(),
      suffixIcon: InkWell(
        child: Icon(
          LineAwesomeIcons.search,
          size: 30,
        ),
        onTap: () {
          //controller.Search(context);
        },
      ),
      counterText: "");
}

OutlineInputBorder noOutlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(8)),
    borderSide: BorderSide.none,
  );
}

InputDecoration getInputDecoration(
  String hint,
) {
  return InputDecoration(
      filled: true,
      fillColor: kprimarywhiteshade,
      hintStyle: TextStyle(fontSize: 18, color: Colors.black),
      hintText: hint.isNotEmpty ? hint : "Hint",
      contentPadding:
          EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
      border: outlineInputBorder(),
      focusedBorder: noOutlineInputBorder(),
      enabledBorder: noOutlineInputBorder(),
      //prefixIcon: Icon(LineAwesomeIcons.search),
      counterText: "");
}

Widget  backButton(BuildContext context){
  if(Platform.isAndroid)
   return  GestureDetector(child: Icon(LineAwesomeIcons.arrow_left, color: kPrimaryColor, size: 30), onTap: (){
    Navigator.pop(context);
  },);
  else
  return GestureDetector(child: Icon(LineAwesomeIcons.angle_left, color: kPrimaryColor, size: 30,), onTap: (){
    Navigator.pop(context);
  },);
}
