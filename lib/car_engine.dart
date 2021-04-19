class CarEngine {
  CarEngine({this.timeMax, this.lpc, this.trialNumber, this.urlGain});
  double urlGain;
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
  double iceGain = 1.0;
// https://api.flutter.dev/flutter/widgets/MediaQuery-class.html
  //eq point is about 0.96788990825 percent of distance (in original formula)
  //so -(lpc * .45) * ~.03  should be eq point

  double getPos(joyStickPos, getCurrentPos, timeMax) {
    double iceStart = lpc * .3;
    double iceEnd = lpc * .4;

    double iceGain = 1.0;
    /*
    if (getCurrentPos > iceStart && getCurrentPos < iceEnd) {
      iceGain = urlGain;
    } else {
      iceGain = 1.0;
    }
    */

    aW = (1.0 / timeMax) * lpc;
    //eqPoint = (lpc * 0.45) * 0.03;
    //adjustedPos = getCurrentPos * lpc;
    //testing take out eq point terms
    //dy = -eqPoint*getCurrentPos + (joyStickPos * aW) * dt
    dy = (iceGain * joyStickPos * aW) * dt;
    dy = dy / 2.325;
    //dy = ((-eqPoint * getCurrentPos) + (joyStickPos * aW)) * dt;
    getCurrentPos = (dy + getCurrentPos);
    return getCurrentPos;
  }
}
