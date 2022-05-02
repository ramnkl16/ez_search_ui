//Auto code generated from xml definition 2022-04-28 10:39:36.1480805 -0400 EDT
//MenuModel

import 'dart:convert';


class MenuModel{ 
	String id; 
	String name; 
	String parentId; 
	String link;	


  MenuModel({ 
	required this.id, 
	required this.name, 
	required this.parentId, 
	required this.link,
  });

 
  static Map<String, dynamic> toMap(MenuModel me) {
    return { 
	    'id':me.id, 
	    'name':me.name, 
	    'parentId':me.parentId, 
	    'link':me.link,
      };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel( 
       id: map['id'] ?? '', 
       name: map['name'] ?? '', 
       parentId: map['parentId'] ?? '', 
       link: map['link'] ?? '',);
      }
    

  String toJson() => json.encode(toMap(this));

  factory MenuModel.fromJson(String source) =>
      MenuModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MenuModel( id: $id,  name: $name,  parentId: $parentId,  link: $link, )';
  }}
