import 'package:driving_task/instruction_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(DrivingTask());

class DrivingTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: InstructionPage(),
    );
  }
}


