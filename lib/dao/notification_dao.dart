import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/notification.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM NotificationEntity')
  Future<List<NotificationEntity>> findAllNotification();

  @Query('SELECT * FROM NotificationEntity')
  Stream<List<NotificationEntity>> findAllNotificationAsStream();

  @Query('SELECT * FROM NotificationEntity WHERE targetID = :targetID')
  Stream<List<NotificationEntity>> findTargetAllNotificationAsStream(
      int targetID);

  @Query('SELECT * FROM NotificationEntity WHERE id = :id')
  Future<NotificationEntity> findNotificationById(int id);

  @Query('SELECT * FROM NotificationEntity WHERE targetID = :targetID')
  Future<List<NotificationEntity>> getTargetNotifications(int targetID);

  @Query(
      'SELECT * FROM NotificationEntity N LEFT JOIN Status S ON N.id = S.targetID WHERE S.targetID IS NULL')
  Future<List<NotificationEntity>> getAllNotificationsThatMissed();

  @insert
  Future<int> insertNotification(NotificationEntity notification);

  @delete
  Future<void> deletNotification(NotificationEntity notification);
}
