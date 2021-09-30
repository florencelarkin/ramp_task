import 'package:flutter/material.dart';
import 'instruction_page5.dart';

class InstructionPage4 extends StatefulWidget {
  InstructionPage4({
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
  _InstructionPage4State createState() => _InstructionPage4State(
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

class _InstructionPage4State extends State<InstructionPage4> {
  _InstructionPage4State({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
    @required this.uuid,
    @required this.lpc,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.width,
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
                'Now we will go over instructions for the main task.',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'There will be a set of 10-second trials where your task is to drive to a stop sign as quickly as possible and then keep the car at the line for the remainder of the trial.',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset("images/beforeline.png"),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset("images/afterline.png"),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset("images/line.png"),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
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
                        builder: (context) => InstructionPage5(
                          timeMax: timeMax,
                          totalTrials: totalTrials,
                          subjectId: subjectId,
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
        ],
      ),
    );
  }
}
