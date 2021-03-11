import 'package:flutter/material.dart';

Map<String, String> getURLArgs(String str) {
  // return the URL arguments in a Map
  Map<String, String> result = {};

  // components of URL
  List comp = [];
  List pair = [];

  // get index of first question mark
  var firstQm = str.indexOf('?');
  // get index of first &
  var firstAmp = str.indexOf('&');

  // check if there is a ?
  if (firstQm > 0) {
    comp = str.split('?');
    //print(comp);
    var newstr = comp[1]; // the portion after ?

    if (firstAmp > 0) {
      //split
      comp = newstr.split('&');
      //print(comp);
    }

    for (var i = 0; i < comp.length; i++) {
      // extract out each section
      //print(comp[i]);
      pair = comp[i].split('=');
      print(pair);
      // insert into map
      result[pair[0]] = pair[1];
    }
    result["id"] = 'abcd';
    result["time"] = '3.0';
  }
  return result;
}

/*
// to print output
//   urlArgs.forEach((key, value) => print('${key}: ${value}'));
// here is how to add it to MaterialApp, same level as home:
// this section can be used to set variables
  onGenerateRoute: (settings) {
        print("settings.name " + settings.name);
        urlArgs = getURLArgs(settings.name);
        urlArgs.forEach((key, value) => print('${key}: ${value}'));
        if  (urlArgs.containsKey('count')) {
          _counter = int.parse(urlArgs['count']);
        }
        if  (urlArgs.containsKey('title')) {
          defaultTitle = urlArgs['title'];
        }
 */
