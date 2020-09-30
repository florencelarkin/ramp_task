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


  //add sensor for going over line
  //make sure the speed thing actually works correctly
  //put actual car image and make better bg image

  Stopwatch stopwatch = new Stopwatch()..start();
  int time = 0;
  double instVelocity = 0;
  double _lowerValue = 50;
  double _upperValue = 180;
  double width = 100;
  double carStartPos = -5;
  double joyStickPos = 0;
  double _x = 5;
  double _y = 5;



  double getAcceleration(velocity, elapsedTime) {
    double acceleration = 0;
    acceleration = velocity / elapsedTime;
    print(acceleration);
    return acceleration;
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
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
                  offset: Offset(0.0, (-.35*carStartPos+15*joyStickPos)*(1/60)),
                  child: child,
                );
              },
            ),
            /*Expanded(
              child: FlutterSlider(
                values: [_lowerValue, _upperValue],
                min: 0,
                max: 200,
                axis: Axis.vertical,
                tooltip: FlutterSliderTooltip(
                  disabled: true,
                ),
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
                        child: Icon(Icons.directions_car, size: 50),
                    ),
                  ),
                ),
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(
                    color: Colors.black.withOpacity(0)
                  ),
                  activeTrackBar: BoxDecoration(
                      color: Colors.black.withOpacity(0)
                  ),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerValue = lowerValue;
                  _upperValue = upperValue;
                  setState(() {
                    time = stopwatch.elapsedMilliseconds;
                    instVelocity = lowerValue / time;
                    //getAcceleration(instVelocity, time);
                  });
                },
              ),
            ),*/
              Container(
                child: JoystickView(
                  showArrows: false,
                  onDirectionChanged: (x,y) {
                    _x = x;
                    _y = y;
                    setState(() {
                      joyStickPos = y;
                    });
                  },
                ),
              ),
            Text('$instVelocity'),
          ],
    ),
      ),
    );
  }
}
