class CarEngine {
  CarEngine({this.timeMax, this.lpc, this.trialNumber});
  int trialNumber;
  double dy = 0.0; // incremental position change for a unit of time
  double timeMax;  // time to go from start to finish line at maximum velocity
  double lpc;  // logical pixel count for the y dimension of the screen
  double aW;  // scaled velocity based on the timeMax and lpc (for which units?)

// https://api.flutter.dev/flutter/widgets/MediaQuery-class.html

  double getPos(joyStickPos, getCurrentPos, timeMax) {
    aW = (1 / timeMax) * lpc;
    dy = ((-.2 * getCurrentPos) + (joyStickPos * aW)) * 0.016;
    getCurrentPos = (dy + getCurrentPos);
    return getCurrentPos;
  }
}
