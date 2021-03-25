import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/size_config.dart';
import 'package:wemoove/views/RideHistoryDetail/RideHistoryDetailScreen.dart';

class DriverHistoryBody extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<DriverHistoryBody> {
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Stack(
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
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.arrow_left,
                          color: kPrimaryColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                  /*Image.asset(
                    "assets/images/appbarlogo.png",
                    height: getProportionateScreenHeight(30),
                    //width: getProportionateScreenWidth(235),
                  ),*/
                  /*  InkWell(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(LineAwesomeIcons.list, color: kPrimaryColor),
                    ),

                  )*/
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
            top: getProportionateScreenHeight(120),
            left: 10,
            right: 10,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    RideTile(),
                    RideTile(),
                    RideTile(),
                    RideTile(),
                    RideTile(),
                    RideTile()
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class RideTile extends StatelessWidget {
  const RideTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Color(0xffb0cce1).withOpacity(0.8),
                ),
              ],
              color: kprimarywhite),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LineAwesomeIcons.map_marker,
                          size: 35,
                          color: kPrimaryColor,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dutse",
                              style: TextStyle(
                                  color: kPrimaryAlternateColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Farmer's Market",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(LineAwesomeIcons.angle_right)
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: kTextColor.withOpacity(0.2),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "N1000",
                              style: TextStyle(
                                  color: kPrimaryAlternateColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.users,
                                      size: 35,
                                      color: kTextColor,
                                    ),
                                    Text(
                                      "3",
                                      style: TextStyle(
                                          color: kPrimaryAlternateColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "passengers",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "25-Jun-2020",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigate.to(context, RideHistoryDetailScreen());
      },
    );
  }
}
