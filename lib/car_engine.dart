import 'package:iirjdart/butterworth.dart';

class CarEngine {
  CarEngine({
    this.timeMax,
    this.lpc,
    this.trialNumber,
    this.urlGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
  });
  double urlGain; //not currently used
  int trialNumber;
  double cutoffFreq; //cut off freq for filter, input in url for testing
  double dy = 0.0; // incremental position change for a unit of time
  double timeMax; // time to go from start to finish line at maximum velocity
  double lpc; // logical pixel count for the y dimension of the screen
  double vW; // scaled velocity based on the timeMax and lpc in virtual units
  double eqPoint =
      0.35; //equilibrium point from original formula, should be scaled by distance, not currently used

  double dipFactor = 0.0; //not currently used
  double iceGain = 1.0; //not currently used
  double velocity = 0.0;
  int order; //order for the low pass filter, recommend second order for starting default
  double
      samplingFreq; //sampling frequency for Butterworth filter, should be set to 60.0 as default
// https://api.flutter.dev/flutter/widgets/MediaQuery-class.html
  Butterworth butterworth = new Butterworth();
  double sliderFilter;

  List getPos(
      sliderPos, getCurrentPos, timeMax, prevPos, currentTime, prevTime) {
    //double iceStart = lpc * .3;
    //double iceEnd = lpc * .4;

    double iceGain = 1.0;
    /*
    if (getCurrentPos > iceStart && getCurrentPos < iceEnd) {
      iceGain = urlGain;
    } else {
      iceGain = 1.0;
    }
    */
    butterworth.lowPass(order, samplingFreq,
        cutoffFreq); //(order, sampling freq, cutoff freq put in url) filters slider input

    vW = (1.0 /
        timeMax); //scaled velocity based on the amount of time it takes car to reach stop sign

    double deltaTime =
        currentTime - prevTime; //change in time to measure frame rate

    order == 0
        ? sliderFilter = sliderPos
        : sliderFilter = butterworth.filter(
            sliderPos); //takes in slider position and puts it through a low pass filter

    dy = (iceGain * sliderFilter * vW) * (deltaTime / 1000);

    double getAdjustedPos = (dy +
        prevPos); //virtualized position, this is what goes in data and is used to calculate velocity
    dy = dy * 0.435 * lpc; //scaled by distance from start to finish
    //dy = ((-eqPoint * getCurrentPos) + (joyStickPos * aW)) * dt;
    getCurrentPos = (dy +
        getCurrentPos); //scaled by dimensions of the phone, actual pos of the car in pixels
    velocity = ((getAdjustedPos - prevPos) / deltaTime) /
        1000; //normalized units per second
    List posList = [getAdjustedPos, getCurrentPos, velocity];
    return posList;
  }
}
