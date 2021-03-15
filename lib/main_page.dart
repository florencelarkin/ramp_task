import 'dart:io';
import 'package:driving_task/continue_trial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'car_engine.dart';
import 'data.dart';
import 'package:flutter/foundation.dart';
import 'block_page.dart';
import 'completed_screen.dart';
import 'url_args.dart';

class MainPage extends StatefulWidget {
  MainPage({
    @required this.timeMax,
    @required this.subjectId,
    @required this.uuid,
    @required this.trialNumber,
    @required this.blockNumber,
    @required this.lpc,
    this.totalTrials,
  });
  final double timeMax;
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final int totalTrials;
  @override
  _MainPageState createState() => _MainPageState(
        timeMax: timeMax,
        subjectId: subjectId,
        uuid: uuid,
        trialNumber: trialNumber,
        blockNumber: blockNumber,
        lpc: lpc,
        totalTrials: totalTrials,
      );
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  _MainPageState({
    @required this.timeMax,
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.totalTrials,
  });
  double timeMax;
  String subjectId;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  int totalTrials;

  AnimationController _timerController;
  AnimationController _carController;
  AnimationController _countdownController;
  Timer carTimer;
  Timer colorTimer;
  Timer dataTimer;

  bool webFlag = false; // true if running web
  String platformType = ""; // the platform: android, ios, windows, linux
  final String taskVersion = "driving_task:0.9";

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  void checkWebPlatform() {
    // check the platform and whether web

    if (kIsWeb) {
      webFlag = true;
    } else {
      webFlag = false;

      platformType = Platform.operatingSystem;
      // now check platform
      /*
      if(Platform.isAndroid) {
        platformType = 'android';
      } else if (Platform.isIOS) {
        platformType = 'ios';
      } else if (Platform.isLinux) {
        platformType = 'linux';
      } else if (Platform.isWindows) {
        platformType = 'windows';
      } else if (Platform.isMacOS) {
        platformType = 'macos';
      } else if (Platform.isFuchsia) {
        platformType = 'fuchsia';
      }
       */
    }
  }

  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 0.0;
  double dy = 0.0;
  Color timerColor = Colors.blue;
  double carVelocity = 0.0;
  List<dynamic> dataList = [];
  Future<Data> _futureData;
  String title = '';
  String messageText = '';
  Map dataMap = {};
  Future<bool> dataSent;
  double getAdjustedPos;
  Map<String, String> urlArgs = {};

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text('OK'),
      onPressed: () {
        if (trialNumber == totalTrials / 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlockPage(
                subjectId: subjectId,
                uuid: uuid,
                trialNumber: trialNumber,
                blockNumber: blockNumber,
                lpc: lpc,
              ),
            ),
          );
        } else if (trialNumber != totalTrials) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContinuationPage(
                subjectId: subjectId,
                uuid: uuid,
                trialNumber: trialNumber,
                blockNumber: blockNumber,
                lpc: lpc,
                totalTrials: totalTrials,
                timeMax: timeMax,
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedPage(),
              ));
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("$title"),
      content: Text("$messageText"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    var startTime = new DateTime.now();
    CarEngine carEngine =
        CarEngine(timeMax: timeMax, lpc: lpc, trialNumber: trialNumber);
    Timer serverTimeout;
    // check platform
    checkWebPlatform();
    // initialize the header of the dataList

    dataList.add([
      addQuotesToString("times"),
      addQuotesToString("slider"),
      addQuotesToString("carPos"),
      addQuotesToString("carVel"),
      addQuotesToString("eventcode")
    ]);

    _serverUpload(studycode, guid, dataList, data_version) async {
      bool dataSent = await createData(studycode, guid, dataList, data_version);
      if (dataSent == true) {
        title = 'Success!';
        messageText = 'Data has been sent to the server';
        showAlertDialog(context);
      } else if (dataSent == false) {
        title = 'Error';
        messageText = 'Data has not been uploaded to the server';
        showAlertDialog(context);
      } else {
        serverTimeout = Timer(Duration(seconds: 15), () {
          title = 'Error';
          messageText = 'Server not found';
        });
      }
    }

    //animation controllers
    _countdownController =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    _countdownController.forward();
    _countdownController.reverse(
        from: _countdownController.value == 0.0
            ? 1.0
            : _countdownController.value);
    _carController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..repeat();
    _timerController =
        AnimationController(duration: Duration(seconds: 14), vsync: this);
    _timerController.forward();

    //calls functions that check for joystick movement and car position, then adds that to the output list
    carTimer = Timer.periodic(
        Duration(milliseconds: 17),
        (Timer t) => getCurrentPos =
            carEngine.getPos(joyStickPos, getCurrentPos, timeMax));
    dataList.add(outputList());
    colorTimer = Timer.periodic(
        Duration(milliseconds: 17),
        (Timer t) => getCurrentPos < -lpc * .25 && getCurrentPos > -lpc * .45
            ? timerColor = Colors.green
            : timerColor = Colors.blue);
    dataTimer = Timer.periodic(
        Duration(milliseconds: 17), (Timer t) => dataList.add(outputList()));
    //Timer for the end of the trial
    Timer(Duration(seconds: 14), () {
      var endTime = new DateTime.now();

      // add data to dataMap for output
      dataMap[addQuotesToString("TaskVersion")] =
          addQuotesToString(taskVersion);
      dataMap[addQuotesToString("Platform")] = addQuotesToString(platformType);
      dataMap[addQuotesToString("Web")] = webFlag;
      //dataMap[addQuotesToString("DartVersion")] = addQuotesToString(Platform.version);
      // has double quoted android_ia32

      dataMap['\"SubjectID\"'] = addQuotesToString(subjectId);
      dataMap['\"TrialNumber\"'] = addQuotesToString(trialNumber.toString());
      dataMap['\"StartTime\"'] = addQuotesToString(startTime.toIso8601String());
      dataMap['\"EndTime\"'] = addQuotesToString(endTime.toIso8601String());
      dataMap['\"Sensitivity\"'] = timeMax.toString();
      dataMap['\"Moves\"'] = dataList;
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
      carTimer.cancel();
      colorTimer.cancel();
      _serverUpload('driving01', uuid, dataMap.toString(), '01');
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
    Duration duration =
        _countdownController.duration * _countdownController.value;
    return '${(duration.inSeconds % 60).toString()}';
  }

  Color get countdownColor {
    Duration duration =
        _countdownController.duration * _countdownController.value;
    if (duration.inSeconds > 0) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  List outputList() {
    List<dynamic> data = [];
    //getAdjustedPos = getCurrentPos + lpc * .45;
    carVelocity = getCurrentPos / stopwatch.elapsedMilliseconds / 3;
    double calculatedVelocity = carVelocity;
    data.addAll([
      stopwatch.elapsedMilliseconds.toString(),
      joyStickPos.toString(),
      getCurrentPos.toString(),
      calculatedVelocity.toString(),
      '8'
    ]);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: timerString == '0'
                      ? _timerController.value *
                          MediaQuery.of(context).size.height
                      : 0.0,
                  width: 50.0,
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: 250.0,
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
                      height: MediaQuery.of(context).size.height * 0.41,
                      child: Text(
                        timerString,
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: countdownColor,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.005,
                  width: 220.0,
                  color: Colors.white,
                ),
                AnimatedBuilder(
                  animation: _carController,
                  child: Container(
                    width: 50.0,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Icon(Icons.directions_car, size: 50),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform.translate(
                      offset: Offset(0.0, getCurrentPos),
                      child: child,
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  height: MediaQuery.of(context).size.height * 0.24,
                  width: 300.0,
                  child: Transform.scale(
                    scale: 0.5,
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 30.0,
                          thumbColor: Colors.white,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 70.0),
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
                              } else {}
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
