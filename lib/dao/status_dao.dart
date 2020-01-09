import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/status.dart';

// جدول خاص بحالات الاشعارات سواء فائتة او لا
@dao
abstract class StatusDao {
// سحب حميع الحالات
  @Query('SELECT * FROM status')
  Future<List<Status>> findAllStatus();

  @Query('SELECT * FROM status')
  Stream<List<Status>> findAllStatusAsStream();

// البحث عن خالة معينه عن كريق رقمها
  @Query('SELECT * FROM status WHERE id = :id')
  Future<Status> findStatusById(int id);

// إضافة حالة جديدة
  @insert
  Future<void> insertStatus(Status status);

// مسح حالة من الجدول
  @delete
  Future<void> deletStatus(Status status);
}
