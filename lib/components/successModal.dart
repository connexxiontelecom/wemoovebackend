import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';

import 'CustomButton.dart';

class successProcessingModal extends StatelessWidget {
  final String sucessmsg;
  const successProcessingModal({Key key, this.sucessmsg = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineAwesomeIcons.check_circle,
                  color: kPrimaryColor,
                  size: 35,
                ),
                Text(
                  "Success",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryAlternateColor),
                ),
              ],
            ),
            Text(
              sucessmsg,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 10,
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
