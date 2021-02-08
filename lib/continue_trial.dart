import 'package:string_validator/string_validator.dart';
import 'main_page.dart';
import 'quit_screen.dart';
import 'package:flutter/material.dart';

class ContinuationPage extends StatefulWidget {
  ContinuationPage(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber});
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;

  @override
  _ContinuationPageState createState() => _ContinuationPageState(
      subjectId: subjectId,
      uuid: uuid,
      trialNumber: trialNumber,
      blockNumber: blockNumber);
}

class _ContinuationPageState extends State<ContinuationPage> {
  _ContinuationPageState(
      {@required this.subjectId,
      @required this.uuid,
      this.trialNumber,
      this.blockNumber});
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;

  String velocityString = '160.0';
  double velocity = 160.0;
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
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
                'Would you like to start a new trial?',
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
          Container(
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: '160'),
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
              RaisedButton(
                  color: Colors.blue,
                  child: Text('BACK'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              RaisedButton(
                  color: Colors.green,
                  child: Text('START'),
                  onPressed: () {
                    trialNumber++;
                    bool isValid = isNumeric(velocityString);
                    if (isValid == true) {
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
                          ),
                        ),
                      );
                    } else if (velocityString == '160.0') {
                      velocity = 160.0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(
                            maxVelocity: velocity,
                            subjectId: subjectId,
                            uuid: uuid,
                            trialNumber: trialNumber,
                            blockNumber: blockNumber,
                          ),
                        ),
                      );
                    } else {
                      showAlertDialog(context);
                    }
                  }),
            ],
          ),
          RaisedButton(
              color: Colors.red,
              child: Text('EXIT'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuitPage(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
