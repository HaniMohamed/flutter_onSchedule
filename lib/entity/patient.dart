import 'package:floor/floor.dart';

@entity
class Patient {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String tone;
  final String phone;

  Patient(this.id, this.name, this.tone, this.phone);
}
