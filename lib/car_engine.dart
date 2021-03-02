import 'dart:math';

class CarEngine {
  CarEngine({this.maxVelocity, this.lpc, this.trialNumber});
  int trialNumber;
  double dy = 0.0;
  double maxVelocity;
  double lpc;
  double velocity;
  double aW;
  List<double> speeds = [
    3.55555555556,
    2.0,
    1.28,
    0.888888888889,
    0.6530612245,
    0.5,
    0.3950617284,
    0.32,
    0.2644628099,
    0.22222222
  ];

  double getSpeed() {
    Random random = new Random();
    int randomNumber = random.nextInt(11);
    aW = speeds[randomNumber];
    return aW;
  }

  double getPos(joyStickPos, getCurrentPos) {
    velocity = maxVelocity * lpc;
    dy = ((-.087 * getCurrentPos) + (joyStickPos * velocity)) * 0.016;
    getCurrentPos = dy + getCurrentPos;
    return getCurrentPos;
  }
}
