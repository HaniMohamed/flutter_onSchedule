import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_reminder/dao/patient_dao.dart';
import 'package:medical_reminder/entity/patient.dart';
import 'package:medical_reminder/screens/patient_page.dart';
import 'package:medical_reminder/screens/rating_page.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final PatientDao dao;
  final TextEditingController _textNameController, _textPhoneController;

  MyHomePage({
    Key key,
    @required this.title,
    @required this.dao,
  })  : _textNameController = TextEditingController(),
        _textPhoneController = TextEditingController(),
        super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File file;
  String _fileName = "Choose alarm tone";
  bool playing = false;
  bool audiSelected = false;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.contacts,
      PermissionGroup.sms,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Icon(MdiIcons.calendarAlert),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.rate_review, color: Colors.white),
            onPressed: () {
              Crashlytics.instance.crash();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RatingPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Patients:",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Patient>>(
              stream: widget.dao.findAllPatientsAsStream(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();

                final patients = snapshot.data;

                return patients.length < 1
                    ? Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_add,
                                  size: 60, color: Colors.grey.shade500),
                              Text(
                                "No patients added !!",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ]),
                      )
                    : ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (_, index) {
                          return ListCell(
                            patinet: patients[index],
                            dao: widget.dao,
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                contentPadding: EdgeInsets.all(2),
                title: Center(
                  child: Text(
                    "Add new Person",
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
                      if (widget._textPhoneController.text.isNotEmpty ||
                          widget._textNameController.text.isNotEmpty ||
                          audiSelected) {
                        final patient = Patient(
                            null,
                            widget._textNameController.text,
                            _fileName,
                            widget._textPhoneController.text);
                        await widget.dao.insertPatient(patient);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  Widget dialogContent(context) {
    return StatefulBuilder(// You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            controller: widget._textNameController,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Patient\'s name .. ',
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
            keyboardType: TextInputType.phone,
            controller: widget._textPhoneController,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'ex: 01xxxxxxxxx',
              labelText: 'Caregivers Phone',
              prefixIcon: const Icon(
                Icons.phone,
                color: Colors.blueGrey,
              ),
              prefixText: ' ',
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              new DropdownButton<String>(
                hint: Text(_fileName),
                items: <String>[
                  'alarm_alarm',
                  'alarm_clock_2010',
                  'alarm_clock_2015',
                  'alarm_loud',
                  'alarm_loving_you',
                  'alarm_sound'
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    audiSelected = true;
                    _fileName = value;
                  });
                },
              ),
              Spacer(),
              RaisedButton(
                onPressed: () {
                  if (audiSelected) {
                    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
                    _assetsAudioPlayer.open(
                      AssetsAudio(
                        asset: _fileName + ".mp3",
                        folder: "assets/",
                      ),
                    );
                    if (playing) {
                      _assetsAudioPlayer.stop();
                      playing = !playing;
                    } else {
                      _assetsAudioPlayer.play();
                      playing = !playing;
                    }
                    setState(() {});
                  }
                },
                child: playing ? Icon(Icons.stop) : Icon(Icons.play_arrow),
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
    @required this.patinet,
    @required this.dao,
  }) : super(key: key);

  final Patient patinet;
  final PatientDao dao;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientPage(patinet)),
        );
      },
      child: Dismissible(
        key: Key('${patinet.hashCode}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              width: 50,
              height: 50,
              child: Center(
                child: Text(
                  patinet.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            ),
            Text(
              patinet.name,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        onDismissed: (_) async {
          await dao.deletePatient(patinet);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text('person deleted')),
          );
        },
      ),
    );
  }
}
