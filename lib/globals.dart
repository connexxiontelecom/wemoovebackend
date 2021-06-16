import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:wemoove/controllers/ReservationController.dart';
import 'package:wemoove/controllers/RideRequestsController.dart';
import 'package:wemoove/models/Boarded.dart';

import 'models/Driven.dart';
import 'models/DriverDetail.dart';
import 'models/WalletBalance.dart';
import 'models/user.dart';

bool isDriverMode = false;
final numFormatter = new NumberFormat("#,##0.00", "en_US");
String baseUrl = "https://wemove.cnx247.com/api";
//"http://192.168.88.108:8001/api"; //"https://wemove.cnx247.com/api";
//"https://wemove.cnx247.com/api"; //"http://192.168.88.108:8001/api";
User user;
String token;
String otp;
String code;
int postedRide;
String googleApiKey = "AIzaSyDAHdeQbSuLtDdpfhueU392zOUW6KAjGlA";
double lat;
double lng;
String currentPlaceId;
String devicetoken;
DriverDetails details;
Box box;
List<Driven> drivens = [];
List<Boarded> boarded = [];
double Balance = 0.0;
double percentage = 5.0;
List<WalletHistory> walletHistories = [];

String currentPhoneNumber = "";

CubeUser currentUser;

/*PushNotificationsManager pushNotificationsManager =
    PushNotificationsManager.instance.init();*/

const MethodChannel platform = MethodChannel('dexterx.dev/wemoove');
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
RideRequestController rideRequestController; // = RideRequestController();
ReservationController reservationController; // = ReservationController();
