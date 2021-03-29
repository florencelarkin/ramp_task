class CarEngine {
  CarEngine({this.timeMax, this.lpc, this.trialNumber});
  int trialNumber;
  double dy = 0.0; // incremental position change for a unit of time
  double timeMax; // time to go from start to finish line at maximum velocity
  double lpc; // logical pixel count for the y dimension of the screen
  double aW; // scaled velocity based on the timeMax and lpc (for which units?)
  double eqPoint =
      0.35; //equilibrium point from original formula, should be scaled by distance
  double adjustedPos; //y position scaled by the logical pixel count
  double dt = 1.0 / 60.0; //frame rate
  double eqFactor = 1.0;
  double dipFactor = 0.0;
// https://api.flutter.dev/flutter/widgets/MediaQuery-class.html
  //eq point is about 0.96788990825 percent of distance (in original formula)
  //so -(lpc * .45) * ~.03  should be eq point

  double getPos(joyStickPos, getCurrentPos, timeMax) {
    /*if ( (getCurrentPos - eqPoint) < eqFactor*eqPoint ) {
      // move car position backwards to force the user to move joystick forward
      // by adding a negative velocity
      dipFactor = - 0.10;
    } else {
      dipFactor = 0.0;
    }

    dy = (dipFactor +  joyStickPos * aW) * dt; */ //code for the dip factor, to test 3/30

    aW = (1.0 / timeMax) * lpc;
    //eqPoint = (lpc * 0.45) * 0.03;
    //adjustedPos = getCurrentPos * lpc;
    //testing take out eq point terms
    //dy = -eqPoint*getCurrentPos + (joyStickPos * aW) * dt
    dy = (joyStickPos * aW) * dt;
    dy = dy /
        timeMax; //added in later for testing, this currently works almost perfectly with 0.75 seconds
    //dy = ((-eqPoint * getCurrentPos) + (joyStickPos * aW)) * dt;
    getCurrentPos = (dy + getCurrentPos);
    return getCurrentPos;
  }
}
