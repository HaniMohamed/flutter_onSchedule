import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medical_reminder/entity/patient.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_reminder/screens/appointments_page.dart';
import 'package:medical_reminder/screens/medicines_page.dart';

class PatientPage extends StatefulWidget {
  Patient patient;
  PatientPage(patient) {
    this.patient = patient;
  }
  @override
  State<StatefulWidget> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.patient.name,
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white.withAlpha(100),
          labelColor: Colors.white,
          tabs: [
            new Tab(
              icon: new Icon(MdiIcons.medicalBag),
              text: "Medication Schedule",
            ),
            new Tab(
              icon: new Icon(MdiIcons.doctor),
              text: "Medical Examination",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          MedicinePage(widget.patient),
          AppointmentPage(widget.patient),
        ],
        controller: _tabController,
      ),
    );
  }
}
