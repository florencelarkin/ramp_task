import 'package:flutter/material.dart';
import 'dart:async';
import 'main_page.dart';

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> with TickerProviderStateMixin{

  AnimationController _countdownController;

  void initState() {
    super.initState();
    _countdownController = AnimationController(duration: Duration(seconds: 4),
        vsync: this);
    _countdownController.forward();
    _countdownController.reverse(from: _countdownController.value == 0.0 ? 1.0 : _countdownController.value);
    Timer(Duration(seconds: 4), () {
      // 5s over, navigate to a new page
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),),);
    });
  }

  String get timerString {
    Duration duration = _countdownController.duration * _countdownController.value;
    return '${(duration.inSeconds % 60).toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Driving Task'),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/countdown_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        child: AnimatedBuilder(
          animation: _countdownController,
          builder: (context, child) {
            return Center(child:
            Text(timerString,
              style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            ),
            );
          }
        ),
      ),
    );
  }
}
