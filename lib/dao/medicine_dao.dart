import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/medicine.dart';
import 'package:medical_reminder/entity/patient.dart';

@dao
abstract class MedicineDao {
  @Query('SELECT * FROM medicine')
  Future<List<Medicine>> findAllMedicine();

  @Query('SELECT * FROM medicine')
  Stream<List<Medicine>> findAllMedicineAsStream();

  @Query('SELECT * FROM medicine WHERE id = :id')
  Future<Medicine> findMedicineById(int id);

  @Query('SELECT * FROM medicine WHERE id = :id')
  Stream<Medicine> findMedicineByIdAsStream(int id);

  @Query('SELECT * FROM medicine WHERE patientID = :patientID')
  Stream<List<Medicine>> findMedicineByPatientIdAsStream(int patientID);

  @Query(
      'SELECT * FROM patient p JOIN medicine m ON p.id = m.patientID WHERE m.id = :id')
  Future<Patient> findPatientByMedicineId(int id);

  @insert
  Future<int> insertMedicine(Medicine medicine);

  @delete
  Future<void> deleteMedicine(Medicine medicine);
}
