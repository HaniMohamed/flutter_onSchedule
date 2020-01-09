import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/appointment.dart';

// جدول هاص بمواعيد الكشوفات
@dao
abstract class AppointmentDao {
//  سحب جميع البيانات من جدول مواعيد الكشوفات
  @Query('SELECT * FROM appointment')
  Future<List<Appointment>> findAllAppointment();

  @Query('SELECT * FROM appointment')
  Stream<List<Appointment>> findAllAppointmentAsStream();

// البحث عن موعد كشف عن طريق رقمه
  @Query('SELECT * FROM appointment WHERE id = :id')
  Future<Appointment> findAppointmentById(int id);

  @Query('SELECT * FROM appointment WHERE patientID = :patientID')
  Stream<List<Appointment>> findAppointmentByIdAsStream(int patientID);

// إضافة موعد كشف جديد
  @insert
  Future<int> insertAppointment(Appointment appointment);

// حذف موعد كشف
  @delete
  Future<void> deletAppointment(Appointment appointment);
}
