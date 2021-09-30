import 'package:flutter/material.dart';
import 'block_page.dart';
import 'completed_screen.dart';
import 'continue_trial.dart';
import 'practice_completed.dart';

class AlertDialogClass {
  AlertDialogClass();

  showAlertDialog(
      BuildContext context,
      String subjectId,
      String uuid,
      int trialNumber,
      int blockNumber,
      double lpc,
      double timeMax,
      int totalTrials,
      double iceGain,
      double cutoffFreq,
      double samplingFreq,
      int order,
      bool webFlag,
      String title,
      String messageText,
      bool practiceFlag) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text('OK'),
      onPressed: () {
        if (practiceFlag == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PracticeCompleted(
                  lpc: lpc,
                  subjectId: subjectId,
                  uuid: uuid,
                  cutoffFreq: cutoffFreq,
                  iceGain: iceGain,
                  timeMax: timeMax,
                  totalTrials: totalTrials,
                  samplingFreq: samplingFreq,
                  order: order,
                ),
              ));
        } else {
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
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("$title"),
      content: Text("$messageText"),
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
}
