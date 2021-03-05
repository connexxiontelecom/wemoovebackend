import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    //return SizedBox.expand(
    return SlidingUpPanel(
      borderRadius: radius,
      minHeight: getProportionateScreenHeight(230),
      maxHeight: getProportionateScreenHeight(560),
      panel: Expanded(
          child: Padding(
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
              height: 80,
              child: TextField(
                style:
                    new TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                decoration:
                    noborderInputDecoration, /*InputDecoration(
                    //labelText: "search",
                    hintText: "Destination",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(LineAwesomeIcons.search)),*/
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
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                RIdeCard(),
                RIdeCard(),
                RIdeCard(),
                RIdeCard(),
                RIdeCard(),
              ],
            ))
            //Expanded(child: SingleChildScrollView(child: RIdeCard())),
          ],
        ),
      )),
      body: Stack(
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
                          "Good Afternoon,",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text("Jason",
                            style:
                                SmallHeadingStyle //TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
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
                        )
                      ],
                    ),
                    CircleAvatar(
                        radius: 35,
                        //child: Image.asset("assets/images/sample.jpg")
                        backgroundImage: AssetImage(
                            "assets/images/portrait.jpg") //NetworkImage(globals.user.avatar)
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

class RIdeCard extends StatelessWidget {
  const RIdeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
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
    );
  }
}
