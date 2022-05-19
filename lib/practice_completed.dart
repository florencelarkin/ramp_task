import 'package:flutter/material.dart';
import 'instruction_page4.dart';
import 'dart:convert';

class PracticeCompleted extends StatefulWidget {
  PracticeCompleted({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.dataMap,
  });
  final String subjectId;
  final String uuid;
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
  _PracticeCompletedState createState() => _PracticeCompletedState(
        subjectId: subjectId,
        uuid: uuid,
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

class _PracticeCompletedState extends State<PracticeCompleted> {
  _PracticeCompletedState({
    @required this.subjectId,
    @required this.uuid,
    @required this.lpc,
    @required this.timeMax,
    @required this.totalTrials,
    this.width,
    this.iceGain,
    this.cutoffFreq,
    this.order,
    this.samplingFreq,
    this.dataMap,
  });
  String subjectId;
  double maxVelocity;
  String uuid;
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
        //shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Text('Practice Data: Use control+A to select all'),
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
              child: Text('NEXT'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionPage4(
                      timeMax: timeMax,
                      subjectId: subjectId,
                      totalTrials: totalTrials,
                      iceGain: iceGain,
                      cutoffFreq: cutoffFreq,
                      order: order,
                      samplingFreq: samplingFreq,
                      uuid: uuid,
                      lpc: lpc,
                      width: width,
                      dataMap: dataMap,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
