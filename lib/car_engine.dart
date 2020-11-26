
class CarEngine {
  double dy = 0.0;

  double getPos (joyStickPos, getCurrentPos) {
    dy = ((-.2 * getCurrentPos) +
        (joyStickPos * 60.0)) * 0.033;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }

}