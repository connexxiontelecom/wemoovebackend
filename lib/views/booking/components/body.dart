import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
                  CircleAvatar(
                      radius: 25,
                      //child: Image.asset("assets/images/sample.jpg")
                      backgroundImage: AssetImage(
                          "assets/images/portrait.jpg") //NetworkImage(globals.user.avatar)
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kPrimaryAlternateColor,
                        ),
                        child: Icon(
                          LineAwesomeIcons.arrow_left,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                            height: 50,
                            //width: SizeConfig.screenWidth * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryAlternateColor,
                            ),
                            child: Center(
                              child: Text(
                                "Save My Space",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            )),
                      ),
                    ],
                  )
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
          Text(
            "Trip",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: kPrimaryAlternateColor),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Departure Time",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: kPrimaryAlternateColor),
              ),
              Container(
                height: 50,
                width: 110,
                decoration: BoxDecoration(
                  color: kPrimaryAlternateColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "4:30 pm",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
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
          Text(
            "Rider",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: kPrimaryAlternateColor),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: AssetImage("assets/images/driver.jpg"),
                      fit: BoxFit.cover),
                ),
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
                          Icon(
                            LineAwesomeIcons.users,
                            size: 30,
                          ),
                          Text(
                            "Passengers",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      Text(
                        "23,123,342",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kTextColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "ABJ345CV",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Brand:",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Color:",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Model:",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Toyota Corolla",
                            style: TextStyle(
                                color: kPrimaryAlternateColor, fontSize: 18),
                          ),
                          Text(
                            "Silver",
                            style: TextStyle(
                                color: kPrimaryAlternateColor, fontSize: 18),
                          ),
                          Text(
                            "2010",
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
          Text(
            "Seat",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: kPrimaryAlternateColor),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "N",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "300",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  ),
                  Text(
                    "/seat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  counterButton(
                    child: Icon(
                      LineAwesomeIcons.minus,
                      color: kPrimaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
                        "1",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryAlternateColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  counterButton(
                    child: Icon(
                      LineAwesomeIcons.plus,
                      color: kPrimaryColor,
                      size: 20,
                    ),
                  )
                ],
              )
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
                    "Capacity",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "2 left /4",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  )
                ],
              )
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
                                        "Drop-off Location",
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
                                        "Pick-Up Location",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 50,
                                        width: SizeConfig.screenWidth * 0.65,
                                        decoration: BoxDecoration(
                                            color: kprimarywhiteshade,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color:
                                                  kTextColor.withOpacity(0.3),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Select Pick-Up Location"),
                                              Icon(LineAwesomeIcons.angle_down)
                                            ],
                                          ),
                                        ),
                                      ),
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
