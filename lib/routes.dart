import 'package:flutter/widgets.dart';
import 'package:wemoove/views/ReservationDetailScreen/ReservationDetailScreen.dart';
import 'package:wemoove/views/RideHistoryDetail/RideHistoryDetailScreen.dart';
import 'package:wemoove/views/booking/BookingScreen.dart';
import 'package:wemoove/views/initial/initialPage.dart';
import 'package:wemoove/views/otp/otp_screen.dart';
import 'package:wemoove/views/profile/ProfileScreen.dart';
import 'package:wemoove/views/reviews/ReviewScreen.dart';
import 'package:wemoove/views/ridehistory/RideHistoryScreen.dart';
import 'package:wemoove/views/search/SearchScreen.dart';
import 'package:wemoove/views/signin/SignInScreen.dart';
import 'package:wemoove/views/signup/SignUpScreen.dart';
import 'package:wemoove/views/splash/SplashScreen.dart';
import 'package:wemoove/views/success/SuccessScreen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
  BookingScreen.routeName: (context) => BookingScreen(),
  ReservationDetailScreen.routeName: (context) => ReservationDetailScreen(),
  SuccessScreen.routeName: (context) => SuccessScreen(),
  ReviewScreen.routeName: (context) => ReviewScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  RideHistoryScreen.routeName: (context) => RideHistoryScreen(),
  RideHistoryDetailScreen.routeName: (context) => RideHistoryDetailScreen(),
  InitialPage.routeName: (context) => InitialPage(),
};
