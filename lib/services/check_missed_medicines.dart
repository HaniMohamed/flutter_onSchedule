import 'package:flutter/cupertino.dart';
import 'package:medical_reminder/services/database.dart';
import 'package:medical_reminder/services/schedul_notifiction.dart';
import 'package:medical_reminder/services/smsSender.dart';

// الخدمة الخاصة بالكشف عن الإشعارات الفائتة
class CheckMissedNotifications {
  BuildContext context;

  CheckMissedNotifications(context) {
    this.context = context;
  }

  checkMissedNotifs() async {
// استدعاء الداتابيز وجداول الادوية والمواعيد الفائتة
    var database =
        await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
    var dao = database.notificationDao;
    var missedDao = database.missedDao;
    var medicineDao = database.medicineDao;
    
// في حالة تكرار عندم اخذ الدواء مرتين يتم ارسال رسالة للشخص المسؤول
    dao.getAllNotificationsThatMissed().then((missedList) {
      print("misseeddddd liissssstttttt " + missedList.length.toString());
      for (int i = 0; i < missedList.length; i++) {
        missedDao
            .findAllDublicatedMissedByTargetID(missedList.elementAt(i).id)
            .then((duplicatedMissed) {
          for (int i = 0; i < duplicatedMissed.length; i++) {
            medicineDao
                .findMedicineById(duplicatedMissed.elementAt(i).targetID)
                .then((medicone) {
              medicineDao
                  .findPatientByMedicineId(
                      duplicatedMissed.elementAt(i).targetID)
                  .then((patients) {
                SMSSender().sendSMS(
                    patients.phone,
                    "We are sorry for tolding you that\" " +
                        patients.name +
                        " \" didn't take his medicne (" +
                        medicone.name +
                        ")");
              });
            });
          }
        });
// اذا كان الموعد فائت لمرة واحظه يتم ارسال إشعار اخر
        missedDao.findAllfirstMissed().then((firstMissed) {
          for (int i = 0; i < firstMissed.length; i++) {
            medicineDao
                .findMedicineById(firstMissed.elementAt(i).targetID)
                .then((medicine) {
              ScheduleNotification(context).showNotification(
                  DateTime.now(),
                  firstMissed.elementAt(i).targetID,
                  "Second Reminder",
                  "You missed the first reminder to take you medicne " +
                      medicine.name);
            });
          }
        });
      }
    });
  }
}
