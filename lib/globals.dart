import 'package:hive/hive.dart';
import 'package:wemoove/models/Boarded.dart';

import 'models/Driven.dart';
import 'models/DriverDetail.dart';
import 'models/user.dart';

bool isDriverMode = false;
String baseUrl =
    "http://192.168.88.92:8001/api"; //"https://wemove.cnx247.com/api";
User user;
String token;
String otp;
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
