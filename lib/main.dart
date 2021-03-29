import 'package:driving_task/instruction_page.dart';
import 'package:flutter/material.dart';
import 'url_args.dart';

void main() => runApp(DrivingTask());

Map<String, String> urlArgs = {};
String subjectID = 'abc123';
int totalTrials = 20;
double maxTime = 3.0;
String defaultTitle = 'test page';

/*class DrivingTask extends StatelessWidget {
  List<String> pathComponents;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: InstructionPage(title: defaultTitle),
      onGenerateRoute: (settings) {
    print("settings.name " + settings.name);

    urlArgs = getURLArgs(settings.name);
    urlArgs.forEach((key, value) => print('${key}: ${value}'));

    if  (urlArgs.containsKey('count')) {
    _counter = int.parse(urlArgs['count']);
    }
    if  (urlArgs.containsKey('title')) {
    defaultTitle = urlArgs['title'];
    },
    );
  }
}
}*/
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

        // check for /?id=1234&time=2.0
        switch (settings.name[1]) {
          case '?':
            return MaterialPageRoute(
              builder: (context) => InstructionPage(
                subjectId: subjectID,
                timeMax: maxTime,
                totalTrials: totalTrials,
              ),
            );
            break;
          default:
            return MaterialPageRoute(
              builder: (context) => InstructionPage(
                subjectId: "default",
                totalTrials: 1,
                timeMax: 1.0,
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
