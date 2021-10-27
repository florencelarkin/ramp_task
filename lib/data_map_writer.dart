class DataMapWriter {
  DataMapWriter();

  Map dataMap = {};

  String addQuotesToString(String text) {
    var quoteText = '\"' + text + '\"';
    return quoteText;
  }

  Map writeMap(
      String taskVersion,
      bool webFlag,
      String platformType,
      String deviceData,
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
    dataMap[addQuotesToString("TaskVersion")] = addQuotesToString(taskVersion);
    dataMap[addQuotesToString("Web")] = webFlag;
    dataMap[addQuotesToString("Platform")] = addQuotesToString(platformType);
    dataMap[addQuotesToString("DeviceData")] = addQuotesToString(deviceData);
    dataMap[addQuotesToString("SubjectID")] = addQuotesToString(subjectId);
    dataMap[addQuotesToString("TrialNumber")] =
        addQuotesToString(trialNumber.toString());
    dataMap[addQuotesToString("TimeZone")] = addQuotesToString(timezone);
    dataMap[addQuotesToString("StartTime")] =
        addQuotesToString(startTime.toIso8601String());
    dataMap[addQuotesToString("EndTime")] =
        addQuotesToString(DateTime.now().toIso8601String());
    dataMap[addQuotesToString("Sensitivity")] =
        addQuotesToString(timeMax.toString());
    dataMap[addQuotesToString("FilterCutoffFreq")] =
        addQuotesToString(cutoffFreq.toString());
    dataMap[addQuotesToString("FilterOrder")] =
        addQuotesToString(order.toString());
    dataMap[addQuotesToString("FilterSamplingFreq")] =
        addQuotesToString(samplingFreq.toString());
    dataMap[addQuotesToString("TotalTrials")] =
        addQuotesToString(totalTrials.toString());
    dataMap[addQuotesToString("ScreenSize")] =
        addQuotesToString("$width x $lpc");
    dataMap[addQuotesToString("IsPractice")] =
        addQuotesToString(isPractice.toString());
    dataMap[addQuotesToString("CompletedTrial")] =
        addQuotesToString(completed.toString());
    dataMap[addQuotesToString("Moves")] = dataList;
    return dataMap;
  }
}