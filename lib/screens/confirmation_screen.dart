import 'package:flutter/material.dart';
import 'package:medical_reminder/dao/medicine_dao.dart';
import 'package:medical_reminder/dao/status_dao.dart';
import 'package:medical_reminder/entity/medicine.dart';
import 'package:medical_reminder/entity/status.dart';
import 'package:medical_reminder/services/database.dart';

class ConfirmationScreen extends StatefulWidget {
  ConfirmationScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  var database;
  StatusDao statusDao;
  MedicineDao medicineDao;

  @override
  void initState() {
    super.initState();
    String targetType = widget.payload
        .substring(widget.payload.indexOf("-") + 1, widget.payload.length);
    print(">>>>>>>>>" + targetType + "<<<<<<<<<<<<");
    if (targetType == "doctor") {
      Navigator.of(context).pop();
    }
  }

  Future<String> initDatabase() {
    $FloorAppDatabase
        .databaseBuilder('flutter_database.db')
        .build()
        .then((database) {
      statusDao = database.statusDao;
      medicineDao = database.medicineDao;
    });
  }

  Widget futureWidget() {
    return new FutureBuilder(
        future: initDatabase(),
        initialData: "Loading text..",
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Expanded(
              child: StreamBuilder<Medicine>(
                  stream: medicineDao
                      .findMedicineByIdAsStream(int.parse(widget.payload)),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) return Container();
                    print("################## " + snapshot.data.toString());
                    final medicine = snapshot.data;

                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("please confirm that \nyou take: " +
                              medicine.name),
                          Expanded(
                            child: Container(),
                          ),
                          Checkbox(
                            value: false,
                            checkColor: Colors.green,
                            onChanged: (value) {
                              var status = new Status(
                                  null, 1, int.parse(widget.payload));
                              statusDao.insertStatus(status).then((onValue) {
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        ],
                      ),
                    );
                  }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(" "),
          ),
          futureWidget(),
          // Text("asdsdasdasdasdasdasdasdasdasdasdasda sdasd asd")
        ],
      ),
    );
  }
}
