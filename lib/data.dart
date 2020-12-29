import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:async';
import 'dart:convert';

@JsonSerializable(nullable: false)
Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    studycode: json['studycode'] as String,
    guid: json['guid'] as String,
    data_version: json['dataversion'] as String,
    data: json['data'] as List,
    created_on: json['studyDate'] as String,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'studycode': instance.studycode,
      'guid': instance.guid,
      'dataversion': instance.data_version,
      'data': instance.data,
      'created_on': instance.created_on,
    };

class Data {
  final String studycode;
  final String guid;
  final List data;
  final String data_version;
  final String created_on;

  Data(
      {this.studycode,
      this.guid,
      this.data_version,
      this.data,
      this.created_on});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

Future<Data> createData(String studycode, String guid, List dataList,
    String dataversion, String studyDate) async {
  Data data = Data(
    studycode: studycode,
    guid: guid,
    data: dataList,
    data_version: dataversion,
  );
  String jsonUser = jsonEncode(data);
  print(jsonUser);

  final http.Response response = await http.post(
    'http://160.94.0.29:5000/posts',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonUser,
  );

  if (response.statusCode == 200) {
    return Data.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create data.');
  }
}
