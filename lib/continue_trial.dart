import 'package:string_validator/string_validator.dart';
import 'main_page.dart';
import 'quit_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'data.dart';
import 'package:uuid/uuid.dart';

class ContinuationPage extends StatefulWidget {
  ContinuationPage({@required this.subjectId, @required this.uuid});
  final String subjectId;
  final String uuid;
  @override
  _ContinuationPageState createState() =>
      _ContinuationPageState(subjectId: subjectId, uuid: uuid);
}

class _ContinuationPageState extends State<ContinuationPage> {
  _ContinuationPageState({@required this.subjectId, @required this.uuid});
  String subjectId;
  double maxVelocity;
  String uuid;

  String velocityString;
  double velocity = 160.0;

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
          TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: '160'),
            onChanged: (value) {
              velocityString = value;
              bool isValid = isNumeric(velocityString);
              if (isValid == true) {
                velocity = double.parse(velocityString);
              } else {
                print('please type numbers');
              }
            },
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
                          maxVelocity: velocity,
                          subjectId: subjectId,
                          uuid: uuid,
                        ),
                      ),
                    );
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
