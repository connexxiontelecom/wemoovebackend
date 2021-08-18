import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/WalletController.dart';

class BeneficiaryModal extends StatelessWidget {
  final String message;
  final bool action;
  final WalletController controller;
  const BeneficiaryModal(
      {Key key, this.message = "", this.action, this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Beneficiary Confirmation",
              style: TextStyle(
                  fontSize: 18,
                  color: kPrimaryAlternateColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Name: ${message}",
              style: TextStyle(fontSize: 18, color: kPrimaryAlternateColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              action ? "Confirm" : "Please try again",
              style: TextStyle(fontSize: 18, color: kTextColor),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: kPrimaryAlternateColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                if (action)
                  GestureDetector(
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: kPrimaryAlternateColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Ok",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      )),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      controller.transferWalletCredit();
                    },
                  ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
