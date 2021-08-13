//import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:wemoove/controllers/ReservationController.dart';
import 'package:wemoove/controllers/RideRequestsController.dart';
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/PayOut.dart';
import 'package:wemoove/models/PolicyConfig.dart';
import 'package:wemoove/models/callToken.dart';

import 'controllers/CallController.dart';
import 'models/Account.dart';
import 'models/Bank.dart';
import 'models/Driven.dart';
import 'models/DriverDetail.dart';
import 'models/WalletBalance.dart';
import 'models/user.dart';

bool isDriverMode = false;
final numFormatter = new NumberFormat("#,##0.00", "en_US");
String baseUrl =
    "http://192.168.88.108:8001/api"; //"https://wemove.cnx247.com/api";
//"http://192.168.43.46:8001/api"; // "https://wemove.cnx247.com/api";
//"http://192.168.88.108:8001/api"; //"https://wemove.cnx247.com/api";
//"https://wemove.cnx247.com/api"; //"http://192.168.88.108:8001/api";

User user;
String token;
String otp;
String code;
String countryCode = 'ng';
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
List<Bank> banks = [];
List<PayOut> payouts = [];
String currentPhoneNumber = "";
//CubeUser currentUser;
BuildContext context;
PolicyConfig config;
callToken calltoken;
Account account;
/*PushNotificationsManager pushNotificationsManager =
    PushNotificationsManager.instance.init();*/

const MethodChannel platform = MethodChannel('dexterx.dev/wemoove');
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
RideRequestController rideRequestController; // = RideRequestController();
ReservationController reservationController; // = ReservationController();
String wemooveCallApiKeyAbly = "i0INng.ktHaSg:lTxCW727CpiaTtbL";
CallController callController = new CallController();
