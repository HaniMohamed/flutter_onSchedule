import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/missed.dart';
import 'package:medical_reminder/entity/notification.dart';

@dao
abstract class MissedDao {
  @Query('SELECT * FROM missed')
  Future<List<Missed>> findAllMissed();

  @Query('SELECT * FROM missed')
  Stream<List<Missed>> findAllMissedAsStream();

  @Query('SELECT * FROM missed WHERE targetId = :targetId')
  Stream<List<Missed>> findAllMissedByTargetIDAsStream(int targetId);

  @Query('SELECT * FROM missed WHERE targetId = :targetId')
  Future<List<Missed>> findAllDublicatedMissedByTargetID(int targetId);

  @Query(
      'SELECT * FROM NotificationEntity n LEFT JOIN missed m ON n.id = m.targetID WHERE m.targetId IS NULL')
  Future<List<NotificationEntity>> findAllfirstMissed();

  @Query('SELECT * FROM missed WHERE id = :id')
  Future<Missed> findMissedById(int id);

  @insert
  Future<void> insertMissed(Missed missed);

  @delete
  Future<void> deletMissed(Missed missed);
}
