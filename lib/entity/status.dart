import 'package:floor/floor.dart';

// عنصر حالة موعد الدواء
@entity
class Status {
// يحتوي على

// رقم الحالة وهو رقم مميز غير متكرر
  @PrimaryKey(autoGenerate: true)
  final int id;
// رقم الدواء
  final int targetID;
// حالته سواء تم اخده ام لا
  final int done;

  Status(this.id, this.done, this.targetID);
}
