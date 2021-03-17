import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

class RideHistoryDetailScreen extends StatelessWidget {
  static String routeName = "/history_detail";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
