import 'package:driving_task/instruction_page.dart';
import 'package:flutter/material.dart';
import 'url_args.dart';

void main() => runApp(DrivingTask());

Map<String, String> urlArgs = {};
String subjectID = 'cutoffFreqTest';
int totalTrials = 20;
double maxTime = 0.75;
String defaultTitle = 'test page';
double iceGain = 1.0;
double cutoffFreq = 10.0;
int order = 2;
double samplingFreq = 60.0;

class DrivingTask extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: InstructionPage(
        subjectId: subjectID,
        totalTrials: totalTrials,
        timeMax: maxTime,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
      ),
      onGenerateRoute: (settings) {
        print("settings.name " + settings.name);

        urlArgs = getURLArgs(settings.name);
        urlArgs.forEach((key, value) => print('${key}: ${value}'));

        if (urlArgs.containsKey('trials')) {
          totalTrials = int.parse(urlArgs['trials']);
        }
        if (urlArgs.containsKey('id')) {
          subjectID = urlArgs['id'];
        }
        if (urlArgs.containsKey('time')) {
          maxTime = double.parse(urlArgs['time']);
        }
        if (urlArgs.containsKey('ice')) {
          iceGain = double.parse(urlArgs['ice']);
        }
        if (urlArgs.containsKey('cutoff')) {
          cutoffFreq = double.parse(urlArgs['cutoff']);
        }
        if (urlArgs.containsKey('order')) {
          order = int.parse(urlArgs['order']);
        }
        if (urlArgs.containsKey('sample')) {
          samplingFreq = double.parse(urlArgs['sample']);
        }

        // check for /?id=1234&time=2.0
        switch (settings.name[1]) {
          case '?':
            return MaterialPageRoute(
              builder: (context) => InstructionPage(
                subjectId: subjectID,
                timeMax: maxTime,
                totalTrials: totalTrials,
                iceGain: iceGain,
                cutoffFreq: cutoffFreq,
                order: order,
                samplingFreq: samplingFreq,
              ),
            );
            break;
          default:
            return MaterialPageRoute(
              builder: (context) => InstructionPage(
                subjectId: "default",
                totalTrials: 1,
                timeMax: 1.0,
                iceGain: 1.0,
                cutoffFreq: 50.0,
                order: 2,
                samplingFreq: 60.0,
              ),
            );
        }
      },
    );
  }
}
/*
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionPage(
                      subjectId: subjectID,
                      timeMax: maxTime,
                      totalTrials: totalTrials,
                    ),
                  ),
                );
              },
              child: Text(
                'CONFIRM',
                style: Theme.of(context).textTheme.headline4,
              ),
            )
          ],
        ),
      ),
    );
  }
}*/
