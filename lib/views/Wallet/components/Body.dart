import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/controllers/WalletController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/views/Wallet/TransactionDetails.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final WalletController controller;

  const Body({Key key, this.controller}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> refresh() async {
    widget.controller.getWalletBalance();
    setState(() {});
    return;
  }

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
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.arrow_left,
                          color: kPrimaryColor,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Wallet",
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
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Your Balance:",
                              style: TextStyle(
                                  fontSize: 20, color: kPrimaryAlternateColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "N${globals.numFormatter.format(widget.controller.balance)}",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: kPrimaryAlternateColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: kPrimaryAlternateColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "View History",
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigate.to(
                                        context,
                                        TransactionDetails(
                                          controller: widget.controller,
                                        ));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    WalletMenuTile(
                      icon: LineAwesomeIcons.wallet,
                      title: "Fund Wallet",
                      onTap: () {},
                    ),
                    WalletMenuTile(
                      icon: LineAwesomeIcons.receipt,
                      title: "Voucher",
                      onTap: () {},
                    ),
                    /* WalletMenuTile(
                      icon: LineAwesomeIcons.address_book,
                      title: "Bank Details",
                      onTap: () {},
                    ),*/
                    WalletMenuTile(
                      icon: LineAwesomeIcons.arrow_right,
                      title: "Transfer",
                      onTap: () {
                        widget.controller.transfer(context, widget.controller);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: InkWell(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(icon),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: 20),
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
