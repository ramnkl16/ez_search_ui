//Auto code generated from xml definition 2022-04-05 12:20:14.1031553 -0400 EDT
//RptQueryModel

import 'dart:convert';

class RptQueryModel {
  String id;
  String name;
  String division;
  String page;
  String CustomData;
  int pgStartIndex = 0;
  int pgSize = 50;

  RptQueryModel({
    required this.id,
    required this.name,
    required this.division,
    required this.page,
    required this.CustomData,
  });

  static Map<String, dynamic> toMap(RptQueryModel rp) {
    return {
      'id': rp.id,
      'name': rp.name,
      'division': rp.division,
      'page': rp.page,
      'cd': rp.CustomData,
    };
  }

  factory RptQueryModel.fromMap(Map<String, dynamic> map) {
    return RptQueryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      division: map['division'] ?? '',
      page: map['page'] ?? '',
      CustomData: map['cd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap(this));

  factory RptQueryModel.fromJson(String source) =>
      RptQueryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RptQueryModel( id: $id,  name: $name,  division: $division,  page: $page,  cd: $CustomData, )';
  }
}
