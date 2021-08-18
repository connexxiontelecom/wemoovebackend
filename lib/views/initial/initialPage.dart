import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemoove/views/initial/components/body.dart';

class InitialPage extends StatelessWidget {
  static String routeName = "/initial";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
