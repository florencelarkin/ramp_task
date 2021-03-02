import 'main_page.dart';
import 'quit_screen.dart';
import 'package:flutter/material.dart';

class ContinuationPage extends StatefulWidget {
  ContinuationPage(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber,
      this.lpc});
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;

  @override
  _ContinuationPageState createState() => _ContinuationPageState(
      subjectId: subjectId,
      uuid: uuid,
      trialNumber: trialNumber,
      blockNumber: blockNumber,
      lpc: lpc);
}

class _ContinuationPageState extends State<ContinuationPage> {
  _ContinuationPageState(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber,
      this.lpc});
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;

  String velocityString = '3.56';
  double velocity = 160.0;
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Please enter preferred sensitivity:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '(~3.55556 means it takes .75 seconds to reach stop sign if on max speed)',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'between 0 and 5 recommended'),
              onChanged: (value) {
                velocityString = value;
              },
            ),
            width: MediaQuery.of(context).size.width * 0.75,
          ),
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: Text('BACK'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  child: Text('START'),
                  onPressed: () {
                    trialNumber++;

                    if (velocityString.contains(new RegExp(r'[0-9\.]'))) {
                      if (velocityString == '.') {
                        showAlertDialog(context);
                      } else if (velocityString != '3.56') {
                        velocity = double.parse(velocityString);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(
                                maxVelocity: velocity,
                                subjectId: subjectId,
                                uuid: uuid,
                                trialNumber: trialNumber,
                                blockNumber: blockNumber,
                                lpc: lpc),
                          ),
                        );
                      } else if (velocityString == '3.56') {
                        velocity = 3.5555555555555556;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(
                              maxVelocity: velocity,
                              subjectId: subjectId,
                              uuid: uuid,
                              trialNumber: trialNumber,
                              blockNumber: blockNumber,
                              lpc: lpc,
                            ),
                          ),
                        );
                      } else {}
                    } else {
                      showAlertDialog(context);
                    }
                  }),
            ],
          ),
          ElevatedButton(
              child: Text('EXIT'),
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
    );
  }
}
