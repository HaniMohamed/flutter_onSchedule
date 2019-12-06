import 'package:floor/floor.dart';

@entity
class Missed {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String time;
  final int targetID;
  final int done;

  Missed(this.id, this.done, this.time, this.targetID);
}
