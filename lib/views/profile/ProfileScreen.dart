import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/ProfileScreenController.dart';

import '../../size_config.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<ProfileScreenController>.reactive(
        viewModelBuilder: () => ProfileScreenController(),
        builder: (context, controller, child) => Scaffold(
              body: Body(
                controller: controller,
              ),
            ));
  }
}
