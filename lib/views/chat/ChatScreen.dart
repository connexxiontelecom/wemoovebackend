import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../size_config.dart';
import 'components/body.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/request";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool up = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return /*ViewModelBuilder<ChatController>.reactive(
        viewModelBuilder: () => ChatController(),
        builder: (context, controller, child) => */
        Scaffold(
            body: Body(
                //controller: controller,
                )); //);
  }
}
