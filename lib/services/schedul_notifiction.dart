import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medical_reminder/entity/patient.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ScheduleNotification {
  BuildContext context;
  ScheduleNotification(context) {
    this.context = context;
  }

  Future<void> showNotification(i, targetID, title, body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'test', 'testingNotification', ' ',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(i, title, body, platformChannelSpecifics, payload: targetID);
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> scheduleNotification(
      id, title, body, time, sound, Patient patient, targetID) async {
    var scheduledNotificationDateTime = time;
    print(sound);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        patient.id.toString(), patient.name, '  ',
        sound: sound,
        importance: Importance.Default,
        priority: Priority.Default,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(sound: sound);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(id, title, body,
        scheduledNotificationDateTime, platformChannelSpecifics,
        payload: targetID.toString() + "-doctor");
  }

  Future<void> showDailyAtTime(
      id, title, body, DateTime time, sound, Patient patient, targetID) async {
    var scheduledNotificationDateTime =
        new Time(time.hour, time.minute, time.second);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        patient.id.toString(), patient.name, '  ',
        importance: Importance.Default,
        priority: Priority.Default,
        sound: sound);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(sound: sound);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(id, title, body,
        scheduledNotificationDateTime, platformChannelSpecifics,
        payload: targetID.toString() + "-medicine");
  }

  Future<void> checkPendingNotificationRequests() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var pendingNotificationRequest in pendingNotificationRequests) {
      print(
          'pending notification: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]');
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              '${pendingNotificationRequests.length} pending notification requests'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
