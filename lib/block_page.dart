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
      this.timeMax,
      this.iceGain,
      this.cutoffFreq,
      this.order,
      this.samplingFreq,
      this.width,
      this.dataMap});
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
  final double samplingFreq;
  final double width;
  final Map dataMap;

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
        samplingFreq: samplingFreq,
        width: width,
        dataMap: dataMap,
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
    this.samplingFreq,
    this.width,
    this.dataMap,
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
  double samplingFreq;
  double width;
  Map dataMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: SelectableText(
              dataMap.toString(),
              toolbarOptions: ToolbarOptions(
                  copy: true, selectAll: true, cut: false, paste: false),
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            child: Text('START NEXT BLOCK'),
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
                    samplingFreq: samplingFreq,
                    width: width,
                    dataMap: dataMap,
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
