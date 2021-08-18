import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/constants.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Function ontap;
  final Color color;

  const CustomButton(
      {Key key,
      this.child,
      this.height = 50,
      this.width = double.infinity,
      this.ontap,
      this.color = kPrimaryAlternateColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(5)),
          child: child,
        ),
      ),
      onTap: () {
        ontap();
      },
    );
  }
}
