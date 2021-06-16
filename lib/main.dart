import 'dart:io';

import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/ChatController.dart';
import 'package:wemoove/controllers/PostRideController.dart';
import 'package:wemoove/controllers/RegisterCarController.dart';
import 'package:wemoove/controllers/ReservationController.dart';
import 'package:wemoove/controllers/RideRequestsController.dart';
import 'package:wemoove/controllers/SignInController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/NotificationBadge.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/theme.dart';
import 'package:wemoove/utils/configs.dart' as config;
import 'package:wemoove/utils/pref_util.dart';
import 'package:wemoove/views/ReservationDetailScreen/ReservationDetailScreen.dart';
import 'package:wemoove/views/driver/CompleteProfileScreen.dart';
import 'package:wemoove/views/otp/otp_screen.dart';
import 'package:wemoove/views/requests/RequestsScreen.dart';
import 'package:wemoove/views/search/SearchScreen.dart';
import 'package:wemoove/views/signin/SignInScreen.dart';
import 'package:wemoove/views/splash/ReturningSplash.dart';
import 'package:wemoove/views/splash/SplashScreen.dart';

import 'managers/call_manager.dart';
import 'models/Credentials.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
}

initConnectycube() {
  init(
    config.APP_ID,
    config.AUTH_KEY,
    config.AUTH_SECRET,
    onSessionRestore: () {
      return SharedPrefs.instance.init().then((preferences) {
        return createSession(preferences.getUser());
      });
    },
  );
  // PushNotificationsManager.instance.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory document = await getApplicationDocumentsDirectory();
  //globals.rideRequestController = RideRequestController();
  //globals.reservationController = ReservationController();
  Hive.init(document.path);
  initConnectycube();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);

//  _zonedScheduleNotification();
  runApp(WeMoove());
}

class WeMoove extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _WeMooveState createState() => _WeMooveState();
}

class _WeMooveState extends State<WeMoove> {
  bool isLocalExists; // = false;
  Widget screen = ReturningSplashScreen();
  int alarmId = 1;
  Future openBox() async {
    globals.box = await Hive.openBox("data");
    await getCredentials();
    if (globals.user != null) {
      CubeUser user = CubeUser(
          email: globals.user.email,
          password: '!@wemoove',
          fullName: globals.user.fullName);

      SignInController().initCube(user);

      if (globals.user.verified != 1) {
        //Navigate.to(context, OtpScreen());
        setState(() {
          screen = OtpScreen();
        });
      } else if (globals.user.userType == 1 && globals.user.hasvehicle != 1) {
        //Navigate.to(context, CompleteProfileScreen());
        setState(() {
          screen = CompleteProfileScreen();
        });
      } else if (globals.user.userType == 1 &&
          globals.user.currentRideStatus == 1) {
        /*Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RequestsScreen()),
            (Route<dynamic> route) => false);*/
        setState(() {
          screen = RequestsScreen();
        });
      } else if ((globals.user.userType == 1 || globals.user.userType == 0) &&
          globals.user.currentRequestStatus == 1) {
        /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ReservationDetailScreen()),
            (Route<dynamic> route) => false);*/
        setState(() {
          screen = ReservationDetailScreen();
        });
      } else {
        //Navigate.to(context, SearchScreen());
        setState(() {
          screen = SearchScreen();
        });
      }
    }

    return;
  }

  getCredentials() async {
    if (globals.box.containsKey("credentials")) {
      Credentials credentials = globals.box.get("credentials");
      print(credentials.username.toString());
      print(credentials.password.toString());
      if (credentials.password != null && credentials.username != null) {
        var data = {
          "username": credentials.username,
          "password": credentials.password,
        };

        var response = await UserServices.loginUser(data);
        if (response != "success") {
          setState(() {
            screen = SignInScreen();
          });
        }
      } else {
        print("no values");
        setState(() {
          screen = SplashScreen();
        });
      }
    } else {
      print("no local storage");
      setState(() {
        screen = SplashScreen();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Hive.registerAdapter(CredentialsAdapter());
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      /*print("hey");
      print(globals.user.currentRideStatus == 1);
      print(globals.user.userType == 1);
      print(globals.user.userType == 0);
      print(globals.user.currentRequestStatus == 1);*/

      /* if (Platform.isAndroid) {
        var methodChannel = MethodChannel("connexxion.start");
        String data = await methodChannel.invokeMethod("start");
        debugPrint(data);
      }*/

      if ((globals.user.userType == 1 || globals.user.userType == 0) &&
          globals.user.currentRequestStatus == 1 &&
          globals.reservationController != null) {
        print("reservaton refreshed");
        globals.reservationController.fetchUnreadMessages();
        globals.reservationController.Refresh();
      }

      if (globals.user.userType == 1 &&
          globals.user.currentRideStatus == 1 &&
          globals.rideRequestController != null) {
        print("request refreshed");
        globals.rideRequestController.fetchUnreadMessages();
        globals.rideRequestController.RefreshData();
        //globals.rideRequestController.Fetch(context);
      }

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showSimpleNotification(
          Text(notification.title),
          leading: NotificationBadge(totalNotifications: 0),
          subtitle: Text(notification.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 5),
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
          autoDismiss: true, //false,
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

    openBox();
  }

  @override
  Widget build(BuildContext context) {
    //CallManager.instance.init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostRideController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => RegistarCarController()),
        ChangeNotifierProvider(create: (_) => ReservationController()),
        ChangeNotifierProvider(create: (_) => RideRequestController()),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          builder: (context, widget) {
            return ResponsiveWrapper.builder(
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
            );
          },
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: Builder(
            builder: (context) {
              CallManager.instance.init(context);
              return screen;
            },
          ), //screen, //SignInScreen(),
          //routes: routes,
          routes: {
            '/splash': (context) => SplashScreen(),
          },
        ),
      ),
    );
  }
}
