import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/VASController.dart';
import 'package:wemoove/models/ElectricityUser.dart';

import 'CustomButton.dart';

class ElectricityUserVerificationModal extends StatelessWidget {
  final ElectricityUser user;
  final String phone;
  final String amount;
  final VASController controller;
  final dynamic service;
  const ElectricityUserVerificationModal(
      {Key key,
      this.user,
      this.phone,
      this.amount,
      this.controller,
      this.service})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 550,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "CONFIRM DETAILS",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Text(
              "Name",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              user != null ? "${user.name}" : "",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Address",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Flexible(
              child: Text(
                user != null ? "${user.address}" : "",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              "Outstanding",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              user != null && user.outstandingBalance != null
                  ? "${user.outstandingBalance}"
                  : "",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Account",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              user != null ? "${user.accountNumber}" : "",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Phone",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              user != null ? "${phone}" : "",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Amount",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              user != null ? "${amount}" : "",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 30,
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
                //Navigator.pop(context);
                var data = {
                  "metre": user.accountNumber,
                  "amount": amount,
                  "phone": phone,
                  "service": service
                };
                controller.PurchaseElectricity(context, data);
              },
            )
          ],
        ),
      ),
    ));
  }
}
