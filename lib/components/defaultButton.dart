import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {Key key,
      this.text,
      this.press,
      this.color = kPrimaryColor,
      this.textColor = Colors.white,
      this.outline = false})
      : super(key: key);
  final String text;
  final Function press;
  final Color color;
  final Color textColor;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(50),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: outline
                ? new BorderSide(color: kPrimaryAlternateColor)
                : BorderSide.none),
        color: outline ? Colors.transparent : color,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            color: textColor,
          ),
        ),
      ),
    );
  }
}
