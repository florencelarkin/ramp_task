import 'package:flutter/material.dart';
import 'instruction_page5.dart';

class InstructionPage4 extends StatefulWidget {
  InstructionPage4({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
  });
  final double timeMax;
  final String subjectId;
  final int totalTrials;

  @override
  _InstructionPage4State createState() => _InstructionPage4State(
      timeMax: timeMax, subjectId: subjectId, totalTrials: totalTrials);
}

class _InstructionPage4State extends State<InstructionPage4> {
  _InstructionPage4State({
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
                'Your task is to drive as quickly as possible and stop at the stop sign within ten seconds.',
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
                        builder: (context) => InstructionPage5(
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
