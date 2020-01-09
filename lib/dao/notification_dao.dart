import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/notification.dart';

@dao
abstract class NotificationDao {
// سحب جميع بيانات الاشعارات 
  @Query('SELECT * FROM NotificationEntity')
  Future<List<NotificationEntity>> findAllNotification();

  @Query('SELECT * FROM NotificationEntity')
  Stream<List<NotificationEntity>> findAllNotificationAsStream();

// البحث عن إشعار خاص بدواء معين او موعد كشف معين
  @Query('SELECT * FROM NotificationEntity WHERE targetID = :targetID')
  Stream<List<NotificationEntity>> findTargetAllNotificationAsStream(
      int targetID);

  @Query('SELECT * FROM NotificationEntity WHERE targetID = :targetID')
  Future<List<NotificationEntity>> getTargetNotifications(int targetID);


// البحث عن إشعار معين عن طريق رقمه
  @Query('SELECT * FROM NotificationEntity WHERE id = :id')
  Future<NotificationEntity> findNotificationById(int id);

// البحث عن الاشعارات الفائتة
  @Query(
      'SELECT * FROM NotificationEntity N LEFT JOIN Status S ON N.id = S.targetID WHERE S.targetID IS NULL')
  Future<List<NotificationEntity>> getAllNotificationsThatMissed();

// إضافة إشعار جديد
  @insert
  Future<int> insertNotification(NotificationEntity notification);

// مسح إشعار من الجدول
  @delete
  Future<void> deletNotification(NotificationEntity notification);
}
