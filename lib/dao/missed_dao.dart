import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/missed.dart';
import 'package:medical_reminder/entity/notification.dart';

@dao
abstract class MissedDao {
// سحب جميع بيانات حدول الادوية الفائتة
  @Query('SELECT * FROM missed')
  Future<List<Missed>> findAllMissed();

  @Query('SELECT * FROM missed')
  Stream<List<Missed>> findAllMissedAsStream();

// البحث عن دواء معين في جدول المواعيد الفائتة
  @Query('SELECT * FROM missed WHERE targetId = :targetId')
  Stream<List<Missed>> findAllMissedByTargetIDAsStream(int targetId);

// سحب بيانات الادوية الفائتة مرتين متتالتين
  @Query('SELECT * FROM missed WHERE targetId = :targetId')
  Future<List<Missed>> findAllDublicatedMissedByTargetID(int targetId);

// سحب بيانات الادوية التي الفائتة مرة واحدة
  @Query(
      'SELECT * FROM NotificationEntity n LEFT JOIN missed m ON n.id = m.targetID WHERE m.targetId IS NULL')
  Future<List<NotificationEntity>> findAllfirstMissed();

// البحث عن موعد دواء فائت عن طريق رقمه
  @Query('SELECT * FROM missed WHERE id = :id')
  Future<Missed> findMissedById(int id);

// إضافة موعد فائت جديد
  @insert
  Future<void> insertMissed(Missed missed);

// مسح موعد فائت
  @delete
  Future<void> deletMissed(Missed missed);
}
