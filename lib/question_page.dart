import 'completed_screen.dart';
import 'main_page.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage(
      {@required this.subjectId,
      @required this.uuid,
      this.timeMax,
      this.trialNumber,
      this.blockNumber,
      this.lpc});
  final String subjectId;
  final String uuid;
  final double timeMax;
  final int trialNumber;
  final int blockNumber;
  final double lpc;

  @override
  _QuestionPageState createState() => _QuestionPageState(
      subjectId: subjectId,
      uuid: uuid,
      timeMax: timeMax,
      trialNumber: trialNumber,
      blockNumber: blockNumber,
      lpc: lpc);
}

class _QuestionPageState extends State<QuestionPage> {
  _QuestionPageState(
      {@required this.subjectId,
      @required this.uuid,
      this.timeMax,
      this.trialNumber,
      this.blockNumber,
      this.lpc});
  String subjectId;
  double timeMax;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  Color buttonColor = Colors.white;
  String velocityString = '160.0';
  double velocity = 160.0;
  String a1;
  String a2;
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Stop!"),
      content: Text("Please answer questions before continuing"),
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
                'On a scale of 1 - 5, how difficult was this task? (1 being very easy to 5 being very hard)',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('1'),
                  Text('2'),
                  Text('3'),
                  Text('4'),
                  Text('5'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a1 = '1';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a1 = '2';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a1 = '3';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a1 = '4';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a1 = '5';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'How engaged were you on this task? (1 being not at all to 5 being very engaged)',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('1'),
                  Text('2'),
                  Text('3'),
                  Text('4'),
                  Text('5'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a2 = '1';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      padding: EdgeInsets.all(5.0),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a2 = '2';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a2 = '3';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a2 = '4';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        buttonColor = Colors.green;
                        a2 = '5';
                      },
                      elevation: 2.0,
                      fillColor: buttonColor,
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Click to start the next block of trials',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: Text('START'),
                  onPressed: () {
                    trialNumber++;
                    blockNumber++;
                    if (a1 != null || a2 != null) {
                      blockNumber == 3
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompletedPage(),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                    timeMax: velocity,
                                    subjectId: subjectId,
                                    uuid: uuid,
                                    trialNumber: trialNumber,
                                    blockNumber: blockNumber,
                                    lpc: lpc),
                              ),
                            );
                    } else {
                      showAlertDialog(context);
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
