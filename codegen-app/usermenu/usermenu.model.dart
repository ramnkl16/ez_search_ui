//Auto code generated from xml definition 2022-04-28 10:39:36.1549671 -0400 EDT
//UserMenuModel

import 'dart:convert';


class UserMenuModel{ 
	String id; 
	String cd; 
	String namespaceId; 
	String menuId; 
	int privilege; 
	String refId; 
	String refType;	


  UserMenuModel({ 
	required this.id, 
	required this.cd, 
	required this.namespaceId, 
	required this.menuId, 
	required this.privilege, 
	required this.refId, 
	required this.refType,
  });

 
  static Map<String, dynamic> toMap(UserMenuModel us) {
    return { 
	    'id':us.id, 
	    'cd':us.cd, 
	    'namespaceId':us.namespaceId, 
	    'menuId':us.menuId, 
	    'privilege':us.privilege, 
	    'refId':us.refId, 
	    'refType':us.refType,
      };
  }

  factory UserMenuModel.fromMap(Map<String, dynamic> map) {
    return UserMenuModel( 
       id: map['id'] ?? '', 
       cd: map['cd'] ?? '', 
       namespaceId: map['namespaceId'] ?? '', 
       menuId: map['menuId'] ?? '', 
       privilege: map['privilege']?.toInt() ?? 0 , 
       refId: map['refId'] ?? '', 
       refType: map['refType'] ?? '',);
      }
    

  String toJson() => json.encode(toMap(this));

  factory UserMenuModel.fromJson(String source) =>
      UserMenuModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserMenuModel( id: $id,  cd: $cd,  namespaceId: $namespaceId,  menuId: $menuId,  privilege: $privilege,  refId: $refId,  refType: $refType, )';
  }}
