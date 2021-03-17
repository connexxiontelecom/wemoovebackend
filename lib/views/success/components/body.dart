import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/views/ReservationDetailScreen/ReservationDetailScreen.dart';

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
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: kPrimaryColor),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: getProportionateScreenHeight(50),
                                    color: kprimarywhite,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Done!",
                              style: (TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w500,
                                  color: kPrimaryAlternateColor)),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              "Your reservation has been sent to the Driver, You will be notified upon acceptance by the driver.",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Thank you!",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(80),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    child: Container(
                        height: 80,
                        //width: SizeConfig.screenWidth * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kPrimaryAlternateColor,
                        ),
                        child: Center(
                          child: Text(
                            "View Reservation",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        )),
                    onTap: () {
                      Navigate.to(context, ReservationDetailScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
