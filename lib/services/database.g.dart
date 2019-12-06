// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PatientDao _patientDaoInstance;

  AppointmentDao _appointmentDaoInstance;

  MedicineDao _medicineDaoInstance;

  StatusDao _statusDaoInstance;

  NotificationDao _notificationDaoInstance;

  MissedDao _missedDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Patient` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `tone` TEXT, `phone` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Appointment` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `time` TEXT, `patientID` INTEGER, `address` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Medicine` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `time` TEXT, `patientID` INTEGER, `notes` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Status` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `targetID` INTEGER, `done` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `NotificationEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `time` TEXT, `targetID` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Missed` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `time` TEXT, `targetID` INTEGER, `done` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  PatientDao get patientDao {
    return _patientDaoInstance ??= _$PatientDao(database, changeListener);
  }

  @override
  AppointmentDao get appointmentDao {
    return _appointmentDaoInstance ??=
        _$AppointmentDao(database, changeListener);
  }

  @override
  MedicineDao get medicineDao {
    return _medicineDaoInstance ??= _$MedicineDao(database, changeListener);
  }

  @override
  StatusDao get statusDao {
    return _statusDaoInstance ??= _$StatusDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }

  @override
  MissedDao get missedDao {
    return _missedDaoInstance ??= _$MissedDao(database, changeListener);
  }
}

class _$PatientDao extends PatientDao {
  _$PatientDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _patientInsertionAdapter = InsertionAdapter(
            database,
            'Patient',
            (Patient item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'tone': item.tone,
                  'phone': item.phone
                },
            changeListener),
        _patientDeletionAdapter = DeletionAdapter(
            database,
            'Patient',
            ['id'],
            (Patient item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'tone': item.tone,
                  'phone': item.phone
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _patientMapper = (Map<String, dynamic> row) => Patient(
      row['id'] as int,
      row['name'] as String,
      row['tone'] as String,
      row['phone'] as String);

  final InsertionAdapter<Patient> _patientInsertionAdapter;

  final DeletionAdapter<Patient> _patientDeletionAdapter;

  @override
  Future<List<Patient>> findAllPatient() async {
    return _queryAdapter.queryList('SELECT * FROM patient',
        mapper: _patientMapper);
  }

  @override
  Stream<List<Patient>> findAllPatientsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM patient',
        tableName: 'Patient', mapper: _patientMapper);
  }

  @override
  Future<Patient> findPatientById(int id) async {
    return _queryAdapter.query('SELECT * FROM patient WHERE id = ?',
        arguments: <dynamic>[id], mapper: _patientMapper);
  }

  @override
  Future<int> insertPatient(Patient patient) {
    return _patientInsertionAdapter.insertAndReturnId(
        patient, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deletePatient(Patient patient) async {
    await _patientDeletionAdapter.delete(patient);
  }
}

class _$AppointmentDao extends AppointmentDao {
  _$AppointmentDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _appointmentInsertionAdapter = InsertionAdapter(
            database,
            'Appointment',
            (Appointment item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'time': item.time,
                  'patientID': item.patientID,
                  'address': item.address
                },
            changeListener),
        _appointmentDeletionAdapter = DeletionAdapter(
            database,
            'Appointment',
            ['id'],
            (Appointment item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'time': item.time,
                  'patientID': item.patientID,
                  'address': item.address
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _appointmentMapper = (Map<String, dynamic> row) => Appointment(
      row['id'] as int,
      row['name'] as String,
      row['time'] as String,
      row['patientID'] as int,
      row['address'] as String);

  final InsertionAdapter<Appointment> _appointmentInsertionAdapter;

  final DeletionAdapter<Appointment> _appointmentDeletionAdapter;

  @override
  Future<List<Appointment>> findAllAppointment() async {
    return _queryAdapter.queryList('SELECT * FROM appointment',
        mapper: _appointmentMapper);
  }

  @override
  Stream<List<Appointment>> findAllAppointmentAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM appointment',
        tableName: 'Appointment', mapper: _appointmentMapper);
  }

  @override
  Future<Appointment> findAppointmentById(int id) async {
    return _queryAdapter.query('SELECT * FROM appointment WHERE id = ?',
        arguments: <dynamic>[id], mapper: _appointmentMapper);
  }

  @override
  Stream<List<Appointment>> findAppointmentByIdAsStream(int patientID) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM appointment WHERE patientID = ?',
        arguments: <dynamic>[patientID],
        tableName: 'Appointment',
        mapper: _appointmentMapper);
  }

