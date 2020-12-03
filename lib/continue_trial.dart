import 'package:driving_task/car_engine.dart';

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

  var uuid = Uuid();
  int velocity = 160;


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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text('Enter preferred max velocity below:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(velocity.toString(),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  setState(() {
                    velocity++;
                  });
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: (){
                  setState(() {
                    velocity--;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  color: Colors.green,
                  child: Text('START'),
                  onPressed: () {
                    _futureData = createData(uuid.v1(), 'data test');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(maxVelocity: velocity.toDouble()),),);
              }),
              RaisedButton(
                  color: Colors.red,
                  child: Text('EXIT'),
                  onPressed: () {
                    _futureData = createData(uuid.v1(), 'data test');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuitPage(),),);
                  }),
            ],
          ),

        ],
      ),
    );
  }
}
