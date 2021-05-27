import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/controllers/RegisterCarController.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RegisterVehicle extends StatelessWidget {
  static String routeName = "/completeprofile";
  final RegistarCarController controller;
  const RegisterVehicle({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(
        controller: controller,
      ),
    );
  }
}
