import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/controllers/ChatController.dart';
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/views/chats/components/chatBody.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  dynamic RideId = 1;
  final ChatController controller;
  Body({Key key, this.scaffoldkey, this.RideId = 1, this.controller})
      : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool up = false;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return /*ViewModelBuilder<ChatController>.reactive(
        viewModelBuilder: () => ChatController(),
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
                  Row(
                    children: [
                     /* InkWell(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              LineAwesomeIcons.arrow_left,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Back",
                              style:
                                  TextStyle(fontSize: 18, color: kPrimaryColor),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),*/
                      backButton(context),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        "Conversations",
                        style: TextStyle(fontSize: 20, color: kPrimaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: getProportionateScreenHeight(120),
          left: 15,
          right: 15,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Note Chats are cleared after 24hrs")],
            ),
          ),
        ),
        Positioned.fill(
            top: getProportionateScreenHeight(140),
            left: 15,
            right: 15,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return chatTile();
                      })
                ],
              ),
            )),
      ],
    );
    //);
    //);
  }
}

class chatTile extends StatelessWidget {
  const chatTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 25,
                          //child: Image.asset("assets/images/sample.jpg")
                          backgroundImage: AssetImage(
                              "assets/images/portrait.jpg") //NetworkImage(globals.user.avatar)
                          ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jason Brookes",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryAlternateColor),
                          ),
                          Text(
                            "You will recieve notification when..",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("9:48 am"),
                      Text("June 19, 2015"),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.3)),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigate.to(context, ChatBody());
      },
    );
  }
}
