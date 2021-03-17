import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
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
        Positioned(
          top: getProportionateScreenHeight(140),
          left: 5,
          right: 5,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text("How was your ride",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryAlternateColor)),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.star_1,
                                    size: getProportionateScreenHeight(35),
                                    color: kPrimaryColor,
                                  ),
                                  Icon(
                                    LineAwesomeIcons.star_1,
                                    size: getProportionateScreenHeight(35),
                                    color: kPrimaryColor,
                                  ),
                                  Icon(
                                    LineAwesomeIcons.star_1,
                                    size: getProportionateScreenHeight(35),
                                    color: kPrimaryColor,
                                  ),
                                  Icon(
                                    LineAwesomeIcons.star_1,
                                    size: getProportionateScreenHeight(35),
                                    color: kPrimaryColor,
                                  ),
                                  Icon(
                                    LineAwesomeIcons.star_1,
                                    size: getProportionateScreenHeight(35),
                                    color: kPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
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
                                    decoration:
                                        getInputDecoration("Leave a comment"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 80,
                      //width: SizeConfig.screenWidth * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryAlternateColor,
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
