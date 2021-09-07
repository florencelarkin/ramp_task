import 'package:flutter/material.dart';
import 'instruction_page6.dart';

class InstructionPage5 extends StatefulWidget {
  InstructionPage5({
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
  _InstructionPage5State createState() => _InstructionPage5State(
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

class _InstructionPage5State extends State<InstructionPage5> {
  _InstructionPage5State({
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
                'Important:',
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
                '- Keep your finger on the slider throughout the task',
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
                '- Try your best to keep your car within the white lines',
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
                '- Driving off the screen or lifting your finger off the slider will cause the trial to restart.',
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
                        builder: (context) => InstructionPage6(
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
