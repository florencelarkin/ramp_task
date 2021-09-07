import 'package:flutter/material.dart';
import 'instruction_page5.dart';

class InstructionPage4 extends StatefulWidget {
  InstructionPage4({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
    @required this.uuid,
    @required this.lpc,
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
                'Your task is to drive as quickly as possible and stop at the stop sign within ten seconds and keep it at the line for the remainder of the trial.',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'The image on the right end of the row shows where the optimal end point is.',
                style: TextStyle(
                    fontSize: 14.0,
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
