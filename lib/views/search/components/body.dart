import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wemoove/components/ExpandableSection.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/SearchScreenController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/size_config.dart';
import 'package:wemoove/views/Rides/RidesScreen.dart';
import 'package:wemoove/views/booking/BookingScreen.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final SearchScreenController controller;
  const Body({Key key, this.scaffoldkey, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final LatLng _kMapCenter = LatLng(globals.lat, globals.lng);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 18.0, tilt: 0, bearing: 0);

  Timer timer;
  static const oneSec = const Duration(minutes: 3);
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = new Timer.periodic(oneSec, (Timer t) {
      widget.controller.CountAvailableRides();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focus = FocusNode();
    Size size = MediaQuery.of(context).size;
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    //return SizedBox.expand(

    return SlidingUpPanel(
      borderRadius: radius,
      minHeight: getProportionateScreenHeight(230),
      maxHeight: SizeConfig.screenHeight,
      panel: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 8,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            /* Text(
                "what\'s your destination",
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),*/
            SizedBox(height: getProportionateScreenHeight(20)),
            Container(
              height: 65,
              child: TextField(
                onChanged: (value) => widget.controller.searchPlaces(value),
                onTap: () {
                  widget.controller.clearSelectedLocation();
                },
                focusNode: focus,

                /* onTap: () async {
                  Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: "AIzaSyDAHdeQbSuLtDdpfhueU392zOUW6KAjGlA",
                    language: "en",
                    components: [
                      Component(Component.country, "ng"),
                      //Component(Component.locality, "Abuja"),
                    ],
                  );
                },*/
                onSubmitted: (value) {
                  //widget.controller.Search(context);
                },
                controller: widget.controller.queryController,
                style:
                    new TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                decoration: noborderInputDecoration(
                    context: context, controller: widget.controller),
              ),
            ),

            if (widget.controller.searchResults != null)
              SingleChildScrollView(
                child: Container(
                  height: 300.0,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(LineAwesomeIcons.map_marker),
                            title: Text(
                              widget
                                  .controller.searchResults[index].description,
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              focus.unfocus();
                              FocusManager.instance.primaryFocus.unfocus();
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              widget.controller.setSelectedLocation(widget
                                  .controller.searchResults[index].placeId);
                              widget.controller.setSelectedDestination(widget
                                  .controller.searchResults[index].description);

                              widget.controller
                                  .Search(widget.scaffoldkey.currentContext);
                            },
                          );
                        }),
                  ),
                ),
              ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  LineAwesomeIcons.home,
                ),
                SizedBox(width: 10),
                Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              children: [
                Icon(
                  LineAwesomeIcons.suitcase,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Work",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            widget.controller.rides.length > 0
                ? Row(
                    children: [
                      Text(
                        widget.controller.rides.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kPrimaryAlternateColor),
                      ),
                      Text(
                        widget.controller.rides.length > 1
                            ? " Rides Found"
                            : " Ride Found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  )
                : Container(),

            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.controller.rides.isNotEmpty ||
                          widget.controller.rides.length > 0
                      ? ListView.builder(
                          itemCount: widget.controller.rides
                              .length, //controller.Receipts.length, //recipients.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return RideCard(
                              controller: widget.controller,
                              ride: widget.controller.rides[index],
                            );
                          })
                      : widget.controller.isShow
                          ? Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/error.png",
                                    height: 300,
                                  ),
                                  Text(
                                    "No Rides Found"
                                    "\n For your searched Destination",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryAlternateColor),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          : Container(),
                ],
              ),
            )),
            //Expanded(child: SingleChildScrollView(child: RIdeCard())),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (widget.controller.currentLocation != null)
            GoogleMap(
              initialCameraPosition: _kInitialPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
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
                        child:
                            Icon(LineAwesomeIcons.list, color: kPrimaryColor),
                      ),
                      onTap: () {
                        widget.scaffoldkey.currentState.openDrawer();
                        //widget.scaffoldKey.currentState.openDrawer();
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
              height: getProportionateScreenHeight(145),
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Howdy,",
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(LineAwesomeIcons.map_marker),
                              if (widget.controller.CurrentLocationArea != null)
                                Expanded(
                                    child: widget.controller.CurrentLocationArea
                                                .split(",")
                                                .length >
                                            1
                                        ? Text(
                                            widget.controller
                                                    .CurrentLocationArea
                                                    .split(",")[0] +
                                                " " +
                                                widget.controller
                                                    .CurrentLocationArea
                                                    .split(",")[1],
                                            style: TextStyle(fontSize: 18),
                                          )
                                        : widget.controller.CurrentLocationArea
                                                    .split(",")
                                                    .length >
                                                0
                                            ? Text(
                                                widget.controller
                                                    .CurrentLocationArea
                                                    .split(",")[0],
                                                style: TextStyle(fontSize: 18),
                                              )
                                            : Text(
                                                widget.controller
                                                    .CurrentLocationArea,
                                                style: TextStyle(fontSize: 18),
                                              )),
                              SizedBox(
                                width: 5,
                              ),
                              /* Text(
                              "Abuja",
                              style: TextStyle(fontSize: 18),
                            ),*/
                            ],
                          )
                        ],
                      ),
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
                      "Available Rides",
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SummaryWidget(
                          title: "Total Rides",
                          value: "${widget.controller.TotalAvailableRides}",
                          icon: LineAwesomeIcons.car,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                          child: Container(
                            height: 40,
                            width: 100,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.2)),
                            child: Center(child: Text("view rides")),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RidesScreen()));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /* SizedBox.expand(
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.4,
                maxChildSize: 0.7,
                builder: (BuildContext c, s) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffb0cce1).withOpacity(0.9),
                            blurRadius: 5.0,
                          )
                        ]),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 8,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "what\'s your destination",
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                prefixIcon: Icon(LineAwesomeIcons.search)),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            controller: s,
                            children: <Widget>[
                              ListTile(
                                title: Text('Home'),
                                leading: Icon(LineAwesomeIcons.home),
                              ),
                              ListTile(
                                title: Text('Work'),
                                leading: Icon(LineAwesomeIcons.suitcase),
                              ),
                              ListTile(
                                title: Text('Recent Locations'),
                                leading: Icon(LineAwesomeIcons.map_marker),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )*/

          /* Container(
                height: getProportionateScreenHeight(100),
                decoration: BoxDecoration(
                    color: kPrimaryAlternateColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/appbarlogo.png",
                      height: getProportionateScreenHeight(30),
                      //width: getProportionateScreenWidth(235),
                    ),
                  ],
                ),
              ),*/
        ],
      ),
    );
    //);
  }
}

