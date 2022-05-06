import 'package:flutter/material.dart';
import 'continue_trial.dart';
import 'main_page.dart';

class InstructionPage7 extends StatefulWidget {
  InstructionPage7({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.lpc,
    this.uuid,
    this.dataMap,
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
  final Map dataMap;

  @override
  _InstructionPage7State createState() => _InstructionPage7State(
        timeMax: timeMax,
        subjectId: subjectId,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
        lpc: lpc,
        uuid: uuid,
        width: width,
        dataMap: dataMap,
      );
}

class _InstructionPage7State extends State<InstructionPage7> {
  _InstructionPage7State({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.uuid,
    this.lpc,
    this.dataMap,
  });
  double timeMax;
  String subjectId;
  int totalTrials;
  double iceGain;
  double cutoffFreq;
  int order;
  double samplingFreq;
  double lpc;
  String uuid;
  double width;
  Map dataMap;

  int trialNumber = 0;
  int blockNumber = 1;

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
                'If you have any questions or comments, please leave them in the feedback survey after the trials.',
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
                'Click next when you are ready to begin.',
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
                  child: Text('NEXT'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
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
