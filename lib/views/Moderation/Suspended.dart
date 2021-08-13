import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/globals.dart' as globals;

class Suspended extends StatelessWidget {
  final int status;
  const Suspended({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo.png",
              height: 35 //ScreenUtil().setHeight(50),
              ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Notice!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryAlternateColor),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            globals.user.fullName,
            style: TextStyle(fontSize: 20, color: kPrimaryAlternateColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your account is currently",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Text(
            status == 1
                ? "Suspended"
                : status == 2
                    ? "Banned"
                    : "Under Review",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryAlternateColor,
                fontSize: 18),
          ),
          SizedBox(
            height: 50,
          ),
          Icon(
            LineAwesomeIcons.envelope,
            size: 50,
          ),
          Column(
            children: [
              Text("contact support:"),
              Text(
                "support@app.wemoove.com",
                style: TextStyle(fontSize: 18),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
