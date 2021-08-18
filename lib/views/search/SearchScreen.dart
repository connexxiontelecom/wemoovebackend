import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/SearchScreenController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/views/search/components/body_driver.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/MainDrawer.dart';
import 'components/body.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    return ViewModelBuilder<SearchScreenController>.reactive(
        viewModelBuilder: () => SearchScreenController(),
        builder: (context, controller, child) => Scaffold(
              key: scaffoldKey,
              body: globals.user.userType == 1 &&
                      (globals.isDriverMode || controller.isDriverMode)
                  ? DriverBody(
                      scaffoldkey: scaffoldKey,
                      controller: controller,
                    )
                  : Body(
                      scaffoldkey: scaffoldKey,
                      controller: controller,
                    ),
              drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor:
                      kPrimaryColor, //This will change the drawer background to blue.
                  //other styles
                ),
                child: MainDrawer("Drawer", controller),
              ),
            ));
    // return  globals.isDriverMode ? DriverBody() : Body();
  }
}
