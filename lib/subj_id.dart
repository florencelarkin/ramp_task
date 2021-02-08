import 'package:flutter/material.dart';
import 'continue_trial.dart';
import 'package:uuid/uuid.dart';

class SubjectIDPage extends StatefulWidget {
  @override
  _SubjectIDPageState createState() => _SubjectIDPageState();
}

class _SubjectIDPageState extends State<SubjectIDPage> {
  String subjectId;
  var uuid = Uuid();
  int trialNumber = 0;
  int blockNumber = 1;

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("No subject ID entered"),
      content: Text("Please enter a subject ID before continuing."),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Please enter subject ID:',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter Subject ID'),
              onChanged: (value) {
                subjectId = value;
              },
            ),
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          SizedBox(
            height: 100.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  color: Colors.blue,
                  child: Text('BACK'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              RaisedButton(
                  color: Colors.green,
                  child: Text('NEXT'),
                  onPressed: () {
                    if (subjectId == null) {
                      showAlertDialog(context);
                    } else {
                      String newId = uuid.v1();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContinuationPage(
                            subjectId: subjectId,
                            uuid: newId,
                            trialNumber: trialNumber,
                            blockNumber: blockNumber,
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
