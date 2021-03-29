import 'package:flutter/material.dart';
import 'continue_trial.dart';

class BlockPage extends StatefulWidget {
  BlockPage(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber,
      this.lpc,
      this.totalTrials,
      this.timeMax});
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final int totalTrials;
  final double timeMax;
  @override
  _BlockPageState createState() => _BlockPageState(
        subjectId: subjectId,
        uuid: uuid,
        trialNumber: trialNumber,
        blockNumber: blockNumber,
        lpc: lpc,
        totalTrials: totalTrials,
        timeMax: timeMax,
      );
}

class _BlockPageState extends State<BlockPage> {
  _BlockPageState(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber,
      this.lpc,
      this.totalTrials,
      this.timeMax});
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  int totalTrials;
  double timeMax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'You have completed the first block of trials',
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
                'Click \"start\" to begin the next block.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            child: Text('START'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              blockNumber++;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContinuationPage(
                    uuid: uuid,
                    subjectId: subjectId,
                    trialNumber: trialNumber,
                    blockNumber: blockNumber,
                    lpc: lpc,
                    timeMax: timeMax,
                    totalTrials: totalTrials,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
