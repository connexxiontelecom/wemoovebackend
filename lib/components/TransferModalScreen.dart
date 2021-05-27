import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/WalletController.dart';
import 'package:wemoove/globals.dart' as globals;

import 'CustomButton.dart';

class TransferModalScreen extends StatefulWidget {
  WalletController controller;

  TransferModalScreen({Key key, this.controller}) : super(key: key);

  @override
  _TransferModalScreenState createState() => _TransferModalScreenState();
}

class _TransferModalScreenState extends State<TransferModalScreen> {
  String value_string = "";
  bool showerror = false;
  String errormsg = '';
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Transfer from wallet"),
            SizedBox(
              height: 30,
            ),
            buildAmountFormField(widget.controller.amount),
            SizedBox(
              height: 30,
            ),
            buildRecipientFormField(widget.controller.beneficiary),
            showerror
                ? Text(
                    errormsg,
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 30,
            ),
            CustomButton(
              child: Center(
                  child: Text(
                "Transfer",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              )),
              ontap: () {
                if (widget.controller.amount.text.isNotEmpty &&
                    widget.controller.beneficiary.text.isNotEmpty &&
                    showerror != true) {
                  widget.controller.confirmBeneficiary(widget.controller);
                  //Navigator.pop(context);
                } else {
                  setState(() {
                    showerror = true;
                  });
                }
              },
            )
          ],
        ),
      ),
    ));
  }

  TextFormField buildAmountFormField(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: (value) {
        setState(() {
          if (controller.text.isNotEmpty) {
            showerror = false;
          } else {
            showerror = true;
            errormsg = "Amount required";
          }
        });
      },
      validator: RequiredValidator(errorText: "amount required"),
      decoration: InputDecoration(
          labelText: "Amount",
          hintText: "e.g 0",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons.wallet)),
    );
  }

  TextFormField buildRecipientFormField(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: (value) {
        setState(() {
          //value_string = value;
          if (controller.text.isNotEmpty) {
            showerror = false;
          }
          if (controller.text.isNotEmpty &&
              controller.text == globals.user.phoneNumber.toString()) {
            showerror = true;
            errormsg = "Self transfer not allowed";
          }
          if (controller.text.isEmpty) {
            showerror = true;
            errormsg = "Beneficiary required";
          }
        });
      },
      validator: RequiredValidator(errorText: "Beneficiary required"),
      decoration: InputDecoration(
          labelText: "Account (Phone Number)",
          hintText: "e.g 080123456789",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons.wallet)),
    );
  }
}
