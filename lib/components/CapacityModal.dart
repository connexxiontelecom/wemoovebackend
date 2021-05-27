import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';

import 'CustomButton.dart';

class CapacityModal extends StatefulWidget {
  dynamic controller;

  CapacityModal({Key key, this.controller}) : super(key: key);

  @override
  _CapacityModalState createState() => _CapacityModalState();
}

class _CapacityModalState extends State<CapacityModal> {
  int capacity = 1;

  increment() {
    setState(() {
      capacity++;
    });
  }

  decrement() {
    if (capacity > 1) {
      setState(() {
        capacity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text("The Passenger Capacity of your vehicle"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: counterButton(
                    child: Icon(
                      LineAwesomeIcons.minus,
                      color: kPrimaryAlternateColor,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    decrement();
                  },
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kprimarywhiteshade,
                  ),
                  child: Center(
                    child: Text(
                      "${capacity}",
                      style: TextStyle(
                          fontSize: 25,
                          //fontWeight: FontWeight.bold,
                          color: kPrimaryAlternateColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                InkWell(
                  child: counterButton(
                    child: Icon(
                      LineAwesomeIcons.plus,
                      color: kPrimaryAlternateColor,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    increment();
                  },
                )
              ],
            ),
            SizedBox(
              height: 50,
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
                widget.controller.setCapacity(capacity);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    ));
  }
}

class counterButton extends StatelessWidget {
  const counterButton({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryColor,
      ),
      child: child,
    );
  }
}
