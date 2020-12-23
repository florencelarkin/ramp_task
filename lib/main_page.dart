import 'package:driving_task/continue_trial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'car_engine.dart';
import 'data.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';



class MainPage extends StatefulWidget {
  MainPage({@required this.maxVelocity});
  final double maxVelocity;
  @override
  _MainPageState createState() => _MainPageState(maxVelocity: maxVelocity);
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{
  _MainPageState({@required this.maxVelocity});
  double maxVelocity;

  AnimationController _timerController;
  AnimationController _carController;
  AnimationController _countdownController;
  Timer carTimer;
  Timer colorTimer;

  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 10.0;
  double dy = 0.0;
  Color timerColor = Colors.blue;
  double carVelocity = 0.0;
  var uuid = Uuid();
  Map<List, List> dataMap = {};
  List dataList = [];
  Future<Data> _futureData;


  @override
  void initState() {
    super.initState();
    CarEngine carEngine = CarEngine(maxVelocity: maxVelocity);

    //animation controllers
    _countdownController = AnimationController(duration: Duration(seconds: 4),
        vsync: this);
    _countdownController.forward();
    _countdownController.reverse(from: _countdownController.value == 0.0 ? 1.0 : _countdownController.value);
    _carController = AnimationController(duration: const Duration(seconds: 10),
        vsync: this)..repeat();
    _timerController = AnimationController(duration: Duration(seconds: 14),
        vsync: this);
    _timerController.forward();

    //calls functions that check for joystick movement and car position
    carTimer = Timer.periodic(Duration(milliseconds: 17), (Timer t) => getCurrentPos = carEngine.getPos(joyStickPos, getCurrentPos));
    colorTimer = Timer.periodic(Duration(milliseconds: 17), (Timer t) => getCurrentPos < -80 && getCurrentPos > -182 ? timerColor = Colors.green : timerColor = Colors.blue);

    //Timer for the end of the trial
    Timer(Duration(seconds: 14), () {
      dataMap = {['time', 'joystick_y', 'car_position', 'car_velocity', 'eventcode'] : dataList};
      _futureData = createData('driving01',uuid.v1(), dataMap.toString());
      //saveFile();
      //readFile();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ContinuationPage(),),);
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
      carTimer.cancel();
      colorTimer.cancel();
    });

  }

  @override
  void dispose() {
    _countdownController.dispose();
    _timerController.dispose();
    _carController.dispose();
    super.dispose();
  }


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

  List outputList () {
    List data = [];
    carVelocity = getCurrentPos / stopwatch.elapsedMilliseconds / 3;
    String calculatedVelocity = carVelocity.toString();
    data.addAll([stopwatch.elapsedMilliseconds.toString(), joyStickPos.toString(),getCurrentPos.toString(), calculatedVelocity,'8']);
    return data;
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

    return filePath;
  }

  void saveFile() async {
    File file = File(await getFilePath()); // 1
    file.writeAsString(dataList.toString()); // 2
  }

  void readFile() async {
    File file = File(await getFilePath()); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
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
                    scale: 0.5,
                    child: Transform.rotate(
                      angle: pi/2,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 30.0,
                          thumbColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 70.0),
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
                                dataList.add(outputList());
                                //TODO: may have to put this in the motion function instead?
                              }
                              else {}
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
