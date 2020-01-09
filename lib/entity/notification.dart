import 'package:floor/floor.dart';

// عنصر الإشعار
@entity
class NotificationEntity {
// يحتوي على 

// رقم الاشعار وهو رقم مميز غير متكرر
  @PrimaryKey(autoGenerate: true)
  final int id;
// الاسم
  final String time;
// رقم الدواء او الكشف 
  final int targetID;

  NotificationEntity(this.id, this.time, this.targetID);
}
