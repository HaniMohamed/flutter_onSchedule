import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_trianglify/flutter_trianglify.dart';
import 'package:medical_reminder/services/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashcreenState();
}

class _SplashcreenState extends State<SplashScreen> {
  TextEditingController _textNameController = new TextEditingController();
  TextEditingController _textEmailController = new TextEditingController();
  bool isLogin = false;
  static const double BASE_SIZE = 320.0;

  final double expandedHeight = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  checkLogin() {
    SharedPrefs().getSharedEmail().then((email) {
      setState(() {
        if (email != null) {
          startTime();
          isLogin = true;
        } else {
          isLogin = false;
        }
      });
    });
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed("Main_SCREEN");
  }

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.shortestSide / BASE_SIZE;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            overflow: Overflow.visible,
            children: [
              Opacity(
                opacity: 0.15,
                child: Trianglify(
                  bleedX: 50,
                  bleedY: 50,
                  cellSize: 55,
                  gridWidth:
                      MediaQuery.of(context).size.width + (200 * scaleFactor),
                  gridHeight: MediaQuery.of(context).size.height,
                  isDrawStroke: true,
                  isFillTriangle: false,
                  isFillViewCompletely: false,
                  isRandomColoring: true,
                  generateOnlyColor: true,
                  typeGrid: Trianglify.GRID_RECTANGLE,
                  variance: 80,
                  palette: Palette.getPalette(Palette.BLUES),
                ),
              ),
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/icon.png",
                        width: 150,
                        height: 150,
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Text(
                          "On Schedule",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      )
                    ],
                  )),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: isLogin
                        ? Container()
                        : Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(5),
                            color: Colors.grey.withAlpha(60),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _textNameController,
                                  decoration: new InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blueGrey.shade100,
                                    hintText: 'Your name .. ',
                                    labelText: 'Name',
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.blueGrey,
                                    ),
                                    prefixText: ' ',
                                  ),
                                ),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _textEmailController,
                                  decoration: new InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blueGrey.shade100,
                                    hintText: 'Your email .. ',
                                    labelText: 'Email',
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.blueGrey,
                                    ),
                                    prefixText: ' ',
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  child: RaisedButton(
                                    color: Colors.blueGrey.shade600,
                                    onPressed: () {
                                      SharedPrefs().setSharedStringValue(
                                          "email", _textEmailController.text);
                                      SharedPrefs().setSharedStringValue(
                                          "name", _textNameController.text);
                                      navigationPage();
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
              ),
            ],
          ),
        ));
  }
}
