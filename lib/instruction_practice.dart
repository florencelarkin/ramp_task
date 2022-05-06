import 'package:flutter/material.dart';
import 'package:driving_task/practice.dart';

class InstructionPractice extends StatefulWidget {
  InstructionPractice({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
    @required this.uuid,
    @required this.lpc,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
  });
  final double timeMax;
  final String subjectId;
  final int totalTrials;
  final double iceGain;
  final double cutoffFreq;
  final int order;
  final double samplingFreq;
  final String uuid;
  final double lpc;
  final double width;

  @override
  _InstructionPracticeState createState() => _InstructionPracticeState(
        timeMax: timeMax,
        subjectId: subjectId,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
        uuid: uuid,
        lpc: lpc,
        width: width,
      );
}

class _InstructionPracticeState extends State<InstructionPractice> {
  _InstructionPracticeState({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
    @required this.uuid,
    @required this.lpc,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
  });
  double timeMax;
  String subjectId;
  int totalTrials;
  double iceGain;
  double cutoffFreq;
  int order;
  double samplingFreq;
  String uuid;
  double lpc;
  double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'The practice will begin after you hold your thumb on the dot for 3 seconds',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'The practice will restart if you:',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '1. remove your thumb from the screen',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '2. do not stay close enough to the red car or drive off the screen',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  child: Text('BACK'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
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
                          subjectId: subjectId,
                          uuid: uuid,
                          lpc: lpc,
                          width: width,
                          totalTrials: totalTrials,
                          timeMax: timeMax,
                          iceGain: iceGain,
                          cutoffFreq: cutoffFreq,
                          order: order,
                          samplingFreq: samplingFreq,
                          dataMap: {},
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
