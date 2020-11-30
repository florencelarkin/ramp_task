import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Data {

  final String title;
  final String content;


  Data({this.title, this.content});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      title: json['title'],
      content: json['x'],
    );
  }
}

Future<Data> createData(String title, String x) async {
  final http.Response response = await http.post(
    'http://127.0.0.1:5000//posts',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'content': x,
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




