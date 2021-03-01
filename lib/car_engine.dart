class CarEngine {
  CarEngine({this.maxVelocity, this.lpc});
  double dy = 0.0;
  double maxVelocity;
  double lpc;
  double velocity;
  double aW = 3.555555555556;

  double getPos(joyStickPos, getCurrentPos) {
    velocity = aW * lpc;
    dy = ((-.087 * getCurrentPos) + (joyStickPos * velocity)) * 0.016;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }
}
