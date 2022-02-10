import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'car_engine.dart';
import 'data.dart';
import 'package:flutter/foundation.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import 'practice_completed.dart';
import 'practice_restart.dart';
import 'device_data_writer.dart';
import 'data_map_writer.dart';
import 'alert_dialog.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:convert';

class PracticePage extends StatefulWidget {
  PracticePage({
    @required this.timeMax,
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    this.width,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
  });
  final double timeMax;
  final String subjectId;
  final String uuid;
  final double lpc;
  final int totalTrials;
  final double iceGain;
  final double cutoffFreq;
  final int order;
  final double samplingFreq;
  final double width;

  @override
  _PracticePageState createState() => _PracticePageState(
        timeMax: timeMax,
        subjectId: subjectId,
        uuid: uuid,
        lpc: lpc,
        width: width,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
      );
}

class _PracticePageState extends State<PracticePage>
    with TickerProviderStateMixin {
  _PracticePageState({
    @required this.timeMax,
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    this.width,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
  });
  double timeMax;
  double iceGain;
  double cutoffFreq;
  String subjectId;
  double samplingFreq;
  double lpc;
  int totalTrials;
  int order;
  String uuid;
  double width;

  final browser = Browser.detectOrNull();
  DataMapWriter dataMapWriter = DataMapWriter();
  Stopwatch stopwatch = new Stopwatch()..start();
  var startTime = new DateTime.now();
  AlertDialogClass alertDialog = AlertDialogClass();

  AnimationController _carController;
  AnimationController _demoCarController;
  Animation<double> animation;

  Timer carTimer;
  Timer trialTimer;
  Timer serverTimeout;

  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 0.0;
  double dy = 0.0;
  double carVelocity = 0.0;
  double getAdjustedPos = 0.0;
  double prevPos = 0.0;
  double prevTime = 0.0;
  double currentTime = 0.0;
  double x = 0.0;
  double y = 0.0;

  String title = '';
  String messageText = '';
  String feedbackText = 'Put your thumb on the white circle to begin';
  String restartText = '';
  Map deviceData = {};
  String text = '';
  String platformType = ''; // the platform: android, ios, windows, linux
  String browserType = '';
  final String taskVersion = 'driving_task:0.9';
  Future<String> futureDeviceData;
  String _timezone = 'Unknown';

  Map<String, String> urlArgs = {};
  Map dataMap = {};

  List posList = [0.0, 0.0, 0.0];
  List<dynamic> dataList = [];

  Color textColor = Colors.white;
  Color countdownColor = Colors.white;

  bool pointerCheck = false;
  bool movementCheck = false;
  bool pretrial = true;
  bool webFlag = false; // true if running web
  Future<bool> dataSent;

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  Future<void> _initData() async {
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
      print('error');
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _pointerCheck(PointerEvent details) {
    setState(() {
      _updateLocation(details);
      if ((y / lpc) > 0.78 && (y / lpc) < 0.88) {
        pointerCheck = true;
        print(' lpc: $lpc, x: $x, y:$y');
        pretrial = false;
        textColor = Colors.black;
        Future.delayed(Duration(milliseconds: 2500), () {
          _demoCarController.repeat(reverse: true);
          countdownColor = Colors.black;
          text = 'start';
        });

        Future.delayed(Duration(milliseconds: 1000), () {
          setState(() {
            countdownColor = Colors.white;
            text = 'GET READY';
          });
        });

        Future.delayed(Duration(milliseconds: 2000), () {
          text = 'GO!';
        });
      } else {
        pointerCheck = false;
      }
    });
  }

  _serverUpload(studycode, guid, dataList, dataVersion) async {
    bool dataSent = await createData(studycode, guid, dataList, dataVersion);
    print(dataSent);
    if (dataSent == true) {
      _demoCarController.stop();
      _carController.stop();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeCompleted(
              lpc: lpc,
              width: width,
              subjectId: subjectId,
              uuid: uuid,
              cutoffFreq: cutoffFreq,
              iceGain: iceGain,
              timeMax: timeMax,
              totalTrials: totalTrials,
              samplingFreq: samplingFreq,
              order: order,
            ),
          ));
    } else if (dataSent == false) {
      title = 'Error';
      messageText = 'Data has not been uploaded to the server';
      alertDialog.showAlertDialog(
        context,
        subjectId,
        uuid,
        0,
        0,
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
        true,
      );
    } else {
      serverTimeout = Timer(Duration(seconds: 15), () {
        title = 'Error';
        messageText = 'Server not found';
        alertDialog.showAlertDialog(
          context,
          subjectId,
          uuid,
          0,
          0,
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
          true,
        );
      });
    }
  }

  void _restartSlider(PointerEvent details) {
    setState(() {
      pointerCheck = false;
      dataMap = dataMapWriter.writeMap(
        taskVersion,
        webFlag,
        platformType,
        deviceData,
        subjectId,
        0,
        _timezone,
        startTime,
        timeMax,
        order,
        totalTrials,
        samplingFreq,
        cutoffFreq,
        lpc,
        true,
        false,
        dataList,
        width,
      );
      _carController.stop();
      _demoCarController.stop();
      carTimer.cancel();
      trialTimer.cancel();
      createData('driving01', uuid, dataMap, '01');
      restartText =
          'Remember to keep your thumb on the slider until you see the next screen!';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestartPractice(
            subjectId: subjectId,
            uuid: uuid,
            lpc: lpc,
            width: width,
            timeMax: timeMax,
            totalTrials: totalTrials,
            iceGain: iceGain,
            cutoffFreq: cutoffFreq,
            order: order,
            samplingFreq: samplingFreq,
            restartText: restartText,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
    CarEngine carEngine = CarEngine(
      timeMax: timeMax,
      lpc: lpc,
      urlGain: iceGain,
      cutoffFreq: cutoffFreq,
      order: order,
      samplingFreq: samplingFreq,
    );

    DeviceDataWriter deviceDataWriter = DeviceDataWriter();
    deviceDataWriter.initPlatformState().then((Map futureDeviceData) {
      setState(() {
        deviceData = futureDeviceData;
      });
    });

    // check platform
    platformType = deviceDataWriter.checkWebPlatform();
    // initialize the header of the dataList
    dataList.add([
      'times',
      'slider',
      'carPos',
      'carVel',
      'carDelta',
      'eventcode',
    ]);

    _carController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..repeat(); //putting in pointer event for now
    //demo car controller is the controller for the car the participant is supposed to follow during practice
    _demoCarController = AnimationController(
        duration: const Duration(milliseconds: 4500), vsync: this);
    animation = Tween<double>(begin: 0, end: lpc * 0.43).animate(
        CurvedAnimation(parent: _demoCarController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    trialTimer = Timer(Duration(seconds: 30), () {
      if (movementCheck == true) {
        dataMap = dataMapWriter.writeMap(
            taskVersion,
            webFlag,
            platformType,
            deviceData,
            subjectId,
            0,
            _timezone,
            startTime,
            timeMax,
            order,
            totalTrials,
            samplingFreq,
            cutoffFreq,
            lpc,
            true,
            true,
            dataList,
            width);
        _demoCarController.stop();
        _carController.stop();
        carTimer.cancel();
        _serverUpload('driving01', uuid, dataMap, '01');
        trialTimer.cancel();
      } else {
        dataMap = dataMapWriter.writeMap(
            taskVersion,
            webFlag,
            platformType,
            deviceData,
            subjectId,
            0,
            _timezone,
            startTime,
            timeMax,
            order,
            totalTrials,
            samplingFreq,
            cutoffFreq,
            lpc,
            true,
            false,
            dataList,
            width);
        _demoCarController.stop();
        _carController.stop();
        carTimer.cancel();
        trialTimer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestartPractice(
              subjectId: subjectId,
              uuid: uuid,
              lpc: lpc,
              width: width,
              timeMax: timeMax,
              totalTrials: totalTrials,
              iceGain: iceGain,
              cutoffFreq: cutoffFreq,
              order: order,
              samplingFreq: samplingFreq,
              restartText:
                  'Make sure you are moving your car and trying to match the target car.',
            ),
          ),
        );
      }
    });

    //calls functions that check for joystick movement and car position, then adds that to the output list
    carTimer = Timer.periodic(Duration(microseconds: 16667), (Timer t) {
      setState(() {
        prevTime = currentTime;
        currentTime = stopwatch.elapsedMilliseconds.toDouble();
        if (stopwatch.elapsedMilliseconds > 6000 && pointerCheck == false) {
          dataMap = dataMapWriter.writeMap(
              taskVersion,
              webFlag,
              platformType,
              deviceData,
              subjectId,
              0,
              _timezone,
              startTime,
              timeMax,
              order,
              totalTrials,
              samplingFreq,
              cutoffFreq,
              lpc,
              true,
              false,
              dataList,
              width);
          createData('driving01', uuid, dataMap, '01');
          _carController.stop();
          _demoCarController.stop();
          carTimer.cancel();
          trialTimer.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestartPractice(
                subjectId: subjectId,
                uuid: uuid,
                lpc: lpc,
                width: width,
                timeMax: timeMax,
                totalTrials: totalTrials,
                iceGain: iceGain,
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
                restartText:
                    'Make sure you put your thumb on the slider to start the practice session.',
              ),
            ),
          );
        } else {}
        if (posList[0] < -2.0 || posList[0] > 1.0) {
          pointerCheck = false;
          //if you go off the screen in either direction
          dataMap = dataMapWriter.writeMap(
              taskVersion,
              webFlag,
              platformType,
              deviceData,
              subjectId,
              0,
              _timezone,
              startTime,
              timeMax,
              order,
              totalTrials,
              samplingFreq,
              cutoffFreq,
              lpc,
              true,
              false,
              dataList,
              width);
          _carController.stop();
          _demoCarController.stop();
          carTimer.cancel();
          trialTimer.cancel();
          createData('driving01', uuid, dataMap, '01');
          restartText =
              'Remember to stay within a closer distance of the red car!';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestartPractice(
                subjectId: subjectId,
                uuid: uuid,
                lpc: lpc,
                width: width,
                timeMax: timeMax,
                totalTrials: totalTrials,
                iceGain: iceGain,
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
                restartText: restartText,
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
        } else if (posList[0] - (-animation.value / 310) > .15 ||
            posList[0] - (-animation.value / 310) < -.15) {
          setState(() {
            textColor = Colors.white;
            feedbackText = "Stay closer to the red car!";
          });
        } else if (posList[0] < -.4) {
          movementCheck = true;
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
          joyStickPos, posList[1], timeMax, posList[0], currentTime, prevTime);
      dataList.add(outputList());
    });
  }

  @override
  void dispose() {
    //_countdownController.dispose();
    _carController.dispose();
    _demoCarController.dispose();
    super.dispose();
  }

  List outputList() {
    List<dynamic> data = [];
    getAdjustedPos = -posList[0];
    carVelocity = -posList[2];
    data.addAll([
      stopwatch.elapsedMilliseconds.toString(),
      joyStickPos.toString(),
      getAdjustedPos.toString(),
      carVelocity.toString(),
      (posList[0] - (-animation.value / 310)).toString(),
      '0'
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: lpc * .05,
                  ),
                  Center(
                    child: Container(
                      height: lpc * .07,
                      child: Text(
                        feedbackText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: lpc * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // StopSign at top
                    height: lpc * 0.14,
                    width: lpc * .4,
                    child: Image.asset("images/stopsign.png"),
                  ),
                  Container(
                    // white end line at stop sign
                    height: lpc * 0.005,
                    width: 220.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: lpc * .18),
                  Center(
                    child: Container(
                      height: lpc * 0.23,
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: lpc * .05,
                          fontWeight: FontWeight.bold,
                          color: countdownColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // white starting line
                    height: lpc * 0.005,
                    width: 220.0,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        // car to follow
                        animation: _demoCarController,
                        child: Container(
                          width: lpc * 0.1,
                          height: lpc * 0.06,
                          child: Icon(
                            Icons.directions_car,
                            size: lpc * 0.075,
                            color: Colors.red,
                          ),
                        ),
                        builder: (BuildContext context, Widget child) {
                          return Transform.translate(
                            offset: Offset(
                                0.0,
                                animation.value != null
                                    ? -animation.value
                                    : 0.0),
                            child: child,
                          );
                        },
                      ),
                      SizedBox(
                        width: lpc * .1,
                      ),
                      AnimatedBuilder(
                        // car
                        animation: _carController,
                        child: Container(
                          width: lpc * 0.1,
                          height: lpc * 0.06,
                          child: Icon(Icons.directions_car, size: lpc * 0.075),
                        ),
                        builder: (BuildContext context, Widget child) {
                          return Transform.translate(
                            offset: Offset(0.0, posList[1]),
                            child: child,
                          );
                        },
                      ),
                    ],
                  ),
                  //SizedBox(height: lpc * 0.05),
                  // Slider
                  Expanded(
                    child: Container(
                      height: lpc * 0.18,
                      width: lpc * 0.3,
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
                              onPointerUp:
                                  pointerCheck == true ? _restartSlider : null,
                              child: Slider(
                                inactiveColor: Colors.white,
                                activeColor: Colors.white,
                                value: joyStickPos,
                                min: -100.0,
                                max: 100.0,
                                onChanged: (double newValue) {
                                  setState(() {
                                    text == 'start'
                                        ? joyStickPos = newValue / 100
                                        : joyStickPos = joyStickPos;
                                  });
                                },
                              ),
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
