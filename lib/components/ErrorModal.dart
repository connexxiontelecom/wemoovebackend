import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';

import 'CustomButton.dart';

class errorProcessingModal extends StatelessWidget {
  final String error_message;
  const errorProcessingModal({Key key, this.error_message = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Oops!",
              style: TextStyle(fontSize: 30, color: kTextColor),
            ),
            Text(
              error_message,
              style: TextStyle(fontSize: 18, color: kPrimaryAlternateColor),
            ),
            Text(
              "Please try again",
              style: TextStyle(fontSize: 18, color: kTextColor),
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
