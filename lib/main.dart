import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medical_reminder/dao/patient_dao.dart';
import 'package:medical_reminder/screens/confirmation_screen.dart';
import 'package:medical_reminder/screens/home_page.dart';
import 'package:medical_reminder/screens/splash_screen.dart';
import 'package:medical_reminder/services/database.dart';
import 'package:medical_reminder/services/schedul_notifiction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

var dao;
String target;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// اول ملف يتم استدعائها عند بدء تشغيل التطبيق
void main() async {
// جزء خاص بسحب بيانات الاعطال
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

// تعريف الداتابيز المستخدمة
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  dao = database.patientDao;

  runZoned<Future<void>>(() {
    runApp(MyApp(dao));
  }, onError: Crashlytics.instance.recordError);

}

class MyApp extends StatelessWidget {
  final PatientDao dao;

  const MyApp(this.dao);

// تعريف الاشعارات 
  initNotificationService(context) async {
    WidgetsFlutterBinding.ensureInitialized();
    // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
    // change the default route of the app
    var notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        target = payload;
        debugPrint('notification payload: ' + payload);
        if (notificationAppLaunchDetails.didNotificationLaunchApp) {
          var _duration = new Duration(seconds: 4);
          return new Timer(_duration, navigationPage);
        }
      }
      selectNotificationSubject.add(payload);
    });
  }
// عند الضغط على الاشعارت يتم فتح صفحة تأكيد اخذ الدواء
  void navigationPage() {
    navigatorKey.currentState.push(
        MaterialPageRoute(builder: (context) => ConfirmationScreen(target)));
  }

  @override
  Widget build(BuildContext context) {

    initNotificationService(context);
    return MaterialApp(
      title: 'On Schedule', // اسم التطبيق
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (context) => new SplashScreen(), // فتح الصفحة الابتدائية
        "NOTIFICATION_SCREEN": (BuildContext context) =>
            new ConfirmationScreen(target),
        "Main_SCREEN": (BuildContext context) => MyHomePage(
              title: 'On Schedule',
              dao: dao,
            ),
      },
    );
  }
}
