import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/BookingController.dart';
import 'package:wemoove/models/Ride.dart';

import '../../size_config.dart';
import 'components/body.dart';

class BookingScreen extends StatelessWidget {
  final Ride ride;
  static String routeName = "/booking";
  const BookingScreen({Key key, this.ride}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return ViewModelBuilder<BookingController>.reactive(
        viewModelBuilder: () => BookingController(ride),
        builder: (context, controller, child) => Scaffold(
                body: Body(
              controller: controller,
            )));
  }
}
