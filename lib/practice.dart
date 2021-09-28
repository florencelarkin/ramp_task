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
import 'deviceDataWriter.dart';

class PracticePage extends StatefulWidget {
  PracticePage({
    @required this.timeMax,
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
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

  @override
  _PracticePageState createState() => _PracticePageState(
        timeMax: timeMax,
        subjectId: subjectId,
        uuid: uuid,
        lpc: lpc,
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
    this.lpc,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
  });
  double timeMax;
  String subjectId;
  String uuid;
  double lpc;
  int totalTrials;
  double iceGain;
  double cutoffFreq;
  int order;
  double samplingFreq;

  final browser = Browser.detectOrNull();

  AnimationController _carController;
  AnimationController _demoCarController;
  Animation<double> animation;
  Timer carTimer;
  Timer trialTimer;
  Timer serverTimeout;

  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 0.0;
  double dy = 0.0;
  double carVelocity = 0.0;
  List<dynamic> dataList = [];
  //Future<Data> _futureData;
  String title = '';
  String messageText = '';
  Map dataMap = {};
  Future<bool> dataSent;
  double getAdjustedPos = 0.0;
  Map<String, String> urlArgs = {};
  List posList = [0.0, 0.0, 0.0];
  double prevPos = 0.0;
  double prevTime = 0.0;
  double currentTime = 0.0;
  int counter = 0;
  String text = '';
  Color textColor = Colors.black;
  Color countdownColor = Colors.black;
  String feedbackText = '';
  String restartText = '';
  bool pointerCheck = false;
  int tweenCounter = 0;
  Future<String> futureDeviceData;
  String deviceData = "";
  var startTime = new DateTime.now();

  void _pointerCheck(PointerEvent details) {
    setState(() {
      pointerCheck = true;
    });
  }

  bool webFlag = false; // true if running web
  String platformType = ""; // the platform: android, ios, windows, linux
  final String taskVersion = "driving_task:0.9";
  String browserType = "";

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  _serverUpload(studycode, guid, dataList, dataVersion) async {
    bool dataSent = await createData(studycode, guid, dataList, dataVersion);
    if (dataSent == true) {
      trialTimer.cancel();
      carTimer.cancel();
      _demoCarController.stop();
      _carController.stop();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeCompleted(
              lpc: lpc,
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
      showAlertDialog(context);
    } else {
      serverTimeout = Timer(Duration(seconds: 15), () {
        title = 'Error';
        messageText = 'Server not found';
        showAlertDialog(context);
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text('OK'),
      onPressed: () {
        trialTimer.cancel();
        carTimer.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PracticeCompleted(
                lpc: lpc,
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

  void _mistrialSlider(PointerEvent details) {
    setState(() {
      pointerCheck = false;
      dataMap[addQuotesToString("TaskVersion")] =
          addQuotesToString(taskVersion);
      dataMap[addQuotesToString("Platform")] = addQuotesToString(platformType);
      dataMap[addQuotesToString("DeviceData")] = addQuotesToString(deviceData);
      dataMap[addQuotesToString("SubjectID")] = addQuotesToString(subjectId);
      dataMap['\"TrialNumber\"'] = addQuotesToString("Practice");
      dataMap['\"StartTime\"'] = addQuotesToString(startTime.toIso8601String());
      dataMap['\"EndTime\"'] =
          addQuotesToString(DateTime.now().toIso8601String());
      dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
      dataMap['\"FilterCutoffFrequency\"'] =
          addQuotesToString(cutoffFreq.toString());
      dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
      dataMap['\"FilterSamplingFreq\"'] =
          addQuotesToString(samplingFreq.toString());
      dataMap['\"TotalTrials\"'] = addQuotesToString(totalTrials.toString());
      dataMap['\"ScreenSize\"'] = addQuotesToString('$lpc'); //fix this later
      dataMap[addQuotesToString("CompletedTrial")] = addQuotesToString('no');
      dataMap['\"Moves\"'] = dataList;
      _carController.stop();
      _demoCarController.stop();
      carTimer.cancel();
      trialTimer.cancel();
      createData('driving01', uuid, dataMap.toString(), '01');

      restartText =
          'Remember to keep your thumb on the slider until you see the next screen!';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestartPractice(
            subjectId: subjectId,
            uuid: uuid,
            lpc: lpc,
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
    var startTime = new DateTime.now();
    //initPlatformState();
    //initCountdown();
    CarEngine carEngine = CarEngine(
      timeMax: timeMax,
      lpc: lpc,
      urlGain: iceGain,
      cutoffFreq: cutoffFreq,
      order: order,
      samplingFreq: samplingFreq,
    );

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
      addQuotesToString("carDelta"),
      addQuotesToString("eventcode"),
    ]);

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

    _carController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..repeat(); //putting in pointer event for now
    //demo car controller is the controller for the car the participant is supposed to follow during practice
    _demoCarController = AnimationController(
        duration: const Duration(milliseconds: 4500), vsync: this);
    animation = Tween<double>(begin: 0, end: lpc * 0.43).animate(
        CurvedAnimation(parent: _demoCarController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          tweenCounter++;
        });
      });

    //calls functions that check for joystick movement and car position, then adds that to the output list
    carTimer = Timer.periodic(Duration(microseconds: 16667), (Timer t) {
      setState(() {
        prevTime = currentTime;
        currentTime = stopwatch.elapsedMilliseconds.toDouble();
        if (stopwatch.elapsedMilliseconds > 5000 && pointerCheck == false) {
          dataMap[addQuotesToString("TaskVersion")] =
              addQuotesToString(taskVersion);
          dataMap[addQuotesToString("Platform")] =
              addQuotesToString(platformType);
          dataMap[addQuotesToString("Web")] = webFlag;
          dataMap[addQuotesToString("Browser")] =
              addQuotesToString(browserType);
          //dataMap[addQuotesToString("DartVersion")] = addQuotesToString(Platform.version);
          // has double quoted android_ia32
          dataMap[addQuotesToString("DeviceData")] =
              addQuotesToString(deviceData);
          dataMap[addQuotesToString("SubjectID")] =
              addQuotesToString(subjectId);
          dataMap['\"TrialNumber\"'] = addQuotesToString("Practice");
          dataMap['\"StartTime\"'] =
              addQuotesToString(startTime.toIso8601String());
          dataMap['\"EndTime\"'] =
              addQuotesToString(DateTime.now().toIso8601String());
          dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
          dataMap['\"FilterCutoffFrequency\"'] =
              addQuotesToString(cutoffFreq.toString());
          dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
          dataMap['\"FilterSamplingFreq\"'] =
              addQuotesToString(samplingFreq.toString());
          dataMap['\"TotalTrials\"'] =
              addQuotesToString(totalTrials.toString());
          dataMap['\"ScreenSize\"'] =
              addQuotesToString('$lpc'); //fix this later
          dataMap[addQuotesToString("CompletedTrial")] =
              addQuotesToString('no');
          dataMap['\"Moves\"'] = dataList;
          createData('driving01', uuid, dataMap.toString(), '01');
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
          dataMap[addQuotesToString("TaskVersion")] =
              addQuotesToString(taskVersion);
          dataMap[addQuotesToString("Platform")] =
              addQuotesToString(platformType);
          dataMap[addQuotesToString("DeviceData")] =
              addQuotesToString(deviceData);
          dataMap[addQuotesToString("SubjectID")] =
              addQuotesToString(subjectId);
          dataMap['\"TrialNumber\"'] = addQuotesToString("Practice");
          dataMap['\"StartTime\"'] =
              addQuotesToString(startTime.toIso8601String());
          dataMap['\"EndTime\"'] =
              addQuotesToString(DateTime.now().toIso8601String());
          dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
          dataMap['\"FilterCutoffFrequency\"'] =
              addQuotesToString(cutoffFreq.toString());
          dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
          dataMap['\"FilterSamplingFreq\"'] =
              addQuotesToString(samplingFreq.toString());
          dataMap['\"TotalTrials\"'] =
              addQuotesToString(totalTrials.toString());
          dataMap['\"ScreenSize\"'] =
              addQuotesToString('$lpc'); //fix this later
          dataMap[addQuotesToString("CompletedTrial")] =
              addQuotesToString('no');
          dataMap['\"Moves\"'] = dataList;
          _carController.stop();
          _demoCarController.stop();
          carTimer.cancel();
          trialTimer.cancel();
          createData('driving01', uuid, dataMap.toString(), '01');
          restartText =
              'Remember to stay within a closer distance of the red car!';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestartPractice(
                subjectId: subjectId,
                uuid: uuid,
                lpc: lpc,
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
    trialTimer = Timer(Duration(seconds: 30), () {
      var endTime = new DateTime.now();
      _demoCarController.stop();
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      // add data to dataMap for output
      dataMap[addQuotesToString("TaskVersion")] =
          addQuotesToString(taskVersion);
      dataMap[addQuotesToString("DeviceData")] = addQuotesToString(deviceData);
      dataMap['\"SubjectID\"'] = addQuotesToString(subjectId);
      dataMap['\"TrialNumber\"'] = addQuotesToString("Practice");
      dataMap['\"StartTime\"'] = addQuotesToString(startTime.toIso8601String());
      dataMap['\"EndTime\"'] = addQuotesToString(endTime.toIso8601String());
      dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
      dataMap['\"FilterCutoffFrequency\"'] =
          addQuotesToString(cutoffFreq.toString());
      dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
      dataMap['\"FilterSamplingFreq\"'] =
          addQuotesToString(samplingFreq.toString());
      dataMap['\"TotalTrials\"'] = addQuotesToString(totalTrials.toString());
      dataMap['\"ScreenSize\"'] = addQuotesToString('$width x $height');
      dataMap['\"Moves\"'] = dataList;
      _carController.stop();
      carTimer.cancel();
      _serverUpload('driving01', uuid, dataMap.toString(), '01');
      trialTimer.cancel();
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
      'practice'
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
                  Container(
                    height: lpc * .04,
                    width: lpc * .45,
                    child: Text(
                      feedbackText,
                      style: TextStyle(
                        color: textColor,
                        fontSize: lpc * 0.02,
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
                  Container(
                    height: lpc * 0.23,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: countdownColor,
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
                      height: lpc * 0.21,
                      width: lpc * 0.4,
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
                                  pointerCheck == true ? _mistrialSlider : null,
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
