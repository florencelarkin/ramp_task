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
import 'package:web_browser_detect/web_browser_detect.dart';

class MainPage extends StatefulWidget {
  MainPage({
    @required this.timeMax,
    @required this.subjectId,
    @required this.uuid,
    @required this.trialNumber,
    @required this.blockNumber,
    @required this.lpc,
    this.totalTrials,
    this.iceGain,
  });
  final double timeMax;
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final int totalTrials;
  final double iceGain;

  @override
  _MainPageState createState() => _MainPageState(
        timeMax: timeMax,
        subjectId: subjectId,
        uuid: uuid,
        trialNumber: trialNumber,
        blockNumber: blockNumber,
        lpc: lpc,
        totalTrials: totalTrials,
        iceGain: iceGain,
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
    this.iceGain,
  });
  double timeMax;
  String subjectId;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  int totalTrials;
  double iceGain;
  final browser = Browser.detectOrNull();

  AnimationController _timerController;
  AnimationController _carController;
  AnimationController _countdownController;
  Timer carTimer;
  Timer colorTimer;
  Timer dataTimer;
  Timer serverTimeout;

  bool webFlag = false; // true if running web
  String platformType = ""; // the platform: android, ios, windows, linux
  final String taskVersion = "driving_task:0.9";
  String browserType = "";

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  void checkWebPlatform() {
    // check the platform and whether web

    if (kIsWeb) {
      webFlag = true;
      browserType = browser.toString();
    } else {
      webFlag = false;

      platformType = Platform.operatingSystem;
      // now check platform
      if (Platform.isAndroid) {
        platformType = 'android';
      } else if (Platform.isIOS) {
        platformType = 'ios';
      } else if (Platform.isLinux) {
        platformType = 'linux';
      } else if (Platform.isWindows) {
        platformType = 'windows';
      } else if (Platform.isMacOS) {
        platformType = 'macOS';
      } else if (Platform.isFuchsia) {
        platformType = 'fuchsia';
      }
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
  double getAdjustedPos = 0.0;
  Map<String, String> urlArgs = {};
  List posList = [0.0, 0.0, 0.0];
  double prevPos = 0.0;
  double prevTime = 0.0;

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
                timeMax: timeMax,
                totalTrials: totalTrials,
                iceGain: iceGain,
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
                iceGain: iceGain,
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedPage(
                  webFlag: webFlag,
                ),
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
    CarEngine carEngine = CarEngine(
        timeMax: timeMax, lpc: lpc, trialNumber: trialNumber, urlGain: iceGain);
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
          showAlertDialog(context);
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
    carTimer = Timer.periodic(Duration(microseconds: 16667), (Timer t) {
      posList = carEngine.getPos(joyStickPos, posList[1], timeMax, posList[0],
          stopwatch.elapsedMilliseconds.toDouble());
      dataList.add(outputList());
    });
    //dataList.add(outputList(prevPos, prevTime));
    colorTimer = Timer.periodic(
        Duration(milliseconds: 17),
        (Timer t) => posList[1] < -lpc * .25 && posList[1] > -lpc * .435
            ? timerColor = Colors.green
            : timerColor = Colors.blue);
    /*dataTimer = Timer.periodic(Duration(milliseconds: 17),
        (Timer t) => dataList.add(outputList(prevPos, prevTime)));*/
    //Timer for the end of the trial
    Timer(Duration(seconds: 14), () {
      var endTime = new DateTime.now();
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      // add data to dataMap for output
      dataMap[addQuotesToString("TaskVersion")] =
          addQuotesToString(taskVersion);
      dataMap[addQuotesToString("Platform")] = addQuotesToString(platformType);
      dataMap[addQuotesToString("Web")] = webFlag;
      dataMap[addQuotesToString("Browser")] = addQuotesToString(browserType);
      //dataMap[addQuotesToString("DartVersion")] = addQuotesToString(Platform.version);
      // has double quoted android_ia32

      dataMap['\"SubjectID\"'] = addQuotesToString(subjectId);
      dataMap['\"TrialNumber\"'] = addQuotesToString(trialNumber.toString());
      dataMap['\"StartTime\"'] = addQuotesToString(startTime.toIso8601String());
      dataMap['\"EndTime\"'] = addQuotesToString(endTime.toIso8601String());
      dataMap['\"Sensitivity\"'] = timeMax.toString();
      dataMap['\"TotalTrials\"'] = addQuotesToString(totalTrials.toString());
      dataMap['\"ScreenSize\"'] = addQuotesToString('$width x $height');
      dataMap['\"Moves\"'] = dataList;
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
      carTimer.cancel();
      colorTimer.cancel();
      dataTimer.cancel();
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
    getAdjustedPos = posList[0];
    carVelocity = posList[2];
    data.addAll([
      stopwatch.elapsedMilliseconds.toString(),
      joyStickPos.toString(),
      getAdjustedPos.toString(),
      carVelocity.toString(),
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
                  // StopSign at top
                  height: lpc * 0.25,
                  width: 250.0,
                  child: Image.asset("images/stopsign.png"),
                ),
                Container(
                  // white end line at stop sign
                  height: lpc * 0.005,
                  width: 220.0,
                  color: Colors.white,
                ),
                AnimatedBuilder(
                  // 321 counter
                  animation: _countdownController,
                  builder: (BuildContext context, Widget child) {
                    return Container(
                      height: lpc * 0.41,
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
                  // white starting line
                  height: lpc * 0.005,
                  width: 220.0,
                  color: Colors.white,
                ),
                AnimatedBuilder(
                  // car
                  animation: _carController,
                  child: Container(
                    width: 50.0,
                    height: lpc * 0.03,
                    child: Icon(Icons.directions_car, size: lpc * 0.075),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform.translate(
                      offset: Offset(0.0, posList[1]),
                      child: child,
                    );
                  },
                ),

                SizedBox(height: lpc * 0.05),
                // Slider
                Container(
                  height: lpc * 0.24,
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
