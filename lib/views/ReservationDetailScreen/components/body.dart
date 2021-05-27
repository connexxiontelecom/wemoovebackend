import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wemoove/components/CustomButton.dart';
import 'package:wemoove/components/ExpandableSection.dart';
import 'package:wemoove/controllers/ReservationController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/views/chats/components/chatBody.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final ReservationController controller;

  const Body({Key key, this.controller}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    fetchRequest();
  }

  fetchRequest() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.Fetch(context);
    });
  }

  Future<void> refresh() async {
    widget.controller.Fetch(context);
    setState(() {});
    return;
  }

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
            top: getProportionateScreenHeight(140),
            left: 15,
            right: 15,
            child: RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                                    "Hi,",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(globals.user.fullName.split(",")[0],
                                      style:
                                          SmallHeadingStyle //TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  /* Row(
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
                                  )*/
                                ],
                              ),
                              CircleAvatar(
                                  radius: 35,
                                  //child: Image.asset("assets/images/sample.jpg")
                                  backgroundImage: globals.user != null &&
                                          globals.user.profileImage != null &&
                                          globals.user.profileImage.isNotEmpty
                                      ? NetworkImage(globals.user.profileImage)
                                      : AssetImage(
                                          "assets/images/portrait.png")),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (widget.controller.reservation != null)
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Details(controller: widget.controller)),
                      SizedBox(
                        height: 20,
                      ),
                      if (widget.controller.reservation != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: kPrimaryAlternateColor,
                                    ),
                                    child: Icon(
                                      LineAwesomeIcons.phone,
                                      color: kPrimaryColor,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Contact",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              onTap: () {
                                launch(
                                    "tel:${widget.controller.reservation.driver.phoneNumber}");
                              },
                            ),
                            InkWell(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: kPrimaryAlternateColor,
                                        ),
                                        child: Icon(
                                          LineAwesomeIcons.comments,
                                          color: kPrimaryColor,
                                          size: 30,
                                        ),
                                      ),
                                      if (widget.controller.unreads != null &&
                                          widget.controller.unreads.length >
                                              0 &&
                                          widget.controller.unreads[0] != 0)
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Text(
                                              "${widget.controller.unreads[0]}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Chat",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigate.to(
                                    context,
                                    ChatBody(
                                        name: widget.controller.reservation
                                            .driver.fullName,
                                        rideId: widget
                                            .controller.reservation.rideId,
                                        picture: widget.controller.reservation
                                            .driver.profileImage,
                                        recipient: widget.controller.reservation
                                            .driver.driverId));
                              },
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: kPrimaryAlternateColor,
                                  ),
                                  child: Icon(
                                    LineAwesomeIcons.share,
                                    color: kPrimaryColor,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Share",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                            InkWell(
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: kPrimaryAlternateColor,
                                    ),
                                    child: Icon(
                                      LineAwesomeIcons.times,
                                      color: kPrimaryColor,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              onTap: () {
                                widget.controller.Decline(context);
                              },
                            ),
                          ],
                        ),
                      if (widget.controller.reservation == null)
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
                                "Oops Could not load "
                                "\n Reservation Details",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                child: Center(
                                    child: Text(
                                  "Retry",
                                  style: TextStyle(
                                      fontSize: 18, color: kPrimaryColor),
                                )),
                                ontap: () {
                                  widget.controller.Fetch(context);
                                },
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class Details extends StatefulWidget {
  final ReservationController controller;
  const Details({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool expanded = false;
  bool expandedknockOffs = false;

  List<Widget> createChildren(list) {
    return new List<Widget>.generate(list.length, (int index) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryAlternateColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  list[index],
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

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
          TimeLine(
            controller: widget.controller,
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
            height: 20,
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Knockoffs",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kPrimaryAlternateColor),
                    ),
                    Text(
                      "(Areas Driver won't be stopping)",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: kPrimaryAlternateColor),
                    ),
                  ],
                ),
                Icon(LineAwesomeIcons.plus_square),
              ],
            ),
            onTap: () {
              setState(() {
                expandedknockOffs = !expandedknockOffs;
              });
            },
          ),
          ExpandedSection(
            expand: expandedknockOffs,
            child: Container(
              child: Wrap(
                  children:
                      createChildren(widget.controller.reservation.knockoffs)),
            ),
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
                    widget.controller.reservation.departureTime,
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
            height: 20,
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rider",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: kPrimaryAlternateColor),
                ),
                Icon(LineAwesomeIcons.plus_square),
              ],
            ),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          ExpandedSection(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50.0,
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
                      widget.controller.reservation.driver.fullName,
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
                          "${widget.controller.reservation.passengers}",
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
                      widget.controller.reservation.driver.plateNumber
                          .toUpperCase(),
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
                              widget.controller.reservation.driver
                                  .model, //"Toyota Corolla :",
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
                              widget.controller.reservation.driver.colour,
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
            expand: expanded,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reserved",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${widget.controller.reservation.seats} seat(s)",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "N${widget.controller.reservation.amount}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
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
                    widget.controller.reservation.requestStatus == 1
                        ? "Pending"
                        : widget.controller.reservation.requestStatus == 2
                            ? "Accepted"
                            : "Declined",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
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
  final ReservationController controller;
  const TimeLine({
    Key key,
    this.controller,
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
                                  AssetImage("assets/images/portrait.png"),
                              backgroundColor: Colors.transparent,
                            ),*/
                            SizedBox(
                              width: 10,
                            ),
                            index == 1
                                ? Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Drop-off Location",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryAlternateColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.controller.reservation
                                              .destination,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pick-Up Location",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryAlternateColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.controller.reservation.pickup,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
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
