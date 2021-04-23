import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/RideRequestsController.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RequestsScreen extends StatefulWidget {
  static String routeName = "/request";

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool up = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return ViewModelBuilder<RideRequestController>.reactive(
        viewModelBuilder: () => RideRequestController(),
        builder: (context, controller, child) => Scaffold(
                body: Body(
              controller: controller,
            )));
  }
}
