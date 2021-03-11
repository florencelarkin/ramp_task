class CarEngine {
  CarEngine({this.timeMax, this.lpc, this.trialNumber});
  int trialNumber;
  double dy = 0.0;
  double timeMax;
  double lpc;
  double velocity;
  double aW;

  double getPos(joyStickPos, getCurrentPos, timeMax) {
    aW = (1 / timeMax) * lpc;
    dy = ((-.2 * getCurrentPos) + (joyStickPos * aW)) * 0.016;
    getCurrentPos = (dy + getCurrentPos);
    return getCurrentPos;
  }
}
