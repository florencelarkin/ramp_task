import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Data {

  final String studyCode;
  final String guid;
  final String output;


  Data({this.studyCode, this.guid, this.output});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      studyCode: json['studyCode'],
      guid: json['guid'],
      output: json['output'],
    );
  }
}

Future<Data> createData(String studyCode, String guid, String data) async {
  final http.Response response = await http.post(
    'http://127.0.0.1:5000//posts',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'studyCode': studyCode,
      'guid': guid,
      'data': data,
    }),
  );

  if (response.statusCode == 201) {
    print('it worked');
    return Data.fromJson(jsonDecode(response.body));
  } else {
    print(':(');
    throw Exception('Failed to create data.');
  }
}




