import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/WalletController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/views/Wallet/components/Body.dart';

import '../../size_config.dart';

class WalletScreen extends StatelessWidget {
  static String routeName = "/wallet";
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return ViewModelBuilder<WalletController>.reactive(
        viewModelBuilder: () => WalletController(),
        builder: (context, controller, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: Body(controller: controller)));
  }
}
