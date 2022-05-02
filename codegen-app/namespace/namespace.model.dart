//Auto code generated from xml definition 2022-04-28 10:39:36.1470212 -0400 EDT
//NamespaceModel

import 'dart:convert';


class NamespaceModel{ 
	String id; 
	String customJson; 
	String name; 
	String code;	


  NamespaceModel({ 
	required this.id, 
	required this.customJson, 
	required this.name, 
	required this.code,
  });

 
  static Map<String, dynamic> toMap(NamespaceModel na) {
    return { 
	    'id':na.id, 
	    'customJson':na.customJson, 
	    'name':na.name, 
	    'code':na.code,
      };
  }

  factory NamespaceModel.fromMap(Map<String, dynamic> map) {
    return NamespaceModel( 
       id: map['id'] ?? '', 
       customJson: map['customJson'] ?? '', 
       name: map['name'] ?? '', 
       code: map['code'] ?? '',);
      }
    

  String toJson() => json.encode(toMap(this));

  factory NamespaceModel.fromJson(String source) =>
      NamespaceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NamespaceModel( id: $id,  customJson: $customJson,  name: $name,  code: $code, )';
  }}
