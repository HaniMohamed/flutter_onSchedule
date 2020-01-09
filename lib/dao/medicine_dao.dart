import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/medicine.dart';
import 'package:medical_reminder/entity/patient.dart';

@dao
abstract class MedicineDao {
// سحب جميع البيانات من جدول الادوية
  @Query('SELECT * FROM medicine')
  Future<List<Medicine>> findAllMedicine();

  @Query('SELECT * FROM medicine')
  Stream<List<Medicine>> findAllMedicineAsStream();

// البحث عن دواء في الجدول عن كريق رقمه
  @Query('SELECT * FROM medicine WHERE id = :id')
  Future<Medicine> findMedicineById(int id);

  @Query('SELECT * FROM medicine WHERE id = :id')
  Stream<Medicine> findMedicineByIdAsStream(int id);

// البحث عن الادوية الخاصة بمريض معين
  @Query('SELECT * FROM medicine WHERE patientID = :patientID')
  Stream<List<Medicine>> findMedicineByPatientIdAsStream(int patientID);

// البحث عن المريض صاحب دواء معين
  @Query(
      'SELECT * FROM patient p JOIN medicine m ON p.id = m.patientID WHERE m.id = :id')
  Future<Patient> findPatientByMedicineId(int id);

// إضافة دواء جديد
  @insert
  Future<int> insertMedicine(Medicine medicine);


// مسح دواء من الجدول
  @delete
  Future<void> deleteMedicine(Medicine medicine);
}
