import 'dart:async';

import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:wemoove/components/CustomButton.dart';
import 'package:wemoove/components/ExpandableSection.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/RideRequestsController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/managers/call_manager.dart';
import 'package:wemoove/models/request.dart';
import 'package:wemoove/size_config.dart';
import 'package:wemoove/views/chats/components/chatBody.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final RideRequestController controller;
  Body({Key key, this.scaffoldkey, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool up = false;
  Timer timer;
  static const oneSec = const Duration(minutes: 1);
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRequests();
    timer = new Timer.periodic(oneSec, (Timer t) {
      if (widget.controller.ride_current_status == 1) {
        widget.controller.RefreshData();
      }
      print("refreshed");
    });
  }

  fetchRequests() {
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
                        "Hello!,",
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
                          : AssetImage("assets/images/portrait.png")),
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
                "  ${widget.controller.requests.length} ${"(requests)"}",
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
            child: RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.controller.requests == null ||
                              widget.controller.requests.length <= 0
                          ? Center(
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
                            )
                          /* SizedBox(
                        height: 50,
                      )*/
                          : ListView.builder(
                              itemCount: widget.controller.requests
                                  .length, //controller.Receipts.length, //recipients.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return PassengerRequest(
                                  index: index,
                                  request: widget.controller.requests[index],
                                  controller: widget.controller,
                                );
                              }),
                      //if (widget.controller.ride_current_status != 3)
                      SizedBox(
                        height: 50,
                      ),

                      if (widget.controller.ride_current_status == 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Icon(LineAwesomeIcons.arrow_left),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Swipe Left to Cancel"),
                            ],
                          ),
                        ),

                      SwipeTo(
                        animationDuration: const Duration(milliseconds: 375),
                        iconOnRightSwipe: LineAwesomeIcons.arrow_right,
                        onLeftSwipe: () {
                          if (widget.controller.ride_current_status == 1) {
                            widget.controller.Cancel(context);
                          } else {}
                        },
                        onRightSwipe: () {
                          if (widget.controller.ride_current_status == 1) {
                            widget.controller.Start(context);
                          } else {
                            widget.controller.Finish(context);
                          }
                        },
                        //animationDuration: const Duration(milliseconds: 300),
                        child: CustomButton(
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              widget.controller.ride_current_status == 1
                                  ? Text(
                                      "Swipe to Start Ride",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    )
                                  : widget.controller.ride_current_status == 2
                                      ? Text(
                                          "Swipe to Finish Ride",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        )
                                      : Container(),
                              Icon(
                                LineAwesomeIcons.arrow_right,
                                color: kPrimaryColor,
                              )
                            ],
                          )),
                          ontap: () {},
                        ),
                      )

                      /* PassengerRequest(
                        accepted: true,
                      ),
                      PassengerRequest(),
                      PassengerRequest(),
                      PassengerRequest(
                        accepted: true,
                      ),
                      PassengerRequest(),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        /*  Positioned(
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
                    heroTag: "share",
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
            child: InkWell(
              child: Container(
                height: 50.0,
                child: FloatingActionButton(
                  heroTag: "times",
                  backgroundColor: kPrimaryAlternateColor,
                  child: Icon(
                    LineAwesomeIcons.times,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    widget.controller.Cancel(context);
                    setState(() {
                      up = !up;
                    });
                  },
                ),
              ),
              onTap: () {
                widget.controller.Cancel(context);
              },
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
                heroTag: "start",
                backgroundColor: kPrimaryAlternateColor,
                child: Icon(
                  LineAwesomeIcons.play,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  widget.controller.Start(context);
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
                heroTag: "menu",
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
        ),*/
      ],
    );
    //);
  }
}

class PassengerRequest extends StatefulWidget {
  const PassengerRequest({
    Key key,
    this.request,
    this.controller,
    this.index,
  }) : super(key: key);

  final Request request;
  final int index;
  final RideRequestController controller;
  @override
  _PassengerRequestState createState() => _PassengerRequestState();
}

class _PassengerRequestState extends State<PassengerRequest> {
  bool expand = false;

