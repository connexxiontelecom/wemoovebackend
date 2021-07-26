import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wemoove/components/ExpandableSection.dart';
import 'package:wemoove/controllers/RidesController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/views/booking/BookingScreen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final RidesController controller;
  const Body({Key key, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool editHome = false;
  bool editWork = false;

  fetchRides() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.Fetch(context);
    });
  }

  Future<void> refresh() async {
    widget.controller.Fetch(context);
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.Rides == null) {
      fetchRides();
    }
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
                  /*GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.arrow_left,
                          color: kPrimaryColor,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),*/
                  backButton(context),
                  Text(
                    "Available Rides",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                    ),
                  ),
                  CircleAvatar(
                      radius: 25,
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
        Positioned.fill(
          top: getProportionateScreenHeight(140),
          left: 15,
          right: 15,
          child: RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: widget.controller.Rides != null &&
                        widget.controller.Rides.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          child: Container(
                              child: Column(
                            children: List.generate(
                                widget.controller.Rides.length,
                                (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: RideCard(
                                        ride: widget.controller.Rides[index],
                                      ),
                                    )),
                          )),
                        ),
                      )
                    : Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/error.png",
                                height: 300,
                              ),
                              Text(
                                "No Rides Found",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )),
          ),
        ),
      ],
    );
  }
}

class RideCard extends StatefulWidget {
  final Ride ride;
  //final SearchScreenController controller;
  const RideCard({Key key, this.ride}) : super(key: key);
  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  List<Widget> createChildren(List<Pickups> list) {
    return new List<Widget>.generate(list.length, (int index) {
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              //color: kPrimaryAlternateColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                list[index].name,
                style: TextStyle(color: kTextColor),
              ),
            ),
          ),
        ),
        onTap: () async {
          String googleUrl =
              "https://www.google.com/maps/search/?api=1&query=${list[index].name}";
          if (await canLaunch(googleUrl)) {
            await launch(googleUrl);
          } else {
            toast('Could not open the map.');
          }
        },
      );
    });
  }

  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
              children: [
                InkWell(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              LineAwesomeIcons.map_marker,
                              size: 20,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                widget.ride.destination,
                                style: TextStyle(
                                    color: kPrimaryAlternateColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(LineAwesomeIcons.clock),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Take-off: "),
                            Text(
                              widget.ride.departureTime,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryAlternateColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(LineAwesomeIcons.user),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Seats:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryAlternateColor),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.ride.takenSeats == widget.ride.capacity
                                      ? "Full"
                                      : "${widget.ride.capacity - widget.ride.takenSeats}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: kPrimaryColor),
                                ),
                                Text(
                                  "/",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryAlternateColor),
                                ),
                                Text(
                                  "${widget.ride.capacity}",
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
                                  "N",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23),
                                ),
                                Text(
                                  "${widget.ride.amount}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                      color: kPrimaryAlternateColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigate.to(
                          context,
                          BookingScreen(
                            ride: widget.ride,
                          ));
                    }),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pickups",
                          style: TextStyle(
                              color: kPrimaryAlternateColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          LineAwesomeIcons.angle_down,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                ),
                /* InkWell(
                  child:*/
                ExpandedSection(
                  expand: expanded,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: createChildren(widget.ride.pickups)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
