import 'package:flutter/material.dart';

class CompletedPage extends StatefulWidget {
  CompletedPage({
    this.webFlag,
    this.dataMap,
  });
  final bool webFlag;
  final Map dataMap;
  @override
  _CompletedPageState createState() =>
      _CompletedPageState(webFlag: webFlag, dataMap: dataMap);
}

class _CompletedPageState extends State<CompletedPage> {
  _CompletedPageState({this.webFlag, this.dataMap});
  bool webFlag; //true if on web
  Map dataMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SelectableText(
            dataMap.toString(),
            toolbarOptions: ToolbarOptions(
                copy: true, selectAll: true, cut: false, paste: false),
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
