import 'package:flutter/material.dart';
import 'continue_trial.dart';

class BlockPage extends StatefulWidget {
  BlockPage({
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.totalTrials,
    this.timeMax,
    this.iceGain,
    this.cutoffFreq,
    this.order,
  });
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final int totalTrials;
  final double timeMax;
  final double iceGain;
  final double cutoffFreq;
  final int order;

  @override
  _BlockPageState createState() => _BlockPageState(
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
      );
}

class _BlockPageState extends State<BlockPage> {
  _BlockPageState({
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.totalTrials,
    this.timeMax,
    this.iceGain,
    this.cutoffFreq,
    this.order,
  });
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  int totalTrials;
  double timeMax;
  double iceGain;
  double cutoffFreq;
  int order;

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
                    iceGain: iceGain,
                    cutoffFreq: cutoffFreq,
                    order: order,
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
