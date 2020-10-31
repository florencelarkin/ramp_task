import 'package:driving_task/countdown_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'data.dart';

class ContinuationPage extends StatefulWidget {
  @override
  _ContinuationPageState createState() => _ContinuationPageState();
}

class _ContinuationPageState extends State<ContinuationPage> {

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
              child: Text('Would you like to start a new trial?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
      ),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          RaisedButton(
              color: Colors.green,
              child: Text('YES'),
              onPressed: () {
                _futureData = createData('data test');
                Navigator.push(context, MaterialPageRoute(builder: (context) => CountdownPage(),),);
          })
        ],
      ),
    );
  }
}
