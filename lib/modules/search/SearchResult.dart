import 'dart:convert';

class SearchResult {
  List<Map<String, dynamic>>? resultRow;
  List<String>? fields;

  Map<String, Map<String, dynamic>>? facetResult;
  late int total;
  late int took;
  Status? status;

  // SearchResult();

  // SearchResult(
  //     {this.fields,
  //     this.facetResult,
  //     required this.total,
  //     required this.took,
  //     required this.status,
  //     this.resultRow});

  // SearchResult.fromJson(Map<String, dynamic> json) {
  //   fields = json['fields'].cast<String>();
  //   facetResult = json['facetResult'];
  //   total = json['total'];
  //   took = json['took'];
  //   status =
  //       json['status'] != null ? new Status.fromJson(json['status']) : null;
  // }
  // factory SearchResult.fromMap(Map<String, dynamic> map) {
  //   return SearchResult(
  //     fields: map['fields'],
  //     status: map['status'],
  //     resultRow: map['resultRow'],
  //     facetResult: map['facetResult'],
  //     total: map['total'] ?? '',
  //     took: map['took'] ?? '',
  //   );
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fields'] = fields;
    data['facetResult'] = facetResult;
    data['total'] = total;
    data['took'] = took;
    if (status != null) {
      data['status'] = status?.toJson();
    }
    return data;
  }

  // factory SearchResult.fromJson(String source) =>
  //     SearchResult.fromMap(json.decode(source));
}

class Status {
  int total;
  int failed;
  int successful;

  Status({required this.total, required this.failed, required this.successful});

  // Status.fromJson(Map<String, dynamic> json) {
  //   total = json['total'];
  //   failed = json['failed'];
  //   successful = json['successful'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = total;
    data['failed'] = failed;
    data['successful'] = successful;
    return data;
  }
}

// class IndexSchema {
//   String? name;
//   String? type;
//   String? dn;

//   IndexSchema({this.name, this.type, this.dn});

//   IndexSchema.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     type = json['type'];
//     dn = json['dn'];
//   }
// }

class IndexSchemaModel {
  String name;
  String type;
  String dn;

  IndexSchemaModel({
    required this.name,
    required this.type,
    required this.dn,
  });

  static Map<String, dynamic> toMap(IndexSchemaModel us) {
    return {
      'type': us.type,
      'name': us.name,
      'dn': us.dn,
    };
  }

  factory IndexSchemaModel.fromMap(Map<String, dynamic> map) {
    return IndexSchemaModel(
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      dn: map['dn'] ?? '',
    );
  }

  String toJson() => json.encode(toMap(this));

  factory IndexSchemaModel.fromJson(String source) =>
      IndexSchemaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IndexSchemaModel( type: $type,  name: $name,  dn: $dn, )';
  }
}
