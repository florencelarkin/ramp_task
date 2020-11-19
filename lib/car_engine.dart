
class CarEngine {

  double joyStickPos = 0.0;
  double getCurrentPos = 10.0;
  double dy = 0.0;

  double getPos (joyStickPos, getCurrentPos) {
    dy = ((-.2 * getCurrentPos) +
        (joyStickPos * 60.0)) * 0.033;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }
}