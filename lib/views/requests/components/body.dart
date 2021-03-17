import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/size_config.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  const Body({Key key, this.scaffoldkey}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool up = false;
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
                        "Good Afternoon,",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("Jason",
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
                      backgroundImage: AssetImage(
                          "assets/images/portrait.jpg") //NetworkImage(globals.user.avatar)
                      ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: getProportionateScreenHeight(300),
          left: 15,
          right: 15,
          child: Row(
            children: [
              Icon(LineAwesomeIcons.user_friends),
              SizedBox(
                width: 20,
              ),
              Text(
                "Passengers",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                " (0 requests)",
                style: TextStyle(
                    fontSize: 15,
                    color: kPrimaryAlternateColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Positioned.fill(
          top: getProportionateScreenHeight(350),
          left: 15,
          right: 15,
          child: Container(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/error.png",
                            height: 300,
                          ),
                          Text(
                            "You currently do not have any"
                            "\n passengers' request",
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    PassengerRequest(),
                    PassengerRequest(),
                    PassengerRequest(),
                    PassengerRequest(),
                    PassengerRequest(),

                    /* Padding(
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
                                  "Share Ride",
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
                      )*/
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(10.0),
            duration: Duration(milliseconds: 375), // Animation speed
            transform: Transform.translate(
              offset: Offset(
                  0, up == true ? -220 : 0), // Change -100 for the y offset
            ).transform,
            child: Container(
              height: 50.0,
              child: Row(
                children: [
                  FloatingActionButton(
                    backgroundColor: kPrimaryAlternateColor,
                    child: Icon(
                      LineAwesomeIcons.share,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        up = !up;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(10.0),
            duration: Duration(milliseconds: 375), // Animation speed
            transform: Transform.translate(
              offset: Offset(
                  0, up == true ? -150 : 0), // Change -100 for the y offset
            ).transform,
            child: Container(
              height: 50.0,
              child: FloatingActionButton(
                backgroundColor: kPrimaryAlternateColor,
                child: Icon(
                  LineAwesomeIcons.times,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    up = !up;
                  });
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(10.0),
            duration: Duration(milliseconds: 375), // Animation speed
            transform: Transform.translate(
              offset: Offset(
                  0, up == true ? -80 : 0), // Change -100 for the y offset
            ).transform,
            child: Container(
              height: 50.0,
              child: FloatingActionButton(
                backgroundColor: kPrimaryAlternateColor,
                child: Icon(
                  LineAwesomeIcons.play,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    up = !up;
                  });
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(10.0),
            duration: Duration(milliseconds: 375), // Animation speed
            transform: Transform.translate(
              offset: Offset(0, 0), // Change -100 for the y offset
            ).transform,
            child: Container(
              height: 50.0,
              child: FloatingActionButton(
                backgroundColor: kPrimaryAlternateColor,
                child: Icon(
                  LineAwesomeIcons.horizontal_ellipsis,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    up = !up;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
    //);
  }
}

class PassengerRequest extends StatelessWidget {
  const PassengerRequest({
    Key key,
    this.image,
    this.fullname,
    this.pickup,
  }) : super(key: key);

  final String image;
  final String fullname;
  final String pickup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 30,
                backgroundImage: AssetImage("assets/images/portrait.jpg"),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "2 Seats",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kPrimaryAlternateColor),
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
                      Text(
                        "Farmers Market",
                        style: TextStyle(
                            fontSize: 18, color: kPrimaryAlternateColor),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Icon(
            LineAwesomeIcons.phone,
            size: 30,
            color: kPrimaryColor,
          )
        ],
      ),
    );
  }
}
