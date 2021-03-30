import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompletedPage extends StatefulWidget {
  CompletedPage({
    this.webFlag,
  });
  final bool webFlag;
  @override
  _CompletedPageState createState() => _CompletedPageState(webFlag: webFlag);
}

class _CompletedPageState extends State<CompletedPage> {
  _CompletedPageState({
    this.webFlag,
  });
  bool webFlag; //true if on web
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
                'Thanks for participating! You have completed all the trials!',
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
              child: (webFlag == true)
                  ? Text(
                      'You may now exit the tab.',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'You may now delete the app',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          Visibility(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Text('CLICK HERE TO EXIT THE APP'),
                onPressed: () => SystemNavigator.pop(),
              ),
              visible: (webFlag == true) ? false : true),
        ],
      ),
    );
  }
}
