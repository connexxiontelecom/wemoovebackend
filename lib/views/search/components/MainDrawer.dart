import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/SearchScreenController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/views/Wallet/WalletScreen.dart';
import 'package:wemoove/views/driver/CompleteProfileScreen.dart';
import 'package:wemoove/views/profile/ProfileScreen.dart';
import 'package:wemoove/views/ridehistory/RideHistoryScreen.dart';
import 'package:wemoove/views/signin/SignInScreen.dart';
import 'package:wemoove/views/support/supportScreen.dart';
import 'package:wemoove/views/vehicles/VehiclesScreen.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer(this.currentPage, this.controller);
  final String currentPage;
  final SearchScreenController controller;

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
          // height: 150,
          width: double.infinity,
          color: kprimarywhite,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/logox.png',
                  height: 35,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 35,
                        //child: Image.asset("assets/images/sample.jpg")
                        backgroundImage: globals.user != null &&
                                globals.user.profileImage != null &&
                                globals.user.profileImage.isNotEmpty
                            ? NetworkImage(globals.user.profileImage)
                            : AssetImage("assets/images/portrait.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 8),
                child: Text(globals.user.fullName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor,
                        fontSize: 18)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.user,
                    title: "Profile",
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigate.to(context, ProfileScreen());
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
                InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.history,
                    title: globals.isDriverMode == true &&
                            globals.user.userType == 1
                        ? "Ride History"
                        : "Trip History",
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigate.to(context, RideHistoryScreen());
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
                InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.wallet,
                    title: "Wallet",
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigate.to(context, WalletScreen());
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
                if (globals.user.userType == 1 && globals.isDriverMode)
                  InkWell(
                    child: MenuItem(
                      icon: LineAwesomeIcons.car,
                      title: "My Cars",
                    ),
                    onTap: () {
                      // Navigator.pop(context);
                      Navigate.to(context, VehiclesScreen());
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                globals.isDriverMode
                    ? Container()
                    : Container() /*InkWell(
                        child: MenuItem(
                          icon: LineAwesomeIcons.wallet,
                          title: "Discounts",
                        ),
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      )*/
                ,
                InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.headphones,
                    title: "Support",
                  ),
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                    Navigate.to(context, SupportScreen());
                  },
                ),
                /*InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.info_circle,
                    title: "About",
                  ),
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),*/
                /*  InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.cog,
                    title: "Settings",
                  ),
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                    //Navigator.pop(context);
                  },
                ),*/
                InkWell(
                  child: MenuItem(
                    icon: LineAwesomeIcons.alternate_sign_out,
                    title: "Sign Out",
                  ),
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                        (Route<dynamic> route) => false);
                    /*
                    to do
                    Invalidate token
                    */
                  },
                ),
                globals.user.userType == 1
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          child: Container(
                              height: 60,
                              //width: SizeConfig.screenWidth * 0.7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Colors.cyan[700] //kPrimaryAlternateColor,
                                  ),
                              child: Center(
                                child: Text(
                                  globals.isDriverMode
                                      ? "Switch to Passenger"
                                      : "Switch to Driver",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              )),
                          onTap: () {
                            globals.isDriverMode = !globals.isDriverMode;
                            print(globals.isDriverMode);
                            widget.controller.changeMode();
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      )
                    : Container(),
                if (globals.user.userType == 0)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      child: Container(
                          height: 60,
                          //width: SizeConfig.screenWidth * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.cyan[700] //kPrimaryAlternateColor,
                              ),
                          child: Center(
                            child: Text(
                              "Sign-up to Drive",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          )),
                      onTap: () {
                        Navigate.to(context, CompleteProfileScreen());
                      },
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: kTextColor,
              size: 32,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: kTextColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
