import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:control_pad/control_pad.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{

  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 10),
        vsync: this)..repeat();

  }

  AnimationController _controller;


  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double instVelocity = 0;
  double _lowerValue = 50.0;
  double _upperValue = 50.0;
  double width = 100.0;
  double carStartPos = -5.0;
  double joyStickPos = 0.0;
  double getCurrentPos = 10.0;
  double dy = 0.0;

  double getPos (joyStick, currentPos) {
      dy = ((-.35*currentPos)+(-joyStick*150.0))*0.033;
      getCurrentPos = dy + currentPos;
      dy = ((-.35*getCurrentPos)+(-joyStick*150.0))*0.033;
    return dy;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driving Task'),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/graphic_design_is_my_passion.png"),
            fit: BoxFit.cover,
          ),
        ),

          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 200.0,
            ),
            AnimatedBuilder(
              animation: _controller,
              child: Container(
                width: 50.0,
                height: 50.0,
                color: Colors.black,
                child: Icon(Icons.directions_car, size: 50),
              ),
              builder: (BuildContext context, Widget child) {
                return Transform.translate(
                  offset: Offset(0.0, joyStickPos),
                  child: child,
                );
              },
            ),

            Container(
              height: 100.0,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                  thumbColor: Color(0xFFEB1555),
                  activeTrackColor: Colors.white,
                  overlayColor: Color(0x29EB1555),
                  inactiveTrackColor: Color(0xFF8D8E98),
                ),
                child: Slider(
                  value: joyStickPos,
                  min: -100.0,
                  max: 100.0,
                  onChanged: (double newValue) {
                    setState(() {
                      joyStickPos = newValue;
                    });
                  },
                ),
              ),
              /*child: FlutterSlider(
                values: [_lowerValue, _upperValue],
                min: -100,
                max: 100,
                axis: Axis.vertical,
                selectByTap: false,
                *//*tooltip: FlutterSliderTooltip(
                  disabled: true,
                ),*//*
                handlerAnimation: FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    duration: Duration(milliseconds: 500),
                    scale: 1
                ),
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Material(
                    type: MaterialType.canvas,
                    color: Colors.black.withOpacity(0),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                        child: Icon(Icons.radio_button_unchecked, size: 50),
                    ),
                  ),
                ),
                trackBar: FlutterSliderTrackBar(

                  inactiveTrackBar: BoxDecoration(
                    color: Colors.grey
                  ),
                  activeTrackBar: BoxDecoration(
                      color: Colors.grey
                  ),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerValue = lowerValue;
                  _upperValue = upperValue;
                  setState(() {
                    joyStickPos = _upperValue;

                    time = stopwatch.elapsedMilliseconds;
                    //getAcceleration(instVelocity, time);
                  });

                },
              ),*/
            ),

          ],
    ),
      ),
    );
  }
}
