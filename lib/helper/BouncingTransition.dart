import 'package:flutter/cupertino.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;

  BouncyPageRoute({this.widget})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secanimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.center,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secanimation) {
              return widget;
            });
}

class Navigate {
  static to(context, Widget widget) {
    Navigator.push(context, BouncyPageRoute(widget: widget));
  }

  static pop(context) {
    Navigator.pop(context);
  }
}
