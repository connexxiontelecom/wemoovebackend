import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/PostRideController.dart';

import 'CustomButton.dart';

class DestinationModal extends StatefulWidget {
  PostRideController controller;

  DestinationModal({Key key, this.controller}) : super(key: key);

  @override
  _DestinationModalState createState() => _DestinationModalState();
}

class _DestinationModalState extends State<DestinationModal> {
  String value_string = "";
  bool showerror = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Specify your destination"),
            SizedBox(
              height: 10,
            ),
            buildPickupLocationFormField(),
            SizedBox(
              height: 10,
            ),
            showerror
                ? Text(
                    "Destination is required",
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox.shrink(),
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
                if (value_string.isNotEmpty) {
                  widget.controller.updateDestination(value_string);
                  Navigator.pop(context);
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

  TextFormField buildPickupLocationFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      //controller: controller,
      onChanged: (value) {
        setState(() {
          value_string = value;
          if (value.isNotEmpty) {
            showerror = false;
          } else {
            showerror = true;
          }
        });
      },
      validator: RequiredValidator(errorText: "destination required"),
      decoration: InputDecoration(
          labelText: "Destination",
          hintText: "e.g 19 Kumasi Crescent, Wuse",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons.map_marker)),
    );
  }
}
