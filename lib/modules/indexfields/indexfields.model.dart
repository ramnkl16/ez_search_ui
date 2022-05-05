//Auto code generated from xml definition 2022-05-03 19:54:23.8571762 -0400 EDT
//IndexFieldModel

import 'dart:convert';

class IndexFieldModel {
  String name;

  IndexFieldModel({
    required this.name,
  });

  static Map<String, dynamic> toMap(IndexFieldModel m) {
    return {
      'name': m.name,
    };
  }

  factory IndexFieldModel.fromMap(Map<String, dynamic> map) {
    return IndexFieldModel(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap(this));

  factory IndexFieldModel.fromJson(String source) =>
      IndexFieldModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IndexFieldModel( name: $name, )';
  }
}
