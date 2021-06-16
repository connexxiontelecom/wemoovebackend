import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/BookingController.dart';

import 'CustomButton.dart';

class NegotiationModal extends StatefulWidget {
  BookingController controller;
  BuildContext context;
  NegotiationModal({Key key, this.context, this.controller}) : super(key: key);

  @override
  _NegotiationModalState createState() => _NegotiationModalState();
}

class _NegotiationModalState extends State<NegotiationModal> {
  String error_text = "";
  bool showerror = false;
  double height = 250;

  @override
  Widget build(BuildContext context) {
    //final applicationBloc = Provider.of<PostRideController>(context);
    return Dialog(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
          height: 430,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your negotiating price"),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                controller: widget.controller.amountController,
                //onTap: () => applicationBloc.clearSelectedLocation(),
                //onChanged: (value) {},
                validator: RequiredValidator(errorText: "Amount required"),
                decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "e.g 1000",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(LineAwesomeIcons.map_marker)),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Your Drop-off Location"),
              SizedBox(
                height: 10,
              ),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: widget.controller.dropoffController,
                //onTap: () => applicationBloc.clearSelectedLocation(),
                //onChanged: (value) {},
                maxLength: 35,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                /* buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,*/
                validator: RequiredValidator(errorText: "destination required"),
                decoration: InputDecoration(
                    labelText: "Destination",
                    hintText: "e.g Gwarimpa",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(LineAwesomeIcons.map_marker)),
              ),
              //buildPickupLocationFormField(),
              SizedBox(
                height: 10,
              ),
              showerror
                  ? Text(
                      "${error_text}",
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                child: Center(
                    child: Text(
                  "Reserve",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                )),
                ontap: () {
                  setState(() {
                    showerror = false;
                  });
                  if (widget.controller.amountController.text.isNotEmpty &&
                      widget.controller.dropoffController.text.isNotEmpty) {
                    Navigator.pop(context);
                    widget.controller.bookRide();
                  } else if (widget.controller.amountController.text.isEmpty) {
                    setState(() {
                      error_text = "Amount Required";
                      showerror = true;
                    });
                  } else if (widget.controller.dropoffController.text.isEmpty) {
                    setState(() {
                      error_text = "Drop-off Required";
                      showerror = true;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
