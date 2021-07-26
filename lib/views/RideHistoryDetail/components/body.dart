import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/controllers/RideHistoryController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Boarded.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final Boarded boarded;
  final RideHistoryController controller;
  const Body({Key key, this.boarded, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return /*ViewModelBuilder<RatingsController>.reactive(
        viewModelBuilder: () => RatingsController(),
        builder: (context, controller, child) =>*/
        Stack(
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
                  backButton(context),
                 /* InkWell(
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
                          style: TextStyle(fontSize: 18, color: kPrimaryColor),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),*/
                  Text(
                    "Ride's History",
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
                      child: Details(
                        boarded: widget
                            .controller.boarded[widget.controller.currentIndex],
                        controller: widget.controller,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.controller.boarded[widget.controller.currentIndex]
                          .isRated !=
                      1)
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                            height: 60,
                            //width: SizeConfig.screenWidth * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryAlternateColor,
                            ),
                            child: Center(
                                child: Text(
                              "Submit",
                              style:
                                  TextStyle(color: kPrimaryColor, fontSize: 18),
                            ))),
                      ),
                      onTap: () {
                        //Navigator.pop(context);
                        widget.controller.submit(context, widget.boarded);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    //);
  }
}

class Details extends StatefulWidget {
  final Boarded boarded;
  final RideHistoryController controller;
  const Details({
    Key key,
    this.boarded,
    this.controller,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int selectedRating = -1;
  updateSelectedRating(int rating) {
    setState(() {
      selectedRating = rating;
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
            boarded: widget.boarded,
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
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(widget
                    .controller
                    .boarded[widget.controller.currentIndex]
                    .driver
                    .profileImage),
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
                    "${widget.controller.boarded[widget.controller.currentIndex].driver.fullName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.controller.boarded[widget.controller.currentIndex].driver.plateNumber}"
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
                            "${widget.controller.boarded[widget.controller.currentIndex].driver.brand} ${widget.controller.boarded[widget.controller.currentIndex].driver.model}:",
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
                            "${widget.controller.boarded[widget.controller.currentIndex].driver.colour}",
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
                    "${widget.controller.boarded[widget.controller.currentIndex].seats} seat(s)",
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
                    "N${widget.controller.boarded[widget.controller.currentIndex].amount}",
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
                    widget.controller.boarded[widget.controller.currentIndex]
                                .status ==
                            4
                        ? "Completed"
                        : "Cancelled",
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
          if (widget
                  .controller.boarded[widget.controller.currentIndex].isRated !=
              1)
            Row(
              children: [
                Text(
                  "Your Rating",
                  style: TextStyle(fontSize: 18, color: kPrimaryAlternateColor),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    if (selectedRating >= index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            LineAwesomeIcons.star_1,
                            size: getProportionateScreenHeight(25),
                            color: kPrimaryColor,
                          ),
                        ),
                        onTap: () {
                          updateSelectedRating(index);
                          widget.controller.setSelectedRating(index + 1);
                        },
                      );
                    } else {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            LineAwesomeIcons.star,
                            size: getProportionateScreenHeight(25),
                            color: kPrimaryColor,
                          ),
                        ),
                        onTap: () {
                          updateSelectedRating(index);
                          widget.controller.setSelectedRating(index + 1);
                        },
                      );
                    }
                  }),

                  /* [
                  Icon(
                    LineAwesomeIcons.star_1,
                    size: getProportionateScreenHeight(20),
                    color: kPrimaryColor,
                  ),
                  Icon(
                    LineAwesomeIcons.star_1,
                    size: getProportionateScreenHeight(20),
                    color: kPrimaryColor,
                  ),
                  Icon(
                    LineAwesomeIcons.star_1,
                    size: getProportionateScreenHeight(20),
                    color: kPrimaryColor,
                  ),
                  Icon(
                    LineAwesomeIcons.star_1,
                    size: getProportionateScreenHeight(20),
                    color: kPrimaryColor,
                  ),
                  Icon(
                    LineAwesomeIcons.star_1,
                    size: getProportionateScreenHeight(20),
                    color: kPrimaryColor,
                  ),

                ],*/
                ),
              ],
            ),
          if (widget
                  .controller.boarded[widget.controller.currentIndex].isRated !=
              1)
            SizedBox(
              height: 30,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: kTextColor.withOpacity(0.2),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (widget
                  .controller.boarded[widget.controller.currentIndex].isRated !=
              1)
            Text("Additional feedback",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryAlternateColor)),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          SizedBox(
            height: 20,
          ),
          if (widget
                  .controller.boarded[widget.controller.currentIndex].isRated !=
              1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kprimarywhiteshade,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: null,
                    controller: widget.controller.commentController,
                    decoration: getInputDecoration("Leave a comment"),
                  ),
                ),
              ),
            ),
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
  final Boarded boarded;
  const TimeLine({
    Key key,
    this.boarded,
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${widget.boarded.destination}",
                                          style: TextStyle(
                                              fontSize: 20,
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${widget.boarded.pickup}",
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
