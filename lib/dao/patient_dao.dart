import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/patient.dart';

@dao
abstract class PatientDao {
  @Query('SELECT * FROM patient')
  Future<List<Patient>> findAllPatient();

  @Query('SELECT * FROM patient')
  Stream<List<Patient>> findAllPatientsAsStream();

  @Query('SELECT * FROM patient WHERE id = :id')
  Future<Patient> findPatientById(int id);

  @insert
  Future<int> insertPatient(Patient patient);

  @delete
  Future<void> deletePatient(Patient patient);
}
