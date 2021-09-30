import 'package:flutter/material.dart';
import 'block_page.dart';
import 'completed_screen.dart';
import 'continue_trial.dart';

class AlertDialogClass {
  AlertDialogClass({
    this.trialNumber,
    this.totalTrials,
    this.subjectId,
    this.uuid,
    this.blockNumber,
    this.lpc,
    this.timeMax,
    this.iceGain,
    this.cutoffFreq,
    this.samplingFreq,
    this.order,
    this.webFlag,
    this.title,
    this.message,
  });
  int trialNumber;
  int totalTrials;
  String subjectId;
  String uuid;
  int blockNumber;
  double lpc;
  double timeMax;
  double iceGain;
  double samplingFreq;
  double cutoffFreq;
  int order;
  bool webFlag;
  String title;
  String message;

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text('OK'),
      onPressed: () {
        if (trialNumber == totalTrials / 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlockPage(
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
              ),
            ),
          );
        } else if (trialNumber != totalTrials) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContinuationPage(
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
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedPage(
                  webFlag: webFlag,
                ),
              ));
        }
      },
    );
  }
}
