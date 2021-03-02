class CarEngine {
  CarEngine({this.timeMax, this.lpc, this.trialNumber});
  int trialNumber;
  double dy = 0.0;
  double timeMax;
  double lpc;
  double velocity;
  double aW;

  double getPos(joyStickPos, getCurrentPos) {
    aW = 2 / (timeMax * timeMax);
    velocity = aW * lpc;
    dy = ((-.087 * getCurrentPos) + (joyStickPos * velocity)) * 0.016;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }
}
