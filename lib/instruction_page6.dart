import 'package:flutter/material.dart';
import 'instruction_page7.dart';

class InstructionPage6 extends StatefulWidget {
  InstructionPage6({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
  });
  final double timeMax;
  final String subjectId;
  final int totalTrials;

  @override
  _InstructionPage6State createState() => _InstructionPage6State(
      timeMax: timeMax, subjectId: subjectId, totalTrials: totalTrials);
}

class _InstructionPage6State extends State<InstructionPage6> {
  _InstructionPage6State({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
  });
  double timeMax;
  String subjectId;
  int totalTrials;
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
                'Other notes:',
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
                '1. The timing bar will turn green when the car is getting close to the stop sign, but...',
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
                '2. The goal is still to drive as quickly as possible and stop it as close as possible to the sign.',
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
                        builder: (context) => InstructionPage7(
                          timeMax: timeMax,
                          totalTrials: totalTrials,
                          subjectId: subjectId,
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
