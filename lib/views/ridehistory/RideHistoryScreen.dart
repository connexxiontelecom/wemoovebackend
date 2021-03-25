import 'package:flutter/material.dart';
import 'package:wemoove/views/ridehistory/components/DriverHistoryBody.dart';

import '../../globals.dart' as globals;
import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryScreen extends StatelessWidget {
  static String routeName = "/history";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: globals.isDriverMode ? DriverHistoryBody() : Body(),
    );
  }
}
