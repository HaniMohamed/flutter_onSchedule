import 'package:floor/floor.dart';
import 'package:medical_reminder/entity/status.dart';

@dao
abstract class StatusDao {
  @Query('SELECT * FROM status')
  Future<List<Status>> findAllStatus();

  @Query('SELECT * FROM status')
  Stream<List<Status>> findAllStatusAsStream();

  @Query('SELECT * FROM status WHERE id = :id')
  Future<Status> findStatusById(int id);

  @insert
  Future<void> insertStatus(Status status);

  @delete
  Future<void> deletStatus(Status status);
}
