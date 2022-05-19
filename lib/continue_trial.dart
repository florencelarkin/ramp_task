import 'main_page.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:convert';

class ContinuationPage extends StatefulWidget {
  ContinuationPage({
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.timeMax,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.width,
    this.dataMap,
  });
  final String subjectId;
  final String uuid;
  final int trialNumber;
  final int blockNumber;
  final double lpc;
  final double timeMax;
  final int totalTrials;
  final double iceGain;
  final double cutoffFreq;
  final int order;
  final double samplingFreq;
  final double width;
  final Map dataMap;

  @override
  _ContinuationPageState createState() => _ContinuationPageState(
        subjectId: subjectId,
        uuid: uuid,
        trialNumber: trialNumber,
        blockNumber: blockNumber,
        lpc: lpc,
        timeMax: timeMax,
        totalTrials: totalTrials,
        iceGain: iceGain,
        cutoffFreq: cutoffFreq,
        order: order,
        samplingFreq: samplingFreq,
        width: width,
        dataMap: dataMap,
      );
}

class _ContinuationPageState extends State<ContinuationPage> {
  _ContinuationPageState({
    @required this.subjectId,
    @required this.uuid,
    this.trialNumber,
    this.blockNumber,
    this.lpc,
    this.timeMax,
    this.totalTrials,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.width,
    this.dataMap,
  });
  String subjectId;
  double maxVelocity;
  String uuid;
  int trialNumber;
  int blockNumber;
  double lpc;
  double timeMax;
  int totalTrials;
  double iceGain;
  String timeString = '0.75';
  double cutoffFreq;
  int order;
  double samplingFreq;
  double width;
  Map dataMap;
  String jsonData = '';

  dynamic getJson(dataMap) {
    dynamic jsonData = JsonEncoder().convert(dataMap);
    return jsonData;
  }

  @override
  void initState() {
    super.initState();
    jsonData = getJson(dataMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Text('Trial $trialNumber data: Use ctrl+a to select all'),
          ),
          SelectableText(
            jsonData,
            toolbarOptions: ToolbarOptions(
                copy: true, selectAll: true, cut: false, paste: false),
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
              child: Text('START'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                trialNumber++;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      timeMax: timeMax,
                      subjectId: subjectId,
                      uuid: uuid,
                      trialNumber: trialNumber,
                      blockNumber: blockNumber,
                      lpc: lpc,
                      totalTrials: totalTrials,
                      iceGain: iceGain,
                      cutoffFreq: cutoffFreq,
                      order: order,
                      samplingFreq: samplingFreq,
                      width: width,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