  @override
  Future<int> insertAppointment(Appointment appointment) {
    return _appointmentInsertionAdapter.insertAndReturnId(
        appointment, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deletAppointment(Appointment appointment) async {
    await _appointmentDeletionAdapter.delete(appointment);
  }
}

class _$MedicineDao extends MedicineDao {
  _$MedicineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _medicineInsertionAdapter = InsertionAdapter(
            database,
            'Medicine',
            (Medicine item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'time': item.time,
                  'patientID': item.patientID,
                  'notes': item.notes
                },
            changeListener),
        _medicineDeletionAdapter = DeletionAdapter(
            database,
            'Medicine',
            ['id'],
            (Medicine item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'time': item.time,
                  'patientID': item.patientID,
                  'notes': item.notes
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _medicineMapper = (Map<String, dynamic> row) => Medicine(
      row['id'] as int,
      row['name'] as String,
      row['time'] as String,
      row['patientID'] as int,
      row['notes'] as String);

  static final _patientMapper = (Map<String, dynamic> row) => Patient(
      row['id'] as int,
      row['name'] as String,
      row['tone'] as String,
      row['phone'] as String);

  final InsertionAdapter<Medicine> _medicineInsertionAdapter;

  final DeletionAdapter<Medicine> _medicineDeletionAdapter;

  @override
  Future<List<Medicine>> findAllMedicine() async {
    return _queryAdapter.queryList('SELECT * FROM medicine',
        mapper: _medicineMapper);
  }

  @override
  Stream<List<Medicine>> findAllMedicineAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM medicine',
        tableName: 'Medicine', mapper: _medicineMapper);
  }

  @override
  Future<Medicine> findMedicineById(int id) async {
    return _queryAdapter.query('SELECT * FROM medicine WHERE id = ?',
        arguments: <dynamic>[id], mapper: _medicineMapper);
  }

  @override
  Stream<Medicine> findMedicineByIdAsStream(int id) {
    return _queryAdapter.queryStream('SELECT * FROM medicine WHERE id = ?',
        arguments: <dynamic>[id],
        tableName: 'Medicine',
        mapper: _medicineMapper);
  }

  @override
  Stream<List<Medicine>> findMedicineByPatientIdAsStream(int patientID) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM medicine WHERE patientID = ?',
        arguments: <dynamic>[patientID],
        tableName: 'Medicine',
        mapper: _medicineMapper);
  }

