import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/ProfileScreenController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/size_config.dart';

class Body extends StatefulWidget {
  final ProfileScreenController controller;
  const Body({Key key, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool editHome = false;
  bool editWork = false;

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
                  backButton(context),
                  Image.asset(
                    "assets/images/appbarlogo.png",
                    height: getProportionateScreenHeight(30),
                    //width: getProportionateScreenWidth(235),
                  ),
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
            top: getProportionateScreenHeight(140),
            left: 15,
            right: 15,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [




                          CircleAvatar(
                            radius: 80,
                            backgroundColor: kPrimaryColor,
                            child: CircleAvatar(
                                radius: 75,
                                backgroundColor: kPrimaryColor,
                                backgroundImage: widget.controller.file != null
                                    ? Image.file(
                                        widget.controller.file,
                                      ).image
                                    : globals.user != null &&
                                            globals.user.profileImage != null &&
                                            globals.user.profileImage.isNotEmpty
                                        ? NetworkImage(
                                            globals.user.profileImage)
                                        : AssetImage(
                                            "assets/images/portrait.png")),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: kPrimaryAlternateColor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: kPrimaryColor,
                                  size: 40,
                                ),
                              ),
                              onTap: () {
                                widget.controller.SelectFile();
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "First Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                globals.user.fullName.split(" ")[0],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryAlternateColor),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Last Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                globals.user.fullName.split(" ")[1],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryAlternateColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                globals.user.email,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryAlternateColor),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile Number ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                globals.user.phoneNumber,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryAlternateColor),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      "Home",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Icon(LineAwesomeIcons.pen)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    editHome = !editHome;
                                  });
                                },
                              ),
                              if (!editHome)
                                GestureDetector(
                                  child: Text(
                                    widget.controller.homeController.text
                                            .isEmpty
                                        ? "Add Home Address"
                                        : widget.controller.homeController.text,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      editHome = !editHome;
                                    });
                                  },
                                ),
                              if (editHome)
                                Container(
                                  height: 100,
                                  width: SizeConfig.screenWidth * 0.8,
                                  decoration: BoxDecoration(
                                      color: kprimarywhiteshade,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      controller:
                                          widget.controller.homeController,
                                      maxLines: null,
                                      decoration: getInputDecoration(
                                          "Enter Home Location"),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      "Work",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Icon(LineAwesomeIcons.pen)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    editWork = !editWork;
                                  });
                                },
                              ),
                              if (!editWork)
                                GestureDetector(
                                  child: Text(
                                    widget.controller.workController.text
                                            .isEmpty
                                        ? "Add work Address"
                                        : widget.controller.workController.text,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      editWork = !editWork;
                                    });
                                  },
                                ),
                              if (editWork)
                                Container(
                                  height: 100,
                                  width: SizeConfig.screenWidth * 0.8,
                                  decoration: BoxDecoration(
                                      color: kprimarywhiteshade,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      controller:
                                          widget.controller.workController,
                                      maxLines: null,
                                      decoration: getInputDecoration(
                                          "Enter Work Location"),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                      /*  SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          child: Container(
                              height: 60,
                              //width: SizeConfig.screenWidth * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.plus_square,
                                      color: kPrimaryAlternateColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Add Vehicle",
                                      style: TextStyle(
                                          color: kPrimaryAlternateColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              )),
                          onTap: () {
                            Navigate.to(context, RegisterVehicle());
                          },
                        ),
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                  "Save and Exit",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              )),
                          onTap: () {
                            // Navigate.pop(context);
                            if (widget.controller.file != null ||
                                widget.controller.workController.text
                                    .isNotEmpty ||
                                widget.controller.homeController.text
                                    .isNotEmpty) {
                              widget.controller.SaveUpdates(context);
                            } else {
                              toast("Nothing to update",
                                  duration: Toast.LENGTH_LONG);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
