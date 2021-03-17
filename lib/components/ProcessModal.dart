import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';

class ProcessModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 150,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Processing",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
            SizedBox(
              height: 10,
            ),
            /*  CustomButton(
              child: Center(
                  child: Text(
                "Ok",
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              )),
              ontap: () {},
            )*/
          ],
        ),
      ),
    ));
  }
}
