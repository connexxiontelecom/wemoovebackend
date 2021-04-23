import 'package:flutter/material.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/Driven.dart';
import 'package:wemoove/views/RideHistoryDetail/components/DriverRideHistoryDetail.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryDetailScreen extends StatelessWidget {
  final Boarded boarded;
  final Driven driven;
  static String routeName = "/history_detail";

  const RideHistoryDetailScreen({Key key, this.boarded, this.driven})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: globals.isDriverMode
          ? DriverRideHistoryDetail(
              driven: driven,
            )
          : Body(
              boarded: boarded,
            ),
    );
  }
}
