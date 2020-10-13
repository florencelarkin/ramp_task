import 'package:flutter/material.dart';
import 'dart:math';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{

  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 10),
        vsync: this)..repeat();

  }

  AnimationController _controller;
  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double width = 100.0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 10.0;
  double dy = 0.0;

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

          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            AnimatedBuilder(
              animation: _controller,
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
              height: 50.0,
                child: Transform.scale(
                  scale: 0.25,
                  child: Transform.rotate(
                    angle: pi/2,
                    child: Slider(
                      inactiveColor: Colors.black,
                      activeColor: Colors.black,
                      value: joyStickPos,
                      min: -100.0,
                      max: 100.0,
                      onChanged: (double newValue) {
                        setState(() {
                          joyStickPos = newValue / 100;
                          print(newValue);
                          dy = ((-.35*getCurrentPos)+(-joyStickPos*50.0))*0.033;
                          getCurrentPos = dy + getCurrentPos;
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
          ],
    ),
      ),
    );
  }
}
