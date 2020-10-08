import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 10),
        vsync: this)..repeat();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }


  List<double> _accelerometerValues = [0.0,0.0,0.0];
  List<double> _userAccelerometerValues = [0.0,0.0,0.0];
  List<double> _gyroscopeValues = [0.0,0.0,0.0];
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];
  Stopwatch stopwatch = new Stopwatch()..start();
   int time = 0;
  double getCurrentPos = -100.0;
  double dy = 0.0;

  double getPos (gyroscope, currentPos) {
    dy = ((-.35*currentPos)+(-gyroscope*1000.0))*0.033;
    getCurrentPos = dy + currentPos;
    dy = ((-.35*getCurrentPos)+(-gyroscope*1000.0))*0.033;
    print(getCurrentPos);
    return dy;
  }


  String getTime () {
    time = stopwatch.elapsedMilliseconds;
    return time.toString();
  }


  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Task'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/drivingtaskbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 200.0,
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
                  offset: Offset(0.0, getPos(_gyroscopeValues[0], getCurrentPos)),
                  child: child,
                );
              },
            ),
            SizedBox(
              width: 100.0,
              height: 100.0,
            ),
            Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Gyroscope: $gyroscope'),
                ],
              ),
              padding: const EdgeInsets.all(1.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }


}
