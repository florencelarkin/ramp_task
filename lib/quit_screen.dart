import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuitPage extends StatefulWidget {
  @override
  _QuitPageState createState() => _QuitPageState();
}

class _QuitPageState extends State<QuitPage> {

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
              child: Text('Thanks for participating!',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          RaisedButton(
              color: Colors.green,
              child: Text('CLICK HERE TO EXIT THE APP'),
              onPressed: ()=> SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
