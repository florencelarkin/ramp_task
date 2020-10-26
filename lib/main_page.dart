import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{

  AnimationController _timerController;

  void initState() {
    super.initState();
    _carController = AnimationController(duration: const Duration(seconds: 10),
        vsync: this)..repeat();
    _timerController = AnimationController(duration: Duration(seconds: 10),
        vsync: this);
    _timerController.forward();
  }


  AnimationController _carController;
  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 10.0;
  double dy = 0.0;
  Color timerColor = Colors.blue;

  String get timerString {
    Duration duration = _timerController.duration * _timerController.value;
    print(_timerController.value);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double getPos (joyStick, currentPos) {
      dy = ((-.35*currentPos)+(-joyStick*50.0))*0.033;
      getCurrentPos = dy + currentPos;
      dy = ((-.35*getCurrentPos)+(-joyStick*50.0))*0.033;
    return dy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driving Task'),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/graphic_design_is_my_passion.png"),
            fit: BoxFit.cover,
          ),
        ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AnimatedBuilder(
                animation: _timerController,
                builder: (BuildContext context, Widget child) {
                  return Container(
                    color: timerColor,
                    height: _timerController.value * MediaQuery.of(context).size.height,
                    width: 50.0,
                  );
                },
              ),
              Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height:150.0),
                AnimatedBuilder(
                  animation: _carController,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.black,
                    child: Icon(Icons.directions_car, size: 50),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform.translate(
                      offset: Offset(0.0, getCurrentPos),
                      child: child,
                    );
                  },
                ),
                Container(
                  height: 100.0,
                  width: 300.0,
                  child: Transform.scale(
                    scale: 0.25,
                    child: Transform.rotate(
                      angle: pi/2,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 30.0,
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white,
                        ),
                        child: Slider(
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                          value: joyStickPos,
                          min: -100.0,
                          max: 100.0,
                          onChanged: (double newValue) {
                            setState(() {
                              joyStickPos = newValue / 100;
                              print(getCurrentPos);
                              dy = ((-.2*getCurrentPos)+(joyStickPos*50.0))*0.033;
                              getCurrentPos = dy + getCurrentPos;
                              if (getCurrentPos < -80) {
                                timerColor = Colors.green;
                              }
                              else {
                                timerColor = Colors.blue;
                              }
                            });
                          },
                          onChangeEnd: (double newValue) {
                            setState(() {
                              newValue = 0;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),],

          ),
      ),
    );
  }
}
