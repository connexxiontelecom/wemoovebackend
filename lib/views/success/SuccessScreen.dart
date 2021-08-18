import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemoove/globals.dart' as globals;

import '../../size_config.dart';
import 'components/body.dart';

class SuccessScreen extends StatelessWidget {
  static String routeName = "/success";
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return Scaffold(body: Body());
  }
}
