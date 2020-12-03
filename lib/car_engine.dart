
import 'package:flutter/cupertino.dart';

class CarEngine {
  CarEngine({@required this.maxVelocity});
  double dy = 0.0;
  double maxVelocity;


  double getPos (joyStickPos, getCurrentPos) {
    dy = ((-.05 * getCurrentPos) +
        (joyStickPos * maxVelocity)) * 0.033;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }



}