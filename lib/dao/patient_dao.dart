import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/patient.dart';

// جدول خاص بالاشخاص المرضى
@dao
abstract class PatientDao {
// سحب بيانات المرضى
  @Query('SELECT * FROM patient')
  Future<List<Patient>> findAllPatient();

  @Query('SELECT * FROM patient')
  Stream<List<Patient>> findAllPatientsAsStream();

// البحث عن مريض عبر رقمه
  @Query('SELECT * FROM patient WHERE id = :id')
  Future<Patient> findPatientById(int id);

// إضافة مريض جديد
  @insert
  Future<int> insertPatient(Patient patient);

// مسح مريض من الجدول
  @delete
  Future<void> deletePatient(Patient patient);
}
