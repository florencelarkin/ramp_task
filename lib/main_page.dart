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
import 'restart_page.dart';
import 'package:flutter/widgets.dart';
import 'device_data_writer.dart';
import 'data_map_writer.dart';
import 'alert_dialog.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:convert';

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
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.width,
  });
  final double timeMax;
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final int totalTrials;
  final double iceGain;
  final double cutoffFreq;
  final int order;
  final double samplingFreq;
  final double width;

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
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
        width: width,
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
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.width,
  });
  double timeMax;
  double iceGain;
  double cutoffFreq;
  double samplingFreq;
  double lpc;
  int trialNumber;
  int blockNumber;
  int totalTrials;
  int order;
  String subjectId;
  String uuid;
  double width;

  final browser = Browser.detectOrNull();
  DataMapWriter dataMapWriter = DataMapWriter();
  Stopwatch stopwatch = new Stopwatch()..start();
  var startTime = new DateTime.now();
  AlertDialogClass alertDialog = AlertDialogClass();

  AnimationController _timerController;
  AnimationController _carController;
  AnimationController _countdownController;

  Timer carTimer;
  Timer colorTimer;
  Timer dataTimer;
  Timer serverTimeout;
  Timer trialTimer;

  double carStartPos = -5.0;
  double sliderPos = 0.0;
  double getCurrentPos = 0.0;
  double dy = 0.0;
  double prevPos = 0.0;
  double prevTime = 0.0;
  double currentTime = 0.0;
  double carVelocity = 0.0;
  double getAdjustedPos = 0.0;
  double x = 0.0;
  double y = 0.0;

  List<dynamic> dataList = [];
  List posList = [0.0, 0.0, 0.0];
  Map dataMap = {};
  Map<String, String> urlArgs = {};

  Color timerColor = Colors.blue;
  Color textColor = Colors.white;

  String title = '';
  String messageText = '';
  String feedbackText = 'Put your thumb on the white dot to begin';
  String restartText = '';
  String platformType = ""; // the platform: android, ios, windows, linux
  String deviceData = "";
  String browserType = "";
  final String taskVersion = "driving_task:0.9";
  Future<String> futureDeviceData;
  String _timezone = 'Unknown';

  bool pointerCheck = false;
  bool completed;
  bool pretrial = true;
  bool webFlag = false; // true if running web
  Future<bool> dataSent;

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  void _updateLocation(PointerEvent details) {
    //checks where thumb is placed on the screen
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  void _pointerCheck(PointerEvent details) {
    //checks if thumb is on the correct position, otherwise trial does not start
    setState(() {
      _updateLocation(details);
      if ((y / lpc) > 0.78 && (y / lpc) < 0.88) {
        pointerCheck = true;
        pretrial = false;
        _countdownController.forward();
        _countdownController.reverse(
            from: _countdownController.value == 0.0
                ? 1.0
                : _countdownController.value);
        _timerController.forward();
        trialTimer = Timer(Duration(seconds: 13), () {
          dataMap = dataMapWriter.writeMap(
              taskVersion,
              webFlag,
              platformType,
              deviceData,
              subjectId,
              trialNumber,
              _timezone,
              startTime,
              timeMax,
              order,
              totalTrials,
              samplingFreq,
              cutoffFreq,
              lpc,
              false,
              posList[0] > -1.3 && posList[0] < -.6 ? true : false,
              dataList,
              width);
          _timerController.stop();
          _carController.stop();
          _countdownController.stop();
          carTimer.cancel();
          colorTimer.cancel();
          trialTimer.cancel();
          String _dataMap = jsonEncode(dataMap);
          _serverUpload('driving01', uuid, _dataMap, '01');
        });
      } else {
        pointerCheck = false;
      }
    });
  }

  Future<void> _initData() async {
    //returns the local timezone of the device running the app
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    if (mounted) {
      setState(() {});
    }
  }

  _serverUpload(studycode, guid, dataList, data_version) async {
    bool dataSent = await createData(studycode, guid, dataList, data_version);
    if (dataSent == true) {
      if (posList[0] > -1.3 && posList[0] < -.6) {
        //trial is complete
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
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
                width: width,
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
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
                width: width,
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
      } else {
        //trial is incomplete
        restartText = 'Make sure you are closer to the white line next time.';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestartPage(
              subjectId: subjectId,
              uuid: uuid,
              trialNumber: trialNumber,
              blockNumber: blockNumber,
              lpc: lpc,
              timeMax: timeMax,
              totalTrials: totalTrials,
              iceGain: iceGain,
              cutoffFreq: cutoffFreq,
              order: order,
              samplingFreq: samplingFreq,
              feedbackText: restartText,
              width: width,
            ),
          ),
        );
      }
    } else if (dataSent == false) {
      title = 'Error';
      messageText = 'Data has not been uploaded to the server';
      alertDialog.showAlertDialog(
        context,
        subjectId,
        uuid,
        trialNumber,
        blockNumber,
        lpc,
        timeMax,
        totalTrials,
        iceGain,
        cutoffFreq,
        samplingFreq,
        order,
        webFlag,
        title,
        messageText,
        false,
      );
    } else {
      serverTimeout = Timer(Duration(seconds: 15), () {
        title = 'Error';
        messageText = 'Server not found';
        alertDialog.showAlertDialog(
            context,
            subjectId,
            uuid,
            trialNumber,
            blockNumber,
            lpc,
            timeMax,
            totalTrials,
            iceGain,
            cutoffFreq,
            samplingFreq,
            order,
            webFlag,
            title,
            messageText,
            false);
      });
    }
  }

  void _restartSlider(PointerEvent details) {
    //called if subject takes thumb off slider, trial is marked incomplete
    setState(() {
      dataMap = dataMapWriter.writeMap(
          taskVersion,
          webFlag,
          platformType,
          deviceData,
          subjectId,
          trialNumber,
          _timezone,
          startTime,
          timeMax,
          order,
          totalTrials,
          samplingFreq,
          cutoffFreq,
          lpc,
          false,
          false,
          dataList,
          width);
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
      carTimer.cancel();
      colorTimer.cancel();
      trialTimer.cancel();
      createData('driving01', uuid, dataMap.toString(), '01');
      //_serverUpload('driving01', uuid, dataMap.toString(), '01');
      trialTimer.cancel();
      restartText =
          'Keep your finger on the slider throughout the whole 10 seconds!';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestartPage(
            subjectId: subjectId,
            uuid: uuid,
            trialNumber: trialNumber,
            blockNumber: blockNumber,
            lpc: lpc,
            timeMax: timeMax,
            totalTrials: totalTrials,
            iceGain: iceGain,
            cutoffFreq: cutoffFreq,
            order: order,
            samplingFreq: samplingFreq,
            feedbackText: restartText,
            width: width,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();

    //initialize car engine class
    CarEngine carEngine = CarEngine(
      timeMax: timeMax,
      lpc: lpc,
      trialNumber: trialNumber,
      urlGain: iceGain,
      cutoffFreq: cutoffFreq,
      order: order,
      samplingFreq: samplingFreq,
    );

    //initialize device data class
    DeviceDataWriter deviceDataWriter = DeviceDataWriter();
    deviceDataWriter.initPlatformState().then((String futureDeviceData) {
      setState(() {
        deviceData = futureDeviceData;
      });
    });

    // check platform
    platformType = deviceDataWriter.checkWebPlatform();

    // initialize the header of the dataList
    dataList.add([
      addQuotesToString("times"),
      addQuotesToString("slider"),
      addQuotesToString("carPos"),
      addQuotesToString("carVel"),
      addQuotesToString("eventcode")
    ]);

    //animation controllers
    _countdownController =
        AnimationController(duration: Duration(seconds: 4), vsync: this);

    _carController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..repeat();
    _timerController =
        AnimationController(duration: Duration(seconds: 13), vsync: this);

    //calls functions that check for joystick movement and car position, then adds that to the output list
    carTimer = Timer.periodic(Duration(microseconds: 16667), (Timer t) {
      setState(() {
        prevTime = currentTime;
        currentTime = stopwatch.elapsedMilliseconds.toDouble();
        if (posList[0] < -2.0 || posList[0] > 1.0) {
          //checks if you go off the screen in either direction, trial is marked incomplete
          dataMap = dataMapWriter.writeMap(
              taskVersion,
              webFlag,
              platformType,
              deviceData,
              subjectId,
              trialNumber,
              _timezone,
              startTime,
              timeMax,
              order,
              totalTrials,
              samplingFreq,
              cutoffFreq,
              lpc,
              false,
              false,
              dataList,
              width);
          _timerController.stop();
          _carController.stop();
          _countdownController.stop();
          carTimer.cancel();
          colorTimer.cancel();
          trialTimer.cancel();
          createData('driving01', uuid, dataMap.toString(), '01');
          restartText = 'Make sure to stay within the screen boundaries!';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestartPage(
                subjectId: subjectId,
                uuid: uuid,
                trialNumber: trialNumber,
                blockNumber: blockNumber,
                lpc: lpc,
                timeMax: timeMax,
                totalTrials: totalTrials,
                iceGain: iceGain,
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
                feedbackText: restartText,
                width: width,
              ),
            ),
          );
        } else if (posList[0] < -1.3) {
          setState(() {
            textColor = Colors.white;
            feedbackText = 'WATCH OUT!!';
          });
        } else if (posList[0] > .2) {
          setState(() {
            textColor = Colors.white;
            feedbackText = 'WRONG WAY!!';
          });
        } else if (pretrial == true) {
          setState(() {
            textColor = Colors.white;
          });
        } else {
          setState(() {
            textColor = Colors.black;
          });
        }
      });
      posList = carEngine.getPos(
          sliderPos, posList[1], timeMax, posList[0], currentTime, prevTime);
      dataList.add(outputList());
    });

    //Controls whether timer bar is blue or green depending on car position
    colorTimer = Timer.periodic(
        Duration(milliseconds: 17),
        (Timer t) => posList[1] < -lpc * .25 && posList[1] > -lpc * .435
            ? timerColor = Colors.green
            : timerColor = Colors.blue);
  }

  @override
  void dispose() {
    _countdownController.dispose();
    _timerController.dispose();
    _carController.dispose();
    super.dispose();
  }

  //Timer countdown at beginning of trial
  String get timerString {
    Duration duration =
        _countdownController.duration * _countdownController.value;
    return '${(duration.inSeconds % 60).toString()}';
  }

  //Color of countdown text
  Color get countdownColor {
    Duration duration =
        _countdownController.duration * _countdownController.value;
    if (duration.inSeconds > 0) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  //Data list, called approximately every frame
  List outputList() {
    List<dynamic> data = [];
    getAdjustedPos = -posList[0];
    carVelocity = -posList[2];
    data.addAll([
      stopwatch.elapsedMilliseconds.toString(),
      sliderPos.toString(),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  Center(
                    child: Container(
                      height: lpc * .05,
                      child: Text(
                        feedbackText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: lpc * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // StopSign at top
                    height: lpc * 0.14,
                    width: MediaQuery.of(context).size.width * .65,
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: lpc * 0.08,
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
                  // Slider
                  Container(
                    height: lpc * 0.30,
                    width: MediaQuery.of(context).size.width,
                    child: Transform.scale(
                      scale: 0.75,
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 0.0,
                            thumbColor: Colors.white,
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: lpc * 0.05),
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                          ),
                          child: Listener(
                            onPointerDown: _pointerCheck,
                            onPointerUp: pointerCheck == true ||
                                    pointerCheck == false &&
                                        stopwatch.elapsedMilliseconds > 5000
                                ? _restartSlider
                                : null,
                            child: Slider(
                              inactiveColor: Colors.white,
                              activeColor: Colors.white,
                              value: sliderPos,
                              min: -100.0,
                              max: 100.0,
                              onChanged: (double newValue) {
                                setState(() {
                                  if (timerString == '0') {
                                    sliderPos = newValue / 100;
                                  } else {}
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
