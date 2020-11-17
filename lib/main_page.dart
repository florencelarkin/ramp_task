import 'package:driving_task/continue_trial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'car_engine.dart';

CarEngine carEngine = CarEngine();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{

  AnimationController _timerController;
  AnimationController _carController;
  AnimationController _countdownController;

  void initState() {
    super.initState();
    _countdownController = AnimationController(duration: Duration(seconds: 4),
        vsync: this);
    _countdownController.forward();
    _countdownController.reverse(from: _countdownController.value == 0.0 ? 1.0 : _countdownController.value);


    _carController = AnimationController(duration: const Duration(seconds: 10),
        vsync: this)..repeat();
    _timerController = AnimationController(duration: Duration(seconds: 14),
        vsync: this);
    _timerController.forward();
    Timer(Duration(seconds: 14), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ContinuationPage(),),);
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
    });
  }

  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 10.0;
  double dy = 0.0;
  Color timerColor = Colors.blue;

  String get timerString {
    Duration duration = _countdownController.duration * _countdownController.value;
    return '${(duration.inSeconds % 60).toString()}';
  }

  Color get countdownColor {
    Duration duration = _countdownController.duration * _countdownController.value;
    if (duration.inSeconds > 0) {
      return Colors.white;
    }
    else {
      return Colors.black;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driving Task'),),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AnimatedBuilder(
                //add if statement to make timer not start for 4 seconds
                animation: _timerController,
                builder: (BuildContext context, Widget child) {
                  return Container(
                    color: timerColor,
                    height: timerString == '0' ? _timerController.value * MediaQuery.of(context).size.height : 0.0,
                    width: 50.0,
                  );
                },
              ),
              Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Image.asset("images/stopsign.png"),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.005,
                  width: 220.0,
                  color: Colors.white,
                ),
                AnimatedBuilder(
                  animation: _countdownController,
                  builder: (BuildContext context, Widget child) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: Text(timerString,
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: countdownColor,
                        ),),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _carController,
                  child: Container(
                    width: 50.0,
                    height: MediaQuery.of(context).size.height * 0.08,
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
                  height: MediaQuery.of(context).size.height * 0.2,
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
                              if (timerString == '0') {
                                joyStickPos = newValue / 100;
                                dy = ((-.2 * getCurrentPos) +
                                    (joyStickPos * 50.0)) * 0.033;
                                getCurrentPos = dy + getCurrentPos;
                                if (getCurrentPos < -80 &&
                                    getCurrentPos > -185) {
                                  timerColor = Colors.green;
                                }
                                else {
                                  timerColor = Colors.blue;
                                }
                              }
                              else {}
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
