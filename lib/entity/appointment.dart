import 'package:floor/floor.dart';

@entity
class Appointment {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String time;
  final int patientID;
  final String address;

  Appointment(this.id, this.name, this.time, this.patientID, this.address);
}
