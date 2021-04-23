import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
  double height = 250;

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
              Text("Specify your destination"),
              SizedBox(
                height: 10,
              ),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: applicationBloc.destinationController,
                onTap: () => applicationBloc.clearSelectedLocation(),
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
                validator: RequiredValidator(errorText: "destination required"),
                decoration: InputDecoration(
                    labelText: "Destination",
                    hintText: "e.g 19 Kumasi Crescent, Wuse",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(LineAwesomeIcons.map_marker)),
              ),
              //buildPickupLocationFormField(),
              SizedBox(
                height: 10,
              ),
              showerror
                  ? Text(
                      "Destination is required",
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
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: Icon(LineAwesomeIcons.map_marker),
                                title: Text(
                                  applicationBloc
                                      .searchResults[index].description,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  applicationBloc.setSelectedLocation(
                                      applicationBloc
                                          .searchResults[index].placeId);
                                  applicationBloc.setSelectedDestination(
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
                  "Ok",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                )),
                ontap: () {
                  if (value_string.isNotEmpty) {
                    applicationBloc.updateDestination(
                        applicationBloc.destinationController.text);
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
      controller: applicationBloc.destinationController,
      onTap: () => applicationBloc.clearSelectedLocation(),
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
      validator: RequiredValidator(errorText: "destination required"),
      decoration: InputDecoration(
          labelText: "Destination",
          hintText: "e.g 19 Kumasi Crescent, Wuse",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons.map_marker)),
    );
  }*/
}
