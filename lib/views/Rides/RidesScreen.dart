import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/RidesController.dart';
import 'package:wemoove/globals.dart' as globals;

import '../../size_config.dart';
import 'components/body.dart';

class RidesScreen extends StatefulWidget {
  static String routeName = "/rides";

  @override
  _RidesScreenState createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    SizeConfig().init(context);
    return ViewModelBuilder<RidesController>.reactive(
        viewModelBuilder: () => RidesController(),
        builder: (context, controller, child) => Scaffold(
              body: Body(
                controller: controller,
              ),
            ));
  }
}
