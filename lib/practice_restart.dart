import 'package:flutter/material.dart';
import 'package:driving_task/practice.dart';

class RestartPractice extends StatefulWidget {
  RestartPractice({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
    @required this.iceGain,
    @required this.cutoffFreq,
    @required this.order,
    @required this.samplingFreq,
    this.width,
    this.restartText,
    this.dataMap,
  });
  final String subjectId;
  final String uuid;
  final double lpc;
  final double timeMax;
  final int totalTrials;
  final double iceGain;
  final double cutoffFreq;
  final int order;
  final double samplingFreq;
  final String restartText;
  final double width;
  final Map dataMap;

  @override
  _RestartPracticeState createState() => _RestartPracticeState(
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
        width: width,
        dataMap: dataMap,
      );
}

class _RestartPracticeState extends State<RestartPractice> {
  _RestartPracticeState({
    @required this.subjectId,
    @required this.uuid,
    this.lpc,
    this.timeMax,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.restartText,
    this.width,
    this.dataMap,
  });
  String subjectId;
  double maxVelocity;
  String uuid;
  double lpc;
  double timeMax;
  int totalTrials;
  double iceGain;
  String timeString = '0.75';
  double cutoffFreq;
  int order;
  double samplingFreq;
  String restartText;
  double width;
  Map dataMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Try again',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  restartText,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Click \'start\' to retry the practice session',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text('START'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PracticePage(
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
                          dataMap: dataMap,
                        ),
                      ),
                    );
                  }),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * .3),
            ],
          ),
        ],
      ),
    );
  }
}
