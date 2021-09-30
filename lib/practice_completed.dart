import 'package:flutter/material.dart';
import 'instruction_page4.dart';

class PracticeCompleted extends StatefulWidget {
  PracticeCompleted({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
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
  final double width;

  @override
  _PracticeCompletedState createState() => _PracticeCompletedState(
        subjectId: subjectId,
        uuid: uuid,
        lpc: lpc,
        timeMax: timeMax,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
        width: width,
      );
}

class _PracticeCompletedState extends State<PracticeCompleted> {
  _PracticeCompletedState({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
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
  double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Congratulations!',
                  style: TextStyle(
                      fontSize: 30.0,
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
                  'You have completed the practice session.',
                  style: TextStyle(
                      fontSize: 25.0,
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
                  'Click \'NEXT\' to read the additional instructions for the task',
                  style: TextStyle(
                      fontSize: 25.0,
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
                  child: Text('NEXT'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructionPage4(
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
