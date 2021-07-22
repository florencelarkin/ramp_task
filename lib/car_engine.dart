class CarEngine {
  CarEngine({this.timeMax, this.lpc, this.trialNumber, this.urlGain});
  double urlGain;
  int trialNumber;
  double dy = 0.0; // incremental position change for a unit of time
  double timeMax; // time to go from start to finish line at maximum velocity
  double lpc; // logical pixel count for the y dimension of the screen
  double vW; // scaled velocity based on the timeMax and lpc in virtual units
  double eqPoint =
      0.35; //equilibrium point from original formula, should be scaled by distance

  double eqFactor = 1.0;
  double dipFactor = 0.0;
  double iceGain = 1.0;
  double velocity = 0.0;
// https://api.flutter.dev/flutter/widgets/MediaQuery-class.html
  //eq point is about 0.96788990825 percent of distance (in original formula)
  //so -(lpc * .45) * ~.03  should be eq point

  List getPos(
      sliderPos, getCurrentPos, timeMax, prevPos, currentTime, prevTime) {
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

    vW = (1.0 / timeMax);
    double deltaTime = currentTime - prevTime;
    dy = (iceGain * sliderPos * vW) * deltaTime;
    double getAdjustedPos = (dy + prevPos);
    dy = dy * 0.435 * lpc; //scaled by distance from start to finish
    //dy = ((-eqPoint * getCurrentPos) + (joyStickPos * aW)) * dt;
    getCurrentPos = (dy + getCurrentPos);
    velocity = ((getAdjustedPos - prevPos) / deltaTime) /
        1000; //normalized units per second

    List posList = [getAdjustedPos, getCurrentPos, velocity];
    return posList;
  }
}
