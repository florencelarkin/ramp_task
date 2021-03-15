import 'package:flutter/material.dart';
import 'instruction_page2.dart';

class InstructionPage extends StatefulWidget {
  InstructionPage({
    @required this.timeMax,
    @required this.subjectId,
    @required this.totalTrials,
  });
  final double timeMax;
  final String subjectId;
  final int totalTrials;

  @override
  _InstructionPageState createState() => _InstructionPageState(
      timeMax: timeMax, subjectId: subjectId, totalTrials: totalTrials);
}

class _InstructionPageState extends State<InstructionPage> {
  _InstructionPageState({
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
                'Driving Task',
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
                'Please read the following instructions carefully before starting.',
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
                'If you have any questions about the experiment, please ask the experimenter.',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ElevatedButton(
              child: Text('NEXT'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionPage2(
                      totalTrials: totalTrials,
                      timeMax: timeMax,
                      subjectId: subjectId,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
