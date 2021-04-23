import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/ReservationController.dart';

import '../../size_config.dart';
import 'components/body.dart';

class ReservationDetailScreen extends StatelessWidget {
  static String routeName = "/reservation_detail";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return ViewModelBuilder<ReservationController>.reactive(
        viewModelBuilder: () => ReservationController(/*context: context*/),
        builder: (context, controller, child) => Scaffold(
                body: Body(
              controller: controller,
            )));
  }
}
