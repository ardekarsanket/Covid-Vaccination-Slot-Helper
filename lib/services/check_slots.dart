import 'dart:convert';
import 'user_simple_preferences.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'package:vaccine_helper/slots.dart';
import 'user_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const myTask = "pushNotification";
TextEditingController dateinput = TextEditingController();
FlutterLocalNotificationsPlugin? flp;
Map<String, dynamic>? pref;
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    flp = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSetttings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flp!.initialize(initSetttings);
    await Firebase.initializeApp();
    pref = await UserPref().getData();

    if (pref!['notif'] == true) {
      await http
          .get(Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
            pref!['pincode'] +
            '&date=' +
            pref!['day'] +
            '%2F' +
            pref!['month'] +
            '%2F' +
            pref!['year'],
      ))
          .then(
        (value) {
          Map result = jsonDecode(value.body);
          String body = "";
          if (result['sessions'].isNotEmpty) {
            if (result['sessions'].length == 1) {
              body = "Vaccination Slot Available at ";
            } else {
              body = "Vaccination Slots Available at ";
            }
            for (int i = 0; i < result['sessions'].length; i++) {
              if (i == result['sessions'].length - 1) {
                body += (result['sessions'][i]['name'].toString() + '\n');
              } else {
                body += (result['sessions'][i]['name'].toString() + ',\n');
              }
            }
            NotificationService.showNotification(body, flp);
          }
        },
      );
    }
    return Future.value(true);
  });
}

class NotificationService {
  static void showNotification(v, flp) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flp.show(
        0, 'Vaccination Slot Helper', '$v', platformChannelSpecifics);
  }

  static Future<void> initState() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    await Workmanager().registerPeriodicTask("5", myTask,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        frequency: Duration(minutes: 15),
        initialDelay: Duration(seconds: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ));
  }

  static Future<void> cancelNotifications() async {
    await flp!.cancelAll();
  }
}
