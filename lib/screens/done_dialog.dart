import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_reminder/entity/medicine.dart';
import 'package:medical_reminder/entity/status.dart';
import 'package:medical_reminder/services/database.dart';

class DoneDilaog {
  BuildContext context;
  String payload;
  DoneDilaog(context, payload) {
    this.context = context;
    this.payload = payload;
  }

  openDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    $FloorAppDatabase
        .databaseBuilder('flutter_database.db')
        .build()
        .then((database) {
      var dao = database.medicineDao;
      var statusDao = database.statusDao;
      dao.findMedicineById(int.parse(payload)).then((Medicine medicine) {
        print("medicine.name" + "#################");
        showDialog(
            context: context,
            builder: (context) {
              // return object of type Dialog
              return AlertDialog(
                  contentPadding: EdgeInsets.all(2),
                  title: Center(
                    child: Text(
                      "Confirmation",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  content: Container(
                    margin: EdgeInsets.all(10),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("please confirm that \nyou take: " +
                              "medicine.name"),
                          Expanded(
                            child: Container(),
                          ),
                          Checkbox(
                            value: false,
                            checkColor: Colors.green,
                            onChanged: (value) {
                              var status =
                                  new Status(null, 1, int.parse(payload));
                              statusDao.insertStatus(status).then((onValue) {
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        ],
                      );
                    }),
                  ));
            });
      });
    });
  }
}
