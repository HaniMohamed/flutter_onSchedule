import 'package:floor/floor.dart';

@entity
class Status {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final int targetID;
  final int done;

  Status(this.id, this.done, this.targetID);
}
