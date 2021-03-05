import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
    this.resize = false,
  }) : super(key: key);
  final String text, image;
  final bool resize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        /* Text(
          "TOKOTO",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),*/
        Image.asset(
          "assets/images/logox.png",
          height: getProportionateScreenHeight(30),
          //width: getProportionateScreenWidth(235),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image,
          height: resize == true ? getProportionateScreenHeight(265) : null,
          //width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
