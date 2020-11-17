import 'package:flutter/material.dart';
import 'continue_trial.dart';

class InstructionPage extends StatefulWidget {
  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {

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
              child: Text('When running the task, start with your thumb on the screen,  on the vertical line.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text('You can then slide your thumb forwards or backwards to move the car.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text('Do not lift your thumb from the screen during the entire task.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          RaisedButton(
              color: Colors.green,
              child: Text('BEGIN'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContinuationPage(),),);
              }),
        ],
      ),
    );
  }
}
