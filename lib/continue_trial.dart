import 'package:driving_task/car_engine.dart';
import 'package:string_validator/string_validator.dart';
import 'main_page.dart';
import 'quit_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'data.dart';
import 'package:uuid/uuid.dart';

class ContinuationPage extends StatefulWidget {
  @override
  _ContinuationPageState createState() => _ContinuationPageState();
}

class _ContinuationPageState extends State<ContinuationPage> {
  double maxVelocity;
  var uuid = Uuid();
  String subjectId = '';
  String velocityString;
  double velocity = 160.0;

  Future<Data> _futureData;

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
                'Would you like to start a new trial?',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Please enter subject ID:', //PUT THIS ON OTHER PAGE!! dont want them to enter diff ones for each trial
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
          SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Please enter preferred sensitivity:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                print(
                    'please type numbers'); //CHANGE THIS FROM PRINT TO POPUP OR SMTH
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  color: Colors.green,
                  child: Text('START'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(maxVelocity: velocity),
                      ),
                    );
                  }),
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
        ],
      ),
    );
  }
}
