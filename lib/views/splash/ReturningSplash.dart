import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';

class ReturningSplashScreen extends StatefulWidget {
  @override
  _ReturningSplashScreenState createState() => _ReturningSplashScreenState();
}

class _ReturningSplashScreenState extends State<ReturningSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png",
                height: 35 //ScreenUtil().setHeight(50),
                ),
            Text(
              "let's move together...",
              style: TextStyle(
                  color: kPrimaryAlternateColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
