import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_reminder/dao/appointment_dao.dart';
import 'package:medical_reminder/dao/notification_dao.dart';
import 'package:medical_reminder/entity/appointment.dart';
import 'package:medical_reminder/entity/notification.dart';
import 'package:medical_reminder/entity/patient.dart';
import 'package:medical_reminder/main.dart';
import 'package:medical_reminder/services/database.dart';
import 'package:medical_reminder/services/schedul_notifiction.dart';

class AppointmentPage extends StatefulWidget {
  Patient patient;
  AppointmentPage(patient) {
    this.patient = patient;
  }
  @override
  State<StatefulWidget> createState() => _AppointmentPage();
}

class _AppointmentPage extends State<AppointmentPage> {
  TextEditingController _textNameController, _textAddressController;

  String time = "not selected";

  DateTime datetime;

  var database, dao, notiDao;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _textNameController = TextEditingController();
    _textAddressController = TextEditingController();
  }

  Future<String> initDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
    dao = database.appointmentDao;
    notiDao = database.notificationDao;
  }

  Widget futureListView() {
    return new FutureBuilder(
        future: initDatabase(),
        initialData: "Loading text..",
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: dao.findAppointmentByIdAsStream(widget.patient.id),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();

                final appointments = snapshot.data;

                return appointments.length < 1
                    ? Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add,
                                  size: 60, color: Colors.grey.shade500),
                              Text(
                                "No appointments added !!",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ]),
                      )
                    : ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (_, index) {
                          return ListCell(
                            appointment: appointments[index],
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
                    "Add new medical exam",
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
                      if (_textNameController.text.isNotEmpty ||
                          _textAddressController.text.isNotEmpty) {
                        final database = await $FloorAppDatabase
                            .databaseBuilder('flutter_database.db')
                            .build();
                        final dao = database.appointmentDao;

                        final appointment = Appointment(
                            null,
                            _textNameController.text,
                            time,
                            widget.patient.id,
                            _textAddressController.text);

                        dao.insertAppointment(appointment).then((id) {
                          print("appointment inserted");
                          final notification =
                              NotificationEntity(null, time, id);
                          database.notificationDao
                              .insertNotification(notification)
                              .then((notiID) {
                            print("noti inserted");
                            ScheduleNotification(context).scheduleNotification(
                                notiID,
                                widget.patient.name,
                                "You have medical examination with Dr. " +
                                    _textNameController.text,
                                datetime,
                                widget.patient.tone,
                                widget.patient,
                                id);
                          });

                          Navigator.of(context).pop();
                          setState(() {});
                        });
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
              hintText: 'Doctor\'s name .. ',
              labelText: 'Name',
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
              prefixText: ' ',
            ),
          ),
          Divider(),
          TextField(
            keyboardType: TextInputType.text,
            controller: _textAddressController,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Doctor\'s address .. ',
              labelText: 'Address',
              prefixIcon: const Icon(
                Icons.location_on,
                color: Colors.blueGrey,
              ),
              prefixText: ' ',
            ),
          ),
          Divider(),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2060, 6, 7), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        datetime = date;
                        final formattedStr = formatDate(date,
                            [dd, '-', mm, '-', yyyy, '   ', HH, ':', nn, am]);
                        time = formattedStr.toString();
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    "Time select",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          )
        ],
      );
    });
  }
}

class ListCell extends StatelessWidget {
  const ListCell({
    Key key,
    @required this.appointment,
    @required this.dao,
    @required this.notiDao,
  }) : super(key: key);

  final Appointment appointment;
  final AppointmentDao dao;
  final NotificationDao notiDao;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Dismissible(
        key: Key('${appointment.hashCode}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              width: 60,
              height: 60,
              child: Center(
                  child: Icon(
                MdiIcons.doctor,
                size: 40,
                color: Colors.blueGrey,
              )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        appointment.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                          child: Icon(Icons.access_time,
                              color: Colors.grey, size: 20),
                          margin: EdgeInsets.only(left: 5, right: 2)),
                      Text(
                        appointment.time,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 5),
                ),
                Text(
                  appointment.address,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
        onDismissed: (_) async {
          List<NotificationEntity> notifications = new List();
          notiDao.getTargetNotifications(appointment.id).then((notifis) {
            notifications = notifis;
            for (int i = 0; i < notifications.length; i++) {
              notiDao.deletNotification(notifications.elementAt(i));
              ScheduleNotification(context)
                  .cancelNotification(notifications.elementAt(i).id);
            }
          });
          await dao.deletAppointment(appointment);

          Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text('appoitnment deleted ')),
          );
        },
      ),
    );
  }
}
