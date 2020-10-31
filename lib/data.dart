import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Data> createData(String title) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
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



class Data {
  final int id;
  final String title;

  Data({this.id, this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
    );
  }
}
