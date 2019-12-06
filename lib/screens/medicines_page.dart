import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_tags/tag.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_reminder/dao/medicine_dao.dart';
import 'package:medical_reminder/dao/notification_dao.dart';
import 'package:medical_reminder/entity/medicine.dart';
import 'package:medical_reminder/entity/notification.dart';
import 'package:medical_reminder/entity/patient.dart';
import 'package:medical_reminder/services/schedul_notifiction.dart';

import 'package:medical_reminder/services/database.dart';

class MedicinePage extends StatefulWidget {
  Patient patient;

  MedicinePage(patient) {
    this.patient = patient;
  }
  @override
  State<StatefulWidget> createState() => _MedicinePage();
}

class _MedicinePage extends State<MedicinePage> {
  TextEditingController _textNameController, _textNotesController;

  String _numOfTimes = 'مرة واحدة';

  List<DateTime> medicineTimes = new List();

  var database, dao, notiDao;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _textNameController = TextEditingController();
    _textNotesController = TextEditingController();
  }

  Future<String> initDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
    dao = database.medicineDao;
    notiDao = database.notificationDao;
  }

  Widget futureListView() {
    return new FutureBuilder(
        future: initDatabase(),
        initialData: "Loading text..",
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Expanded(
            child: StreamBuilder<List<Medicine>>(
              stream: dao.findMedicineByPatientIdAsStream(widget.patient.id),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();

                final medicines = snapshot.data;

                return medicines.length < 1
                    ? Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add,
                                  size: 60, color: Colors.grey.shade500),
                              Text(
                                "No medicines added !!",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ]),
                      )
                    : ListView.builder(
                        itemCount: medicines.length,
                        itemBuilder: (_, index) {
                          return ListCell(
                            medicine: medicines[index],
                            dao: dao,
                            notiDao: notiDao,
                          );
                        },
                      );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(),
          futureListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              // return object of type Dialog
              return AlertDialog(
                contentPadding: EdgeInsets.all(2),
                title: Center(
                  child: Text(
                    "Add Medicine",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: dialogContent(context),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Done"),
                    onPressed: () async {
                      if (_textNameController.text.isNotEmpty) {
                        final database = await $FloorAppDatabase
                            .databaseBuilder('flutter_database.db')
                            .build();
                        final dao = database.medicineDao;
                        final notiDao = database.notificationDao;
                        final medicne = Medicine(
                            null,
                            _textNameController.text,
                            _numOfTimes,
                            widget.patient.id,
                            _textNotesController.text);

                        dao.insertMedicine(medicne).then((id) {
                          for (int i = 0; i < medicineTimes.length; i++) {
                            final notification = NotificationEntity(null,
                                medicineTimes.elementAt(i).toString(), id);
                            notiDao
                                .insertNotification(notification)
                                .then((notiID) {
                              ScheduleNotification(context).showDailyAtTime(
                                  notiID,
                                  widget.patient.name,
                                  "It's time to take your medicine: " +
                                      medicne.name,
                                  medicineTimes.elementAt(i),
                                  widget.patient.tone,
                                  widget.patient,
                                  id);
                            });
                          }
                        });
                        Navigator.of(context).pop();
                        setState(() {});
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget dialogContent(context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            controller: _textNameController,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Medicine\'s name .. ',
              labelText: 'Name',
              prefixIcon: const Icon(
                MdiIcons.pill,
                color: Colors.blueGrey,
              ),
              prefixText: ' ',
            ),
          ),
          Divider(),
          TextField(
            keyboardType: TextInputType.multiline,
            controller: _textNotesController,
            maxLines: null,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Doctor\'s notes .. ',
              labelText: 'Notes',
              prefixIcon: const Icon(
                Icons.note,
                color: Colors.blueGrey,
              ),
              prefixText: ' ',
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Daily Schedule:",
              textAlign: TextAlign.right,
            ),
          ),
          medicineTimes == null
              ? Container()
              : Tags(
                  itemCount: medicineTimes.length, // required
                  itemBuilder: (int index) {
                    final item = medicineTimes[index];

                    final formattedStr = formatDate(item, [HH, ':', nn, am]);
                    String itemStr = formattedStr.toString();
                    return ItemTags(
                      // Each ItemTags must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(index.toString()),
                      index: index, // required
                      title: itemStr,
                      textStyle: TextStyle(
                        fontSize: 14,
                      ),
                      combine: ItemTagsCombine.withTextBefore,
                      removeButton: ItemTagsRemoveButton(),
                      onRemoved: () {
                        // Remove the item from the data source.
                        setState(() {
                          // required
                          medicineTimes.removeAt(index);
                        });
                      },
                      onPressed: (item) => print(item),
                      onLongPressed: (item) => print(item),
                    );
                  },
                ),
          RaisedButton(
            onPressed: () {
              DatePicker.showTimePicker(context, showTitleActions: true,
                  onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                print('confirm $date');
                setState(() {
                  medicineTimes.add(date);
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            color: Colors.blue,
            child: Text(
              "Add time",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    });
  }
}

class ListCell extends StatefulWidget {
  const ListCell({
    Key key,
    @required this.medicine,
    @required this.dao,
    @required this.notiDao,
  }) : super(key: key);

  final Medicine medicine;
  final MedicineDao dao;
  final NotificationDao notiDao;

  @override
  _ListCellState createState() => _ListCellState();
}

class _ListCellState extends State<ListCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Dismissible(
        key: Key('${widget.medicine.hashCode}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              width: 60,
              height: 60,
              child: Center(
                  child: Icon(
                MdiIcons.pill,
                size: 40,
                color: Colors.blueGrey,
              )),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    widget.medicine.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                  ),
                  margin: EdgeInsets.only(bottom: 2),
                ),
                Container(
                  child: Text(
                    widget.medicine.notes,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  margin: EdgeInsets.only(bottom: 8),
                ),
                StreamBuilder<List<NotificationEntity>>(
                    stream: widget.notiDao
                        .findTargetAllNotificationAsStream(widget.medicine.id),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) return Container();
                      final notifis = snapshot.data;

                      return Container(
                        child: Tags(
                          columns: 3,
                          itemCount: notifis.length, // required
                          itemBuilder: (int index) {
                            final item = notifis[index];

                            final formattedStr = formatDate(
                                DateTime.parse(item.time),
                                [HH, ':', nn, ' ', am]);
                            String itemStr = formattedStr.toString();
                            return ItemTags(
                              // Each ItemTags must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                              key: Key(index.toString()),
                              index: index, // required
                              title: itemStr,
                              textStyle: TextStyle(
                                fontSize: 12,
                              ),
                              combine: ItemTagsCombine.withTextBefore,
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
        onDismissed: (_) async {
          List<NotificationEntity> notifications = new List();
          widget.notiDao
              .getTargetNotifications(widget.medicine.id)
              .then((notifis) {
            notifications = notifis;
            for (int i = 0; i < notifications.length; i++) {
              widget.notiDao.deletNotification(notifications.elementAt(i));
              ScheduleNotification(context)
                  .cancelNotification(notifications.elementAt(i).id);
            }
          });

          await widget.dao.deleteMedicine(widget.medicine);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text('medicine deleted ')),
          );
        },
      ),
    );
  }
}
