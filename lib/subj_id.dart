import 'package:flutter/material.dart';
import 'continue_trial.dart';

class SubjectIDPage extends StatefulWidget {
  @override
  _SubjectIDPageState createState() => _SubjectIDPageState();
}

class _SubjectIDPageState extends State<SubjectIDPage> {
  String subjectId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter Subject ID'),
            onChanged: (value) {
              subjectId = value;
            },
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContinuationPage(
                          subjectId: subjectId,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
