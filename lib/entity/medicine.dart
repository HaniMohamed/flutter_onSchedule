import 'package:floor/floor.dart';

@entity
class Medicine {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String time;
  final int patientID;
  final String notes;

  Medicine(this.id, this.name, this.time, this.patientID, this.notes);
}
