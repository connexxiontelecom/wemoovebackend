import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/ChatController.dart';
import 'package:wemoove/controllers/PostRideController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/NotificationBadge.dart';
import 'package:wemoove/theme.dart';
import 'package:wemoove/views/signin/SignInScreen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(WeMoove());
}

class WeMoove extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _WeMooveState createState() => _WeMooveState();
}

class _WeMooveState extends State<WeMoove> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showSimpleNotification(
          Text(notification.title),
          leading: NotificationBadge(totalNotifications: 0),
          subtitle: Text(notification.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 2),
          trailing: Builder(builder: (context) {
            return TextButton(
                // Bu: Colors.yellow,
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                },
                child: Text('Dismiss'));
          }),
          autoDismiss: false,
          slideDismissDirection: DismissDirection.up,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    FirebaseMessaging.instance.subscribeToTopic("All");
    FirebaseMessaging.instance.getToken().then((token) {
      print('Token: $token');
      globals.devicetoken = token;
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostRideController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
          ),

          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: SignInScreen(),
          // We use routeName so that we dont need to remember the name
          //initialRoute: SplashScreen.routeName,
          //routes: routes,
        ),
      ),
    );
  }
}
