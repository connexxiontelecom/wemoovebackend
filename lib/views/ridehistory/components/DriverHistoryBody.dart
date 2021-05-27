import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/RideHistoryController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/Driven.dart';
import 'package:wemoove/size_config.dart';
import 'package:wemoove/views/RideHistoryDetail/RideHistoryDetailScreen.dart';

class DriverHistoryBody extends StatefulWidget {
  final RideHistoryController controller;

  const DriverHistoryBody({Key key, this.controller}) : super(key: key);
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
                  ),
                  Text(
                    "Rides History",
                    style: TextStyle(fontSize: 20, color: kPrimaryColor),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: globals.user != null &&
                            globals.user.profileImage != null &&
                            globals.user.profileImage.isNotEmpty
                        ? NetworkImage(globals.user.profileImage)
                        : AssetImage("assets/images/portrait.png"),
                  ),
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
                  child: widget.controller.drivens.length > 0
                      ? Column(
                          children: List.generate(
                              widget.controller.drivens.length,
                              (index) => RideTile(
                                  driven: widget.controller.drivens[index])),
                        )
                      : Center(
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
                                "\n Rides History as a Rider",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )),
            )),
      ],
    );
  }
}

class RideTile extends StatelessWidget {
  final Driven driven;
  const RideTile({
    Key key,
    this.driven,
  }) : super(key: key);

  String parseDate(String date) {
    DateTime parsedDate = DateTime.tryParse(date);
    return formatDate(parsedDate);
  }

  String formatDate(DateTime date) => new DateFormat("d MMM y").format(date);

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LineAwesomeIcons.map_marker,
                          size: 25,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            driven.destination,
                            /* controller
                                              .queryController.text, */ //"Dutse Alhaji",
                            style: TextStyle(
                                color: kPrimaryAlternateColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LineAwesomeIcons.car,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "${driven.pickups[0].name}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.calendar,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          parseDate(driven.createdAt),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "N${driven.amount}",
                              style: TextStyle(
                                  color: kPrimaryAlternateColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Row(
                              children: [
                                Icon(LineAwesomeIcons.user_friends),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${driven.passengers.length} passenger(s)",
                                  style: TextStyle(
                                      color: kPrimaryAlternateColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
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
        Navigate.to(
            context,
            RideHistoryDetailScreen(
              driven: driven,
            ));
      },
    );
  }
}
