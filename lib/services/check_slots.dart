import 'dart:convert';
import 'user_simple_preferences.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'package:vaccine_helper/slots.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const myTask = "pushNotification";
TextEditingController dateinput = TextEditingController();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // String pinCodeText = UserSimplePreferences.getPincode() ?? "";
    // dateinput.text = UserSimplePreferences.getDate() ?? "";
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSetttings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flp.initialize(initSetttings);

    await http
        .get(Uri.parse(
            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                '400067' +
                '&date=' +
                '26' +
                '%2F' +
                '11' +
                '%2F2021'))
        .then(
      (value) {
        Map result = jsonDecode(value.body);
        if (result['sessions'].isNotEmpty) {
          String body = "";
          for (int i = 0; i < result['sessions'].length; i++) {
            body += (result['sessions'][i]['name'].toString() + ',\n');
          }
          NotificationService.showNotification(
              'Vaccination Slots Available at ' + body, flp);
          print('api working');
        } else {
          print('No message');
        }
      },
    );

    return Future.value(true);
  });
}

class NotificationService {
  static void showNotification(v, flp) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flp.show(
        0, 'Vaccination Slot Helper', '$v', platformChannelSpecifics);
  }

  static Future<void> initState() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    await Workmanager().registerPeriodicTask("5", myTask,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        frequency: Duration(minutes: 15),
        initialDelay: Duration(seconds: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ));
  }
}
