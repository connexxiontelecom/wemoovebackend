import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wemoove/controllers/RideRequestsController.dart';
import 'package:wemoove/globals.dart' as globals;

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
    final controller = Provider.of<RideRequestController>(context);
    globals.rideRequestController = controller;
    globals.context = context;
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return /*ViewModelBuilder<RideRequestController>.reactive(
        viewModelBuilder: () => globals.rideRequestController,
        builder: (context, controller, child) =>*/
        Scaffold(
            body: Body(
      controller: controller,
    ));
    //);
  }
}
