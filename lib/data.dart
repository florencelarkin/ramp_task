import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Data {

  final String studycode;
  final String guid;
  final String data;


  Data({this.studycode, this.guid, this.data});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      studycode: json['studyCode'],
      guid: json['guid'],
      data: json['output'],
    );
  }
}

Future<Data> createData(String studyCode, String guid, String data) async {
  final http.Response response = await http.post(
    'http://160.94.0.29:5000/posts',
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




