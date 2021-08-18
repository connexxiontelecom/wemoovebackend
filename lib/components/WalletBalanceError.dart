import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';

import 'CustomButton.dart';

class WalletBalanceError extends StatelessWidget {
  final String error_message;
  final double percentage;
  const WalletBalanceError({Key key, this.error_message = "", this.percentage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Sorry!",
              style: TextStyle(fontSize: 30, color: kTextColor),
            ),
            Text(
              "Charge ${percentage}",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Text(
              error_message,
              style: TextStyle(fontSize: 18, color: kPrimaryAlternateColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Please fund your wallet and try again",
              style: TextStyle(fontSize: 18, color: kTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              child: Center(
                  child: Text(
                "Ok",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              )),
              ontap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    ));
  }
}
