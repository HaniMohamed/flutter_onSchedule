import 'package:floor/floor.dart';

// عنصر الموعد الفائت
@entity
class Missed {
// يحتوي على

// رقم الموعد الفائت وهو رقم مميز غير متكرر
  @PrimaryKey(autoGenerate: true)
  final int id;
// الموعد
  final String time;
// رقم الدواء الفائت
  final int targetID;
// حالته سواء تم اخذه ام مازال فائت
  final int done;

  Missed(this.id, this.done, this.time, this.targetID);
}
