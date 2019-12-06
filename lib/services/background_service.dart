// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:medical_reminder/services/check_missed_medicines.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:workmanager/workmanager.dart';

// const simpleTaskKey = "simpleTask";
// const simpleDelayedTask = "simpleDelayedTask";
// const simplePeriodicTask = "simplePeriodicTask";
// const simplePeriodic1HourTask = "simplePeriodic1HourTask";

// BuildContext buildContext;

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) async {
//     switch (task) {
//       case simpleTaskKey:
//         print("$simpleTaskKey was executed. inputData = $inputData");
//         Directory tempDir = await getTemporaryDirectory();
//         String tempPath = tempDir.path;
//         print(
//             "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
//         break;
//       case simpleDelayedTask:
//         print("$simpleDelayedTask was executed");
//         break;
//       case simplePeriodicTask:
//         print("$simplePeriodicTask was executed");
//         break;
//       case simplePeriodic1HourTask:
//         CheckMissedNotifications(buildContext).checkMissedNotifs();
//         print("$simplePeriodic1HourTask was executed");
//         break;
//       case Workmanager.iOSBackgroundTask:
//         print("The iOS background fetch was triggered");
//         Directory tempDir = await getTemporaryDirectory();
//         String tempPath = tempDir.path;
//         print(
//             "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
//         break;
//     }

//     return Future.value(true);
//   });
// }

// class BackgroundService {
//   BackgroundService(context) {
//     buildContext = context;
//     Workmanager.initialize(
//       callbackDispatcher,
//       isInDebugMode: false,
//     );
//   }

//   periodicTask() {
//     Workmanager.registerPeriodicTask(
//       "uniquName",
//       simplePeriodic1HourTask,
//       initialDelay: Duration(seconds: 10),
//       frequency: Duration(hours: 1),
//     );
//   }
// }
