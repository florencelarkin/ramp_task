import 'main_page.dart';
import 'package:flutter/material.dart';

class RestartPage extends StatefulWidget {
  RestartPage({
    @required this.subjectId,
    @required this.uuid,
    @required this.trialNumber,
    @required this.blockNumber,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
    @required this.iceGain,
    @required this.cutoffFreq,
    @required this.order,
    @required this.samplingFreq,
    @required this.feedbackText,
    @required this.width,
    @required this.dataMap,
  });
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final double timeMax;
  final int totalTrials;
  final double iceGain;
  final double cutoffFreq;
  final int order;
  final double samplingFreq;
  final String feedbackText;
  final double width;
  final Map dataMap;

  @override
  _RestartPageState createState() => _RestartPageState(
        subjectId: subjectId,
        uuid: uuid,
        trialNumber: trialNumber,
        blockNumber: blockNumber,
        lpc: lpc,
        timeMax: timeMax,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
        feedbackText: feedbackText,
        width: width,
        dataMap: dataMap,
      );
}

class _RestartPageState extends State<RestartPage> {
  _RestartPageState({
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.timeMax,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.feedbackText,
    this.width,
    this.dataMap,
  });
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  double timeMax;
  int totalTrials;
  double iceGain;
  String timeString = '0.75';
  double cutoffFreq;
  int order;
  double samplingFreq;
  String feedbackText;
  double width;
  Map dataMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Try Again',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  feedbackText,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Click \'start\' to retry the trial',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text('START'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
                          timeMax: timeMax,
                          subjectId: subjectId,
                          uuid: uuid,
                          trialNumber: trialNumber,
                          blockNumber: blockNumber,
                          lpc: lpc,
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
                  }),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
            ],
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }
}
