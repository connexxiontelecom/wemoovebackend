import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/BookingController.dart';

import 'CustomButton.dart';

class SelectPickupModal extends StatefulWidget {
  final BookingController controller;
  const SelectPickupModal({Key key, this.controller}) : super(key: key);

  @override
  _SelectPickupModalState createState() => _SelectPickupModalState();
}

class _SelectPickupModalState extends State<SelectPickupModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Pickup Location",
              style: TextStyle(fontSize: 18),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.controller.ride.pickups.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio(
                                toggleable: true,
                                value: index,
                                groupValue: widget.controller.isPickupSelected,
                                onChanged: (value) {
                                  widget.controller.setSelectedPickup(value);
                                  setState(() {});
                                }),
                          ),
                          Expanded(
                            child: Text(
                              widget.controller.ride.pickups[index].name +
                                  index.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        print(index);
                        widget.controller.setSelectedPickup(index);
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
    ));
  }
}