class RideCard extends StatefulWidget {
  final Ride ride;
  final SearchScreenController controller;
  const RideCard({Key key, this.ride, this.controller}) : super(key: key);

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
                        /* Row(
                    children: [
                      Icon(LineAwesomeIcons.car),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(child: Text(ride.pickups[0].name)),
                      //Icon(LineAwesomeIcons.angle_double_right),
                      //Text(ride.destination),
                    ],
                  ),*/
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
                          children: [
                            Icon(LineAwesomeIcons.map_pin),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Nearest Pickup: "),
                            Text(
                              widget.ride.pickups[0].time,
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
                                  widget.ride.takenSeats >= widget.ride.capacity
                                      ? "Full"
                                      : widget.ride.capacity -
                                                  widget.ride.takenSeats <
                                              0
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: createChildren(widget.ride
                          .pickups) /*[
                      InkWell(
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
                                widget.ride.pickup1,
                                style: TextStyle(color: kTextColor),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          String googleUrl =
                              "https://www.google.com/maps/search/?api=1&query=${widget.ride.pickup1}";
                          if (await canLaunch(googleUrl)) {
                            await launch(googleUrl);
                          } else {
                            toast('Could not open the map.');
                          }
                        },
                      ),
                      InkWell(
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
                                widget.ride.pickup2,
                                style: TextStyle(color: kTextColor),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          String googleUrl =
                              "https://www.google.com/maps/search/?api=1&query=${widget.ride.pickup2}";
                          if (await canLaunch(googleUrl)) {
                            await launch(googleUrl);
                          } else {
                            toast('Could not open the map.');
                          }
                        },
                      )
                    ],*/
                      ),
                ),
                /* onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },*/
                //)
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryAlternateColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            ride.pickup1,
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ride.pickup2 != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kPrimaryAlternateColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  ride.pickup2,
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
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

/*class RIdeCard extends StatelessWidget {
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
                          backgroundImage: AssetImage(
                              "assets/images/driver.jpg") //NetworkImage(globals.user.avatar)
                          ),
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
}*/
