
class CarEngine {
  double dy = 0.0;

  double getPos (joyStickPos, getCurrentPos) {
    dy = ((-.05 * getCurrentPos) +
        (joyStickPos * 160.0)) * 0.033;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }



}