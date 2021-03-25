import 'package:flutter/material.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/views/RideHistoryDetail/components/DriverRideHistoryDetail.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryDetailScreen extends StatelessWidget {
  static String routeName = "/history_detail";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: globals.isDriverMode ? DriverRideHistoryDetail() : Body(),
    );
  }
}
