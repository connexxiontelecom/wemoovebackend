import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/RegisterCarController.dart';
import 'package:wemoove/globals.dart' as globals;

import '../../size_config.dart';
import 'components/body.dart';

class VehiclesScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    SizeConfig().init(context);
    return ViewModelBuilder<RegistarCarController>.reactive(
        viewModelBuilder: () => RegistarCarController(),
        builder: (context, controller, child) => Scaffold(
              body: Body(
                controller: controller,
              ),
            ));
  }
}
