//Auto code generated from xml definition 2022-05-03 19:54:23.8510937 -0400 EDT
//IndexModel

import 'dart:convert';

class IndexModel {
  String name;

  IndexModel({
    required this.name,
  });

  static Map<String, dynamic> toMap(IndexModel i) {
    return {
      'name': i.name,
    };
  }

  factory IndexModel.fromMap(Map<String, dynamic> map) {
    return IndexModel(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap(this));

  factory IndexModel.fromJson(String source) =>
      IndexModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IndexModel( name: $name, )';
  }
}
