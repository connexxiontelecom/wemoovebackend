import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/PostRideController.dart';
import 'package:wemoove/globals.dart' as globals;

import 'CustomButton.dart';

class SelectCarModal extends StatefulWidget {
  final PostRideController controller;
  const SelectCarModal({Key key, this.controller}) : super(key: key);

  @override
  _SelectCarModalState createState() => _SelectCarModalState();
}

class _SelectCarModalState extends State<SelectCarModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Choose a Car for this Trip",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryAlternateColor),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: globals.user.vehicles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Radio(
                                  toggleable: true,
                                  value: index,
                                  groupValue: widget.controller.isCarSelected,
                                  onChanged: (value) {
                                    widget.controller.setSelectedCar(value);
                                    setState(() {});
                                  }),
                            ),
                            Expanded(
                              child: Text(
                                globals.user.vehicles[index].brand +
                                    " " +
                                    globals.user.vehicles[index].model,
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          print(index);
                          widget.controller.setSelectedCar(index);
                          setState(() {});
                        },
                      ),
                    );
                  }),
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
      ),
    ));
  }
}
