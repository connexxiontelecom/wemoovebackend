import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:wemoove/globals.dart' as globals;

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
}

class ScheduleAlarm {
  ScheduleAlarm() {
    init();
  }

  void init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await globals.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);
    await configureLocalTimeZone();
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      // debugPrint('notification payload: $payload');
    }
  }

  dynamic convertDatetimeToTimeZone(DateTime scheduledNotificationDateTime) {
    var time = tz.TZDateTime.from(
      scheduledNotificationDateTime,
      tz.local,
    );
    return time;
  }

  DateTime convertTime(String time) {
    TimeOfDay _time = timeConvert(time);
    DateTime date_time = converToDateTime(_time);
    return date_time;
  }

//converts normal time e.g 12:03 am to timeofday
  TimeOfDay timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  DateTime converToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return dt;
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName =
        await globals.platform.invokeMethod<String>('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime nextInstanceOfTime(DateTime time) {
    print(time.hour.toString() + "" + time.minute.toString());
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = now.add(const Duration(minutes: 30));
    }
    return scheduledDate;
  }

  Future<void> zonedScheduleNotification(int id, String time) async {
    DateTime t = DateFormat.jm().parse(time);
    var insistentFlag = 4;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'reminder', 'reminder channel', 'reminder channel',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        sound: RawResourceAndroidNotificationSound('car_horn'),
        additionalFlags: Int32List.fromList([insistentFlag]));

    await globals.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Ride Reminder',
        'You have a Pending Ride',
        //convertDatetimeToTimeZone(converToDateTime(time)),
        // nextInstanceOfTime(convertTime(time)),DateFormat.jm().parse("6:45 PM")
        nextInstanceOfTime(t),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        NotificationDetails(android: androidPlatformChannelSpecifics),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
} //end of class
