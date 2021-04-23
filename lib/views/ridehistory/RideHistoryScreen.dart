import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/RideHistoryController.dart';
import 'package:wemoove/views/ridehistory/components/DriverHistoryBody.dart';

import '../../globals.dart' as globals;
import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryScreen extends StatelessWidget {
  static String routeName = "/history";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<RideHistoryController>.reactive(
        viewModelBuilder: () => RideHistoryController(/*context: context*/),
        builder: (context, controller, child) => Scaffold(
              body: globals.isDriverMode
                  ? DriverHistoryBody(
                      controller: controller,
                    )
                  : Body(
                      controller: controller,
                    ),
            ));
  }
}