  _PassengerRequestState();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 30,
                  backgroundImage: NetworkImage(widget.request.profileImage),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.request.fullName}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.request.requestStatus == 1
                                ? "Pending"
                                : "Accepted",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: kPrimaryColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.request.seats} Seat(s)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: kPrimaryAlternateColor),
                          ),
                          if (widget.controller.unreads != null &&
                              widget.controller.unreads.length > 0 &&
                              widget.controller.containsIndex(widget.index) &&
                              widget.controller.aboveZero(widget.index))
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  "${widget.controller.unreads[widget.index]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.request.pickup}",
                              style: TextStyle(
                                  fontSize: 15, color: kPrimaryAlternateColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                expand
                    ? Icon(
                        LineAwesomeIcons.angle_up,
                      )
                    : Icon(
                        LineAwesomeIcons.angle_down,
                      )

                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/portrait.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${widget.request.fullName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.request.requestStatus == 1
                                  ? "Pending"
                                  : "Accepted",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kPrimaryColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.request.seats} Seat(s)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: kPrimaryAlternateColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${widget.request.pickup}",
                              style: TextStyle(
                                  fontSize: 15, color: kPrimaryAlternateColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),*/
                /*expand
                    ? Icon(
                        LineAwesomeIcons.angle_up,
                      )
                    : Icon(
                        LineAwesomeIcons.angle_down,
                      )*/
              ],
            ),
            onTap: () {
              setState(() {
                expand = !expand;
              });
            },
          ),
          ExpandedSection(
              expand: expand,
              child: Container(
                height: 100,
                //color: Colors.red,
                child: widget.request.requestStatus == 2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: kPrimaryAlternateColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.times,
                                    color: kPrimaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "Remove",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              )),
                            ),
                            onTap: () {
                              widget.controller
                                  .Decline(context, widget.request.pid);
                            },
                          ),
                          InkWell(
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: kPrimaryAlternateColor)),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Icon(
                                            LineAwesomeIcons.comments,
                                            color: kPrimaryColor,
                                          ),
                                          if (widget.controller.unreads !=
                                                  null &&
                                              widget.controller.unreads.length >
                                                  0 &&
                                              widget.controller.containsIndex(
                                                  widget.index) &&
                                              widget.controller
                                                  .aboveZero(widget.index))
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                            )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Chat",
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                            onTap: () {
                              widget.controller.updateUnread(widget.index);
                              Navigate.to(
                                  context,
                                  ChatBody(
                                      rideId: widget.request.rideId,
                                      name: widget.request.fullName,
                                      picture: widget.request.profileImage,
                                      recipient: widget.request.passengerId));
                            },
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: kPrimaryAlternateColor)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.phone,
                                    color: kPrimaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Call",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              )),
                            ),
                            onTap: () {
                              Set<int> _selectedUsers = {};
                              getUserByEmail(widget.request.email)
                                  .then((cubeUser) {
                                _selectedUsers.add(cubeUser.id);
                                CallManager.instance.startNewCall(context,
                                    CallType.AUDIO_CALL, _selectedUsers,
                                    image: widget.request.profileImage,
                                    fullname: widget.request.fullName);
                              }).catchError((error) {
                                toast("Can't  connect to recipient",
                                    duration: Duration(seconds: 8));
                              });

                              //print("hello");
                              // launch("tel:${widget.request.phoneNumber}");
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));*/
                            },
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: kPrimaryAlternateColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.check,
                                    color: kPrimaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "Accept",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              )),
                            ),
                            onTap: () {
                              widget.controller
                                  .Accept(context, widget.request.pid);
                            },
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  //color: kPrimaryAlternateColor,
                                  border: Border.all(color: kTextColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.times_circle,
                                    color: kPrimaryColor,
                                  ),
                                  Text(
                                    "Decline",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              )),
                            ),
                            onTap: () {
                              widget.controller
                                  .Decline(context, widget.request.pid);
                            },
                          ),
                        ],
                      ),
              )),
          if (widget.request.negotiated != 0)
            Container(
              height: .5,
              color: kPrimaryAlternateColor.withOpacity(0.3),
              width: double.infinity,
            ),
          SizedBox(
            height: 20,
          ),
          if (widget.request.negotiated != 0)
            Container(
              decoration: BoxDecoration(
                  color: kprimarywhiteshade,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      "Offer",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text("N${widget.request.fare}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryAlternateColor,
                            fontSize: 18)),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      "Drop-off:",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      "${widget.request.dropoff}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryAlternateColor),
                    ))
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
