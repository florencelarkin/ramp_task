import 'main_page.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class ContinuationPage extends StatefulWidget {
  ContinuationPage({
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

  @override
  _ContinuationPageState createState() => _ContinuationPageState(
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
      );
}

class _ContinuationPageState extends State<ContinuationPage> {
  _ContinuationPageState({
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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Invalid entry"),
      content: Text("Only enter numbers for this field."),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
                  'Click start to begin the next trial',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*ElevatedButton(
                  child: Text('BACK'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),*/
              /*SizedBox(
                width: 50.0,
              ),*/
              ElevatedButton(
                  child: Text('START'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    trialNumber++;
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
