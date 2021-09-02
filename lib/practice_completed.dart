import 'package:flutter/material.dart';
import 'instruction_page7.dart';

class PracticeCompleted extends StatefulWidget {
  PracticeCompleted({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
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
      );
}

class _PracticeCompletedState extends State<PracticeCompleted> {
  _PracticeCompletedState({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
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
                  'Click \'start\' to begin the task!',
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
                  child: Text('START'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructionPage7(
                          timeMax: timeMax,
                          subjectId: subjectId,
                          totalTrials: totalTrials,
                          iceGain: iceGain,
                          cutoffFreq: cutoffFreq,
                          order: order,
                          samplingFreq: samplingFreq,
                          uuid: uuid,
                          lpc: lpc,
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
