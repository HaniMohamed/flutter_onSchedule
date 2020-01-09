import 'package:floor/floor.dart';
 // عنصر اموعد الكشف
@entity
class Appointment {
// يحتوي على

// رقم الكشف وهو رقم مميز غير متكرر
  @PrimaryKey(autoGenerate: true)
  final int id;

// الاسم
  final String name;
// الموعد
  final String time;
// رقم المريض
  final int patientID;
// العنوان
  final String address;

  Appointment(this.id, this.name, this.time, this.patientID, this.address);
}
