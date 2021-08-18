import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/PostRideController.dart';

import 'CustomButton.dart';

class AddPickupModal extends StatefulWidget {
  PostRideController controller;

  AddPickupModal({Key key, this.controller}) : super(key: key);

  @override
  _AddPickupModalState createState() => _AddPickupModalState();
}

class _AddPickupModalState extends State<AddPickupModal> {
  String value_string = "";
  bool showerror = false;
  double height = 250;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<PostRideController>(context);
    return Dialog(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
          height: applicationBloc.searchResults != null &&
                  applicationBloc.searchResults.isNotEmpty
              ? 580
              : height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text("Specify a Pickup point"),
              SizedBox(
                height: 10,
              ),
              /*buildPickupLocationFormField(),*/

              TextFormField(
                keyboardType: TextInputType.text,
                controller: applicationBloc.pickupController,
                onTap: () => applicationBloc.clearSelectedLocation(),
                onChanged: (value) {
                  applicationBloc.searchPlaces(value);
                  setState(() {
                    value_string = value;
                    if (value.isNotEmpty) {
                      showerror = false;
                    } else {
                      showerror = true;
                    }
                  });
                },
                validator:
                    RequiredValidator(errorText: "pickup location required"),
                decoration: InputDecoration(
                    labelText: "Pickup Location",
                    hintText: "e.g 19 Kumasi Crescent, Wuse",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(LineAwesomeIcons.user)),
              ),
              SizedBox(
                height: 10,
              ),
              showerror
                  ? Text(
                      "pickup location  is required",
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox.shrink(),
              if (applicationBloc.searchResults != null &&
                  applicationBloc.searchResults.isNotEmpty)
                Expanded(
                  child: Container(
                    height: 300.0,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          //physics: NeverScrollableScrollPhysics(),
                          itemCount: applicationBloc.searchResults.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(LineAwesomeIcons.map_marker),
                                    Expanded(
                                      child: Text(
                                        applicationBloc
                                            .searchResults[index].description,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  applicationBloc.setSelectedLocation(
                                      applicationBloc
                                          .searchResults[index].placeId);
                                  //   print(index.toString());
                                  /* print(applicationBloc
                                      .searchResults[index].description);
*/
                                  applicationBloc.setSelectedPickup(
                                      applicationBloc
                                          .searchResults[index].description);
                                  setState(() {});
                                  //widget.controller.Search(context);
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                child: Center(
                    child: Text(
                  "Add",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                )),
                ontap: () {
                  if (applicationBloc.pickupController.text.isNotEmpty) {
                    applicationBloc
                        .addtoPickup(applicationBloc.pickupController.text);
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
      ),
    ));
  }

  /*TextFormField buildPickupLocationFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: widget.controller.pickupController,
      onTap: () => widget.controller.clearSelectedLocation(),
      onChanged: (value) {
        widget.controller.searchPlaces(value);
        setState(() {
          value_string = value;
          if (value.isNotEmpty) {
            showerror = false;
          } else {
            showerror = true;
          }
        });
      },
      validator: RequiredValidator(errorText: "pickup location required"),
      decoration: InputDecoration(
          labelText: "Pickup Location",
          hintText: "e.g 19 Kumasi Crescent, Wuse",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons.user)),
    );
  }*/
}
