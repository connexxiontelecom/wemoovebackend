import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/VASController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/views/VASServices/VASForm.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'VASCableTVForm.dart';
import 'VASDataBundleForm.dart';
import 'VASElectricityForm.dart';

class ValueAddedServices extends StatefulWidget {
  const ValueAddedServices({Key key}) : super(key: key);
  @override
  _ValueAddedServicesState createState() => _ValueAddedServicesState();
}

class _ValueAddedServicesState extends State<ValueAddedServices> {
  bool visible = false;

  Future<void> refresh() async {
    //widget.controller.getWalletBalance();
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    globals.context = context;
    return ViewModelBuilder<VASController>.reactive(
      viewModelBuilder: () => VASController(),
      builder: (context, controller, child) {
        //controller.context = context;
        return Scaffold(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        backButton(context),
                        Text(
                          "Value Added Services",
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
                top: getProportionateScreenHeight(120),
                left: 5,
                right: 5,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
//list vas here
                          WalletMenuTile(
                            title: "Airtime",
                            icon: LineAwesomeIcons.signal,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VASFormScreen(
                                          //controller: widget.controller,
                                          )));
                            },
                          ),
                          WalletMenuTile(
                            icon: LineAwesomeIcons.lightning_bolt,
                            title: "Electricity",
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VASElectricityFormScreen(
                                            //controller: widget.controller,
                                          )));
                            },
                          ),
                          WalletMenuTile(
                            title: "Mobile Data",
                            icon: LineAwesomeIcons.broadcast_tower,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VASDataBundleFormScreen(
                                              //controller: widget.controller,
                                              )));
                            },
                          ),
                          WalletMenuTile(
                            icon: LineAwesomeIcons.television,
                            title: "Cable TV ",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VASCableTVFormScreen(
                                              //controller: widget.controller,
                                              )));
                            },
                          ),
                          WalletMenuTile(
                            icon: LineAwesomeIcons.qrcode,
                            title: "E-Pin",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WalletMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  const WalletMenuTile({
    Key key,
    this.icon,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(LineAwesomeIcons.angle_right),
              )
            ],
          ),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kprimarywhite,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 5,
                color: Color(0xffb0cce1).withOpacity(0.5),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
