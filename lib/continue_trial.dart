import 'main_page.dart';
import 'quit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContinuationPage extends StatefulWidget {
  ContinuationPage({
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.timeMax,
    this.totalTrials,
  });
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final double timeMax;
  final int totalTrials;

  @override
  _ContinuationPageState createState() => _ContinuationPageState(
        subjectId: subjectId,
        uuid: uuid,
        trialNumber: trialNumber,
        blockNumber: blockNumber,
        lpc: lpc,
        timeMax: timeMax,
        totalTrials: totalTrials,
      );
}

class _ContinuationPageState extends State<ContinuationPage> {
  _ContinuationPageState(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber,
      this.lpc,
      this.timeMax,
      this.totalTrials});
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  double timeMax;
  int totalTrials;
  String timeString = '0.75';
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
          /*Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Please enter time for car to reach stop sign:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: timeString),
              onChanged: (value) {
                timeString = value;
              },
            ),
            width: MediaQuery.of(context).size.width * 0.75,
          ),*/
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: Text('BACK'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    Navigator.pop(context);
                  }),
              SizedBox(
                width: 50.0,
              ),
              ElevatedButton(
                  child: Text('START'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    trialNumber++;
                    /*SystemChannels.textInput.invokeMethod('TextInput.hide');
                    if (timeString.contains(new RegExp(r'[0-9\.]'))) {
                      if (timeString == '.') {
                        showAlertDialog(context);
                      } else if (timeString != '.75') {
                        timeMax = double.tryParse(timeString);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(
                                timeMax: timeMax,
                                subjectId: subjectId,
                                uuid: uuid,
                                trialNumber: trialNumber,
                                blockNumber: blockNumber,
                                lpc: lpc),
                          ),
                        );
                      } else {
                        timeMax = 0.75;
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
                            ),
                          ),
                        );
                      }
                    } else {
                      showAlertDialog(context);
                    }*/
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
              ElevatedButton(
                  child: Text('EXIT'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuitPage(
                          uuid: uuid,
                          subjectId: subjectId,
                          lpc: lpc,
                          blockNumber: blockNumber,
                          trialNumber: trialNumber,
                        ),
                      ),
                    );
                  }),
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
