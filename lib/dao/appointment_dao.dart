import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/appointment.dart';

@dao
abstract class AppointmentDao {
  @Query('SELECT * FROM appointment')
  Future<List<Appointment>> findAllAppointment();

  @Query('SELECT * FROM appointment')
  Stream<List<Appointment>> findAllAppointmentAsStream();

  @Query('SELECT * FROM appointment WHERE id = :id')
  Future<Appointment> findAppointmentById(int id);

  @Query('SELECT * FROM appointment WHERE patientID = :patientID')
  Stream<List<Appointment>> findAppointmentByIdAsStream(int patientID);

  @insert
  Future<int> insertAppointment(Appointment appointment);

  @delete
  Future<void> deletAppointment(Appointment appointment);
}
