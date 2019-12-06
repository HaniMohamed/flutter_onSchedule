import 'package:floor/floor.dart';

@entity
class NotificationEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String time;
  final int targetID;

  NotificationEntity(this.id, this.time, this.targetID);
}
