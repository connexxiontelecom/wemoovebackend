import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/SearchScreenController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/size_config.dart';
import 'package:wemoove/views/booking/BookingScreen.dart';
import 'package:wemoove/views/publish/PublishScreen.dart';

class DriverBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final SearchScreenController controller;
  const DriverBody({Key key, this.controller, this.scaffoldkey})
      : super(key: key);

  @override
  _DriverBodyState createState() => _DriverBodyState();
}

class _DriverBodyState extends State<DriverBody> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    //return SizedBox.expand(
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
                  Image.asset(
                    "assets/images/appbarlogo.png",
                    height: getProportionateScreenHeight(30),
                    //width: getProportionateScreenWidth(235),
                  ),
                  InkWell(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(LineAwesomeIcons.list, color: kPrimaryColor),
                    ),
                    onTap: () {
                      //_scaffoldKey.currentState.openDrawer();
                      widget.scaffoldkey.currentState.openDrawer();
                      // Scaffold.of(context).openDrawer();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: getProportionateScreenHeight(140),
          left: 15,
          right: 15,
          child: Container(
            height: getProportionateScreenHeight(120),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Color(0xffb0cce1).withOpacity(0.9),
                  ),
                ],
                color: kprimarywhite,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back!,",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                          globals.user != null
                              ? globals.user.fullName.split(" ")[0]
                              : "",
                          style:
                              SmallHeadingStyle //TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(LineAwesomeIcons.map_marker),
                          Text(
                            "Maitama,",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Abuja",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  CircleAvatar(
                      radius: 35,
                      //child: Image.asset("assets/images/sample.jpg")
                      backgroundImage: globals.user.profileImage.isEmpty
                          ? AssetImage("assets/images/portrait.jpg")
                          : NetworkImage(globals.user.profileImage)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: getProportionateScreenHeight(320),
          left: 15,
          right: 15,
          child: Container(
            height: getProportionateScreenHeight(140),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Color(0xffb0cce1).withOpacity(0.9),
                  ),
                ],
                color: kprimarywhite,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Summary",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: kTextColor.withOpacity(0.3),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SummaryWidget(
                        title: "Total Rides",
                        value: globals.details != null
                            ? "${globals.details.rides}"
                            : "",
                        icon: LineAwesomeIcons.car,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        height: 70,
                        width: 1,
                        color: kTextColor.withOpacity(0.3),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      SummaryWidget(
                        title: "Rating",
                        value: "4.9",
                        icon: LineAwesomeIcons.star,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        height: 70,
                        width: 1,
                        color: kTextColor.withOpacity(0.3),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      SummaryWidget(
                        title: "Passengers",
                        value: globals.details != null
                            ? "${globals.details.passengers}"
                            : "",
                        icon: LineAwesomeIcons.user_friends,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: getProportionateScreenHeight(700),
          left: 15,
          right: 15,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: InkWell(
              child: Container(
                  height: 60,
                  //width: SizeConfig.screenWidth * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryAlternateColor,
                  ),
                  child: Center(
                    child: Text(
                      "Post Ride",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  )),
              onTap: () {
                Navigate.to(context, PublishScreen());
              },
            ),
          ),
        ),
      ],
    );
    //);
  }
}

class SummaryWidget extends StatelessWidget {
  final String value;
  final String title;
  final IconData icon;
  const SummaryWidget({
    Key key,
    this.value,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
              size: 30,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}

class RIdeCard extends StatelessWidget {
  const RIdeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //height: 500,
            decoration: BoxDecoration(
                color: kprimarywhite,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Color(0xffb0cce1).withOpacity(0.9),
                  ),
                ],
                //color: kprimarywhite,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dutse (Sokale)",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Minnesota"),
                      Icon(
                        LineAwesomeIcons.angle_double_right,
                        size: 15,
                      ),
                      Text("Bangladesh"),
                    ],
                  ),
                  Text(
                    "N300",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: kPrimaryAlternateColor),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 15, top: 10),
                    child: Image.asset(
                      "assets/images/car.png",
                      height: getProportionateScreenHeight(50),
                      //width: getProportionateScreenWidth(235),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Toyota ",
                        style: TextStyle(
                            fontSize: 18, color: kPrimaryAlternateColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 5,
                        width: 5,
                        decoration: BoxDecoration(
                          color: kPrimaryAlternateColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Silver",
                        style: TextStyle(
                            fontSize: 18, color: kPrimaryAlternateColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "ABJ345CV",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryAlternateColor),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 25,
                          //child: Image.asset("assets/images/sample.jpg")
                          backgroundImage: globals.user.profileImage.isEmpty
                              ? AssetImage("assets/images/portrait.jpg")
                              : NetworkImage(globals.user.profileImage)),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jasmine",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryAlternateColor),
                          ),
                          Row(
                            children: [
                              Icon(
                                LineAwesomeIcons.star_1,
                                color: kPrimaryColor,
                              ),
                              Text(
                                "4.9",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: kPrimaryAlternateColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(LineAwesomeIcons.users),
                                  Text("Passengers")
                                ],
                              ),
                              Text(
                                "23,123,342",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryAlternateColor),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [Text("A/C:"), Text("Yes")],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Text("Capacity:"),
                          Text(
                            "2 left",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kPrimaryAlternateColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigate.to(context, BookingScreen());
      },
    );
  }
}
