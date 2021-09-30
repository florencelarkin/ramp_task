import 'package:flutter/material.dart';
import 'instruction_page3.dart';
import 'package:uuid/uuid.dart';
//import 'instruction_practice.dart';

class InstructionPage2 extends StatefulWidget {
  InstructionPage2({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
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

  @override
  _InstructionPage2State createState() => _InstructionPage2State(
        timeMax: timeMax,
        subjectId: subjectId,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
      );
}

class _InstructionPage2State extends State<InstructionPage2> {
  _InstructionPage2State({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
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
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'In this task you will control a vehicle by sliding your thumb placed on a white dot at the bottom of the screen.',
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
                'You can move your thumb forward and backward on the white dot to control the speed of the car',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset("images/slider.jpg"),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                    double lpc = MediaQuery.of(context).size.height;
                    double width = MediaQuery.of(context).size.width;
                    String newId = uuid.v1();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructionPage3(
                          timeMax: timeMax,
                          lpc: lpc,
                          width: width,
                          uuid: newId,
                          totalTrials: totalTrials,
                          subjectId: subjectId,
                          iceGain: iceGain,
                          cutoffFreq: cutoffFreq,
                          order: order,
                          samplingFreq: samplingFreq,
                        ),
                      ),
                    );
                  }),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}
