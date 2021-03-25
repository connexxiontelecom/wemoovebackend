import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class DriverRideHistoryDetail extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<DriverRideHistoryDetail> {
  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: getProportionateScreenHeight(110),
          left: 15,
          right: 15,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      //height: getProportionateScreenHeight(120),
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
                      child: Details()),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
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
                              child: Icon(
                            LineAwesomeIcons.arrow_left,
                            size: 35,
                            color: kPrimaryColor,
                          ))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trip",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: kPrimaryAlternateColor),
              ),
              Text(
                "25-Jun-2020",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
          TimeLine(),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Flat Rate:",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "N1000",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryAlternateColor),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 10,
          ),
          PassengerTile(),
          PassengerTile(),
          PassengerTile(),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "AC:",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Yes",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Completed",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PassengerTile extends StatelessWidget {
  const PassengerTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35.0,
            backgroundImage: AssetImage("assets/images/driver.jpg"),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jason Brookes",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryAlternateColor,
                    fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2 Seat(s)",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color: kPrimaryAlternateColor,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nicon Junction",
                        style: TextStyle(
                            color: kPrimaryAlternateColor, fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
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
        color: kPrimaryAlternateColor,
      ),
      child: child,
    );
  }
}

class TimeLine extends StatefulWidget {
  const TimeLine({
    Key key,
  }) : super(key: key);
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          /* Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                          ),*/

                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: index == 1
                                ? Icon(
                                    LineAwesomeIcons.map_marker,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                : Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                          ),
                          index == 1
                              ? Container()
                              : Container(
                                  width: 1,
                                  height: 80,
                                  color: Colors.grey,
                                ),
                        ],
                      ),
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            /* CircleAvatar(
                              radius: 25.0,
                              backgroundImage:
                                  AssetImage("assets/images/portrait.jpg"),
                              backgroundColor: Colors.transparent,
                            ),*/
                            SizedBox(
                              width: 10,
                            ),
                            index == 1
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Destination",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Dutse",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pick-Up Locations",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Farmer's Market",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "NICON Junction",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  )
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
