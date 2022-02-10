import 'dart:ui';

class DataMapWriter {
  DataMapWriter();

  Map dataMap = {};
  var physicalScreenSize = window.physicalSize;

  String addQuotesToString(String text) {
    return text;
  }

  String _addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  Map writeMap(
      String taskVersion,
      bool webFlag,
      String platformType,
      Map deviceData,
      String subjectId,
      int trialNumber,
      String timezone,
      DateTime startTime,
      double timeMax,
      int order,
      int totalTrials,
      double samplingFreq,
      double cutoffFreq,
      double lpc,
      bool isPractice,
      bool completed,
      List dataList,
      double width) {
    dataMap[addQuotesToString('TaskVersion')] = addQuotesToString(taskVersion);
    dataMap[addQuotesToString('Web')] = webFlag;
    dataMap[addQuotesToString('Platform')] = addQuotesToString(platformType);
    dataMap[addQuotesToString('DeviceData')] = deviceData;
    dataMap[addQuotesToString('SubjectID')] = addQuotesToString(subjectId);
    dataMap[addQuotesToString('TrialNumber')] =
        addQuotesToString(trialNumber.toString());
    dataMap[addQuotesToString('TimeZone')] = addQuotesToString(timezone);
    dataMap[addQuotesToString('StartTime')] =
        addQuotesToString(startTime.toIso8601String());
    dataMap[addQuotesToString('EndTime')] =
        addQuotesToString(DateTime.now().toIso8601String());
    dataMap[addQuotesToString('Sensitivity')] =
        addQuotesToString(timeMax.toString());
    dataMap[addQuotesToString('FilterCutoffFreq')] =
        addQuotesToString(cutoffFreq.toString());
    dataMap[addQuotesToString('FilterOrder')] =
        addQuotesToString(order.toString());
    dataMap[addQuotesToString('FilterSamplingFreq')] =
        addQuotesToString(samplingFreq.toString());
    dataMap[addQuotesToString('TotalTrials')] =
        addQuotesToString(totalTrials.toString());
    dataMap[addQuotesToString('ScreenSize')] =
        addQuotesToString('$width x $lpc');
    dataMap[addQuotesToString('PhysicalScreenSize')] = addQuotesToString(
        physicalScreenSize.width.toString() +
            ' x ' +
            physicalScreenSize.height.toString());
    dataMap[addQuotesToString('IsPractice')] =
        addQuotesToString(isPractice.toString());
    dataMap[addQuotesToString('CompletedTrial')] =
        addQuotesToString(completed.toString());
    dataMap[addQuotesToString('Moves')] = dataList;
    return dataMap;
  }
}