  @override
  Future<Patient> findPatientByMedicineId(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM patient p JOIN medicine m ON p.id = m.patientID WHERE m.id = ?',
        arguments: <dynamic>[id],
        mapper: _patientMapper);
  }

  @override
  Future<int> insertMedicine(Medicine medicine) {
    return _medicineInsertionAdapter.insertAndReturnId(
        medicine, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteMedicine(Medicine medicine) async {
    await _medicineDeletionAdapter.delete(medicine);
  }
}

class _$StatusDao extends StatusDao {
  _$StatusDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _statusInsertionAdapter = InsertionAdapter(
            database,
            'Status',
            (Status item) => <String, dynamic>{
                  'id': item.id,
                  'targetID': item.targetID,
                  'done': item.done
                },
            changeListener),
        _statusDeletionAdapter = DeletionAdapter(
            database,
            'Status',
            ['id'],
            (Status item) => <String, dynamic>{
                  'id': item.id,
                  'targetID': item.targetID,
                  'done': item.done
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _statusMapper = (Map<String, dynamic> row) =>
      Status(row['id'] as int, row['targetID'] as int, row['done'] as int);

  final InsertionAdapter<Status> _statusInsertionAdapter;

  final DeletionAdapter<Status> _statusDeletionAdapter;

  @override
  Future<List<Status>> findAllStatus() async {
    return _queryAdapter.queryList('SELECT * FROM status',
        mapper: _statusMapper);
  }

  @override
  Stream<List<Status>> findAllStatusAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM status',
        tableName: 'Status', mapper: _statusMapper);
  }

  @override
  Future<Status> findStatusById(int id) async {
    return _queryAdapter.query('SELECT * FROM status WHERE id = ?',
        arguments: <dynamic>[id], mapper: _statusMapper);
  }

  @override
  Future<void> insertStatus(Status status) async {
    await _statusInsertionAdapter.insert(
        status, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deletStatus(Status status) async {
    await _statusDeletionAdapter.delete(status);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _notificationEntityInsertionAdapter = InsertionAdapter(
            database,
            'NotificationEntity',
            (NotificationEntity item) => <String, dynamic>{
                  'id': item.id,
                  'time': item.time,
                  'targetID': item.targetID
                },
            changeListener),
        _notificationEntityDeletionAdapter = DeletionAdapter(
            database,
            'NotificationEntity',
            ['id'],
            (NotificationEntity item) => <String, dynamic>{
                  'id': item.id,
                  'time': item.time,
                  'targetID': item.targetID
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _notificationEntityMapper = (Map<String, dynamic> row) =>
      NotificationEntity(
          row['id'] as int, row['time'] as String, row['targetID'] as int);

  final InsertionAdapter<NotificationEntity>
      _notificationEntityInsertionAdapter;

  final DeletionAdapter<NotificationEntity> _notificationEntityDeletionAdapter;

  @override
  Future<List<NotificationEntity>> findAllNotification() async {
    return _queryAdapter.queryList('SELECT * FROM NotificationEntity',
        mapper: _notificationEntityMapper);
  }

  @override
  Stream<List<NotificationEntity>> findAllNotificationAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM NotificationEntity',
        tableName: 'NotificationEntity', mapper: _notificationEntityMapper);
  }

  @override
  Stream<List<NotificationEntity>> findTargetAllNotificationAsStream(
      int targetID) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM NotificationEntity WHERE targetID = ?',
        arguments: <dynamic>[targetID],
        tableName: 'NotificationEntity',
        mapper: _notificationEntityMapper);
  }

  @override
  Future<NotificationEntity> findNotificationById(int id) async {
    return _queryAdapter.query('SELECT * FROM NotificationEntity WHERE id = ?',
        arguments: <dynamic>[id], mapper: _notificationEntityMapper);
  }

  @override
  Future<List<NotificationEntity>> getTargetNotifications(int targetID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM NotificationEntity WHERE targetID = ?',
        arguments: <dynamic>[targetID],
        mapper: _notificationEntityMapper);
  }

  @override
  Future<List<NotificationEntity>> getAllNotificationsThatMissed() async {
    return _queryAdapter.queryList(
        'SELECT * FROM NotificationEntity N LEFT JOIN Status S ON N.id = S.targetID WHERE S.targetID IS NULL',
        mapper: _notificationEntityMapper);
  }

  @override
  Future<int> insertNotification(NotificationEntity notification) {
    return _notificationEntityInsertionAdapter.insertAndReturnId(
        notification, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deletNotification(NotificationEntity notification) async {
    await _notificationEntityDeletionAdapter.delete(notification);
  }
}

class _$MissedDao extends MissedDao {
  _$MissedDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _missedInsertionAdapter = InsertionAdapter(
            database,
            'Missed',
            (Missed item) => <String, dynamic>{
                  'id': item.id,
                  'time': item.time,
                  'targetID': item.targetID,
                  'done': item.done
                },
            changeListener),
        _missedDeletionAdapter = DeletionAdapter(
            database,
            'Missed',
            ['id'],
            (Missed item) => <String, dynamic>{
                  'id': item.id,
                  'time': item.time,
                  'targetID': item.targetID,
                  'done': item.done
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _missedMapper = (Map<String, dynamic> row) => Missed(
      row['id'] as int,
      row['time'] as int,
      row['targetID'] as String,
      row['done'] as int);

  static final _notificationEntityMapper = (Map<String, dynamic> row) =>
      NotificationEntity(
          row['id'] as int, row['time'] as String, row['targetID'] as int);

  final InsertionAdapter<Missed> _missedInsertionAdapter;

  final DeletionAdapter<Missed> _missedDeletionAdapter;

  @override
  Future<List<Missed>> findAllMissed() async {
    return _queryAdapter.queryList('SELECT * FROM missed',
        mapper: _missedMapper);
  }

  @override
  Stream<List<Missed>> findAllMissedAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM missed',
        tableName: 'Missed', mapper: _missedMapper);
  }

  @override
  Stream<List<Missed>> findAllMissedByTargetIDAsStream(int targetId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM missed WHERE targetId = ?',
        arguments: <dynamic>[targetId],
        tableName: 'Missed',
        mapper: _missedMapper);
  }

  @override
  Future<List<Missed>> findAllDublicatedMissedByTargetID(int targetId) async {
    return _queryAdapter.queryList('SELECT * FROM missed WHERE targetId = ?',
        arguments: <dynamic>[targetId], mapper: _missedMapper);
  }

  @override
  Future<List<NotificationEntity>> findAllfirstMissed() async {
    return _queryAdapter.queryList(
        'SELECT * FROM NotificationEntity n LEFT JOIN missed m ON n.id = m.targetID WHERE m.targetId IS NULL',
        mapper: _notificationEntityMapper);
  }

  @override
  Future<Missed> findMissedById(int id) async {
    return _queryAdapter.query('SELECT * FROM missed WHERE id = ?',
        arguments: <dynamic>[id], mapper: _missedMapper);
  }

  @override
  Future<void> insertMissed(Missed missed) async {
    await _missedInsertionAdapter.insert(
        missed, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deletMissed(Missed missed) async {
    await _missedDeletionAdapter.delete(missed);
  }
}
