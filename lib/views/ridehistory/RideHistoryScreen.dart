import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryScreen extends StatelessWidget {
  static String routeName = "/history";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
