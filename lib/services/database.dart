import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:medical_reminder/dao/patient_dao.dart';
import 'package:medical_reminder/dao/appointment_dao.dart';
import 'package:medical_reminder/dao/medicine_dao.dart';
import 'package:medical_reminder/dao/status_dao.dart';
import 'package:medical_reminder/dao/notification_dao.dart';
import 'package:medical_reminder/dao/missed_dao.dart';

import 'package:medical_reminder/entity/patient.dart';
import 'package:medical_reminder/entity/appointment.dart';
import 'package:medical_reminder/entity/medicine.dart';
import 'package:medical_reminder/entity/status.dart';
import 'package:medical_reminder/entity/notification.dart';
import 'package:medical_reminder/entity/missed.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  Patient,
  Appointment,
  Medicine,
  Status,
  NotificationEntity,
  Missed
])
abstract class AppDatabase extends FloorDatabase {
  PatientDao get patientDao;
  AppointmentDao get appointmentDao;
  MedicineDao get medicineDao;
  StatusDao get statusDao;
  NotificationDao get notificationDao;
  MissedDao get missedDao;
}
