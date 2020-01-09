import 'package:floor/floor.dart';

// عنصر الدواء
@entity
class Medicine {
// يحتوي على 

// رقم المواء وهو رقم مميز غير متكرر
  @PrimaryKey(autoGenerate: true)
  final int id;
// الاسم
  final String name;
// الموعد
  final String time;
// رقم المريض
  final int patientID;
// ملاحظات
  final String notes;

  Medicine(this.id, this.name, this.time, this.patientID, this.notes);
}
