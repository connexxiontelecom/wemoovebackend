import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wemoove/controllers/ReservationController.dart';
import 'package:wemoove/globals.dart' as globals;

import '../../size_config.dart';
import 'components/body.dart';

class ReservationDetailScreen extends StatefulWidget {
  static String routeName = "/reservation_detail";
  final redirect;

  const ReservationDetailScreen({Key key, this.redirect = true})
      : super(key: key);

  @override
  _ReservationDetailScreenState createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReservationController>(context);
    globals.reservationController = controller;
    globals.reservationController.init(widget.redirect);
    globals.context = context;
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return /*ViewModelBuilder<ReservationController>.reactive(
        viewModelBuilder: () => globals.reservationController,
        builder: (context, controller, child) =>*/
        WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
          body: Body(
        controller: controller,
      )),
    );
    //);
  }

  Future<bool> _onBackPressed() {
    return Future.value(false);
  }
}
