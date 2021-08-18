import 'package:flutter/material.dart';
import 'package:wemoove/controllers/RideHistoryController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/Driven.dart';
import 'package:wemoove/views/RideHistoryDetail/components/DriverRideHistoryDetail.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryDetailScreen extends StatelessWidget {
  final Boarded boarded;
  final Driven driven;
  final RideHistoryController controller;
  static String routeName = "/history_detail";

  const RideHistoryDetailScreen(
      {Key key, this.boarded, this.driven, this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    SizeConfig().init(context);
    return Scaffold(
      body: globals.isDriverMode
          ? DriverRideHistoryDetail(
              driven: driven,
            )
          : Body(
              boarded: boarded,
              controller: controller,
            ),
    );
  }
}
