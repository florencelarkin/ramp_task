import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarEngine {
  CarEngine({@required this.maxVelocity, this.lpc});
  double dy = 0.0;
  double maxVelocity;
  double lpc;
  double velocity;

  double getPos(joyStickPos, getCurrentPos) {
    /*velocity = maxVelocity * lpc;
    getCurrentPos = getCurrentPos - (lpc * .4);*/
    dy = ((-.05 * getCurrentPos) + (joyStickPos * maxVelocity)) * 0.033;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }
}
