import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class AboutScreen extends StatefulWidget {
  static String routeName = "/reservation_detail";
  final redirect;

  const AboutScreen({Key key, this.redirect = true})
      : super(key: key);

  @override
  _AboutScreenState createState() =>
      _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: getProportionateScreenHeight(100),
            decoration: BoxDecoration(
                color: kPrimaryAlternateColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  backButton(context),

                  Image.asset(
                    "assets/images/appbarlogo.png",
                    height: getProportionateScreenHeight(30),
                    //width: getProportionateScreenWidth(235),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: getProportionateScreenHeight(140),
          left: 15,
          right: 15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/app_icon.png',
                  height: 100,
                ),
                Text(
                  "Wemoove",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
                Text(
                  "Designed & Developed \n by Connexxion Telecom, a subsidiary \n of Connexxion Group",
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 30,),

                Text('2021 \u00a9 Connexxion Telecom', style: TextStyle(fontSize: 16, color:Colors.black),),

              ],
            ),
          ),
        )
      ],
    ));
    //);
  }
}
