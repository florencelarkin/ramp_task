import 'dart:io';
import 'package:driving_task/continue_trial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'car_engine.dart';
import 'data.dart';
import 'package:flutter/foundation.dart';
import 'block_page.dart';
import 'completed_screen.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'restart_page.dart';
import 'package:flutter/widgets.dart';

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
  });
  double timeMax;
  String subjectId;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  int totalTrials;
  double iceGain;
  double cutoffFreq;
  int order;
  double samplingFreq;

  final browser = Browser.detectOrNull();

  AnimationController _timerController;
  AnimationController _carController;
  AnimationController _countdownController;
  Timer carTimer;
  Timer colorTimer;
  Timer dataTimer;
  Timer serverTimeout;
  Timer trialTimer;

  bool webFlag = false; // true if running web
  String platformType = ""; // the platform: android, ios, windows, linux
  final String taskVersion = "driving_task:0.9";
  String browserType = "";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  void checkWebPlatform() {
    // check the platform and whether web
    kIsWeb
        ? platformType = 'Web Browser'
        : Platform.isAndroid
            ? platformType = 'Android'
            : Platform.isIOS
                ? platformType = 'iOS'
                : Platform.isLinux
                    ? platformType = 'Linux'
                    : Platform.isMacOS
                        ? platformType = 'MacOS'
                        : Platform.isWindows
                            ? platformType = 'Windows'
                            : platformType = '';
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double carStartPos = -5.0;
  double sliderPos = 0.0;
  double getCurrentPos = 0.0;
  double dy = 0.0;
  Color timerColor = Colors.blue;
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
  bool pointerCheck = false;
  var startTime = new DateTime.now();
  Color textColor = Colors.black;
  String feedbackText = '';

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
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
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

  void _pointerCheck(PointerEvent details) {
    setState(() {
      pointerCheck = true;
    });
  }

  _serverUpload(studycode, guid, dataList, data_version) async {
    bool dataSent = await createData(studycode, guid, dataList, data_version);
    if (dataSent == true) {
      if (posList[0] > -1.3 && posList[0] < -.6) {
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
            ),
          ),
        );
      }
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

  void _mistrialSlider(PointerEvent details) {
    setState(() {
      dataMap[addQuotesToString("TaskVersion")] =
          addQuotesToString(taskVersion);
      dataMap[addQuotesToString("Platform")] = addQuotesToString(platformType);
      /*dataMap[addQuotesToString("Web")] = webFlag;
      dataMap[addQuotesToString("Browser")] = addQuotesToString(browserType);*/
      //dataMap[addQuotesToString("DartVersion")] = addQuotesToString(Platform.version);
      // has double quoted android_ia32
      dataMap[addQuotesToString("DeviceData")] = _deviceData;
      dataMap[addQuotesToString("SubjectID")] = addQuotesToString(subjectId);
      dataMap['\"TrialNumber\"'] = addQuotesToString(trialNumber.toString());
      dataMap['\"StartTime\"'] = addQuotesToString(startTime.toIso8601String());
      dataMap['\"EndTime\"'] =
          addQuotesToString(DateTime.now().toIso8601String());
      dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
      dataMap['\"FilterCutoffFrequency\"'] =
          addQuotesToString(cutoffFreq.toString());
      dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
      dataMap['\"FilterSamplingFeq\"'] =
          addQuotesToString(samplingFreq.toString());
      dataMap['\"TotalTrials\"'] = addQuotesToString(totalTrials.toString());
      dataMap['\"ScreenSize\"'] = addQuotesToString('$lpc'); //fix this later
      dataMap[addQuotesToString("CompletedTrial")] = addQuotesToString('no');
      dataMap['\"Moves\"'] = dataList;
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
      carTimer.cancel();
      colorTimer.cancel();
      trialTimer.cancel();
      createData('driving01', uuid, dataMap.toString(), '01');
      //_serverUpload('driving01', uuid, dataMap.toString(), '01');
      trialTimer.cancel();
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
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    CarEngine carEngine = CarEngine(
      timeMax: timeMax,
      lpc: lpc,
      trialNumber: trialNumber,
      urlGain: iceGain,
      cutoffFreq: cutoffFreq,
      order: order,
      samplingFreq: samplingFreq,
    );
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
      setState(() {
        prevTime = currentTime;
        currentTime = stopwatch.elapsedMilliseconds.toDouble();
        if (posList[0] < -2.0 || posList[0] > 1.0) {
          //if you go off the screen in either direction
          dataMap[addQuotesToString("TaskVersion")] =
              addQuotesToString(taskVersion);
          dataMap[addQuotesToString("Platform")] =
              addQuotesToString(platformType);
          /*dataMap[addQuotesToString("Web")] = webFlag;
      dataMap[addQuotesToString("Browser")] = addQuotesToString(browserType);*/
          //dataMap[addQuotesToString("DartVersion")] = addQuotesToString(Platform.version);
          // has double quoted android_ia32
          dataMap[addQuotesToString("DeviceData")] = _deviceData;
          dataMap[addQuotesToString("SubjectID")] =
              addQuotesToString(subjectId);
          dataMap['\"TrialNumber\"'] =
              addQuotesToString(trialNumber.toString());
          dataMap['\"StartTime\"'] =
              addQuotesToString(startTime.toIso8601String());
          dataMap['\"EndTime\"'] =
              addQuotesToString(DateTime.now().toIso8601String());
          dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
          dataMap['\"FilterCutoffFrequency\"'] =
              addQuotesToString(cutoffFreq.toString());
          dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
          dataMap['\"FilterSamplingFeq\"'] =
              addQuotesToString(samplingFreq.toString());
          dataMap['\"TotalTrials\"'] =
              addQuotesToString(totalTrials.toString());
          dataMap['\"ScreenSize\"'] =
              addQuotesToString('$lpc'); //fix this later
          dataMap[addQuotesToString("CompletedTrial")] =
              addQuotesToString('no');
          dataMap['\"Moves\"'] = dataList;
          _timerController.stop();
          _carController.stop();
          _countdownController.stop();
          carTimer.cancel();
          colorTimer.cancel();
          trialTimer.cancel();
          createData('driving01', uuid, dataMap.toString(), '01');
          //_serverUpload('driving01', uuid, dataMap.toString(), '01');
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
    colorTimer = Timer.periodic(
        Duration(milliseconds: 17),
        (Timer t) => posList[1] < -lpc * .25 && posList[1] > -lpc * .435
            ? timerColor = Colors.green
            : timerColor = Colors.blue);
    //Timer for the end of the trial
    trialTimer = Timer(Duration(seconds: 14), () {
      var endTime = new DateTime.now();
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      // add data to dataMap for output
      dataMap[addQuotesToString("TaskVersion")] =
          addQuotesToString(taskVersion);
      dataMap[addQuotesToString("Platform")] = addQuotesToString(platformType);
      /*dataMap[addQuotesToString("Web")] = webFlag;
      dataMap[addQuotesToString("Browser")] = addQuotesToString(browserType);*/
      //dataMap[addQuotesToString("DartVersion")] = addQuotesToString(Platform.version);
      // has double quoted android_ia32
      dataMap[addQuotesToString("DeviceData")] = _deviceData;

      dataMap[addQuotesToString("SubjectID")] = addQuotesToString(subjectId);
      dataMap['\"TrialNumber\"'] = addQuotesToString(trialNumber.toString());
      dataMap['\"StartTime\"'] = addQuotesToString(startTime.toIso8601String());
      dataMap['\"EndTime\"'] = addQuotesToString(endTime.toIso8601String());
      dataMap['\"Sensitivity\"'] = addQuotesToString(timeMax.toString());
      dataMap['\"FilterCutoffFrequency\"'] =
          addQuotesToString(cutoffFreq.toString());
      dataMap['\"FilterOrder\"'] = addQuotesToString(order.toString());
      dataMap['\"FilterSamplingFeq\"'] =
          addQuotesToString(samplingFreq.toString());
      dataMap['\"TotalTrials\"'] = addQuotesToString(totalTrials.toString());
      dataMap['\"ScreenSize\"'] = addQuotesToString('$width x $height');
      dataMap[addQuotesToString("CompletedTrial")] = addQuotesToString('yes');
      dataMap['\"Moves\"'] = dataList;
      _timerController.stop();
      _carController.stop();
      _countdownController.stop();
      carTimer.cancel();
      colorTimer.cancel();
      trialTimer.cancel();
      //dataTimer.cancel();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .09,
                  width: MediaQuery.of(context).size.width * .45,
                  child: Text(
                    feedbackText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 30.0,
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
                // Slider
                Container(
                  height: lpc * 0.30,
                  width: 300.0,
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
                              ? _mistrialSlider
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
          ],
        ),
      ),
    );
  }
}
