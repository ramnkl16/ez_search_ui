//Auto code generated from xml definition 2022-04-28 10:39:36.157062 -0400 EDT
//RptQueryModel

import 'dart:convert';


class RptQueryModel{ 
	String id; 
	String name; 
	String division; 
	String page; 
	String cd;	


  RptQueryModel({ 
	required this.id, 
	required this.name, 
	required this.division, 
	required this.page, 
	required this.cd,
  });

 
  static Map<String, dynamic> toMap(RptQueryModel rp) {
    return { 
	    'id':rp.id, 
	    'name':rp.name, 
	    'division':rp.division, 
	    'page':rp.page, 
	    'cd':rp.cd,
      };
  }

  factory RptQueryModel.fromMap(Map<String, dynamic> map) {
    return RptQueryModel( 
       id: map['id'] ?? '', 
       name: map['name'] ?? '', 
       division: map['division'] ?? '', 
       page: map['page'] ?? '', 
       cd: map['cd'] ?? '',);
      }
    

  String toJson() => json.encode(toMap(this));

  factory RptQueryModel.fromJson(String source) =>
      RptQueryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RptQueryModel( id: $id,  name: $name,  division: $division,  page: $page,  cd: $cd, )';
  }}
