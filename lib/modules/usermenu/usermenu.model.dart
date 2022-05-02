//Auto code generated from xml definition 2022-04-03 19:11:55.7436528 -0400 EDT
//UserMenuModel

import 'dart:convert';

class UserMenuModel {
  String id;
  String customData;
  String namespaceId;
  String menuId;
  int privilege;
  String refId;
  String refType;

  UserMenuModel({
    required this.id,
    required this.customData,
    required this.namespaceId,
    required this.menuId,
    required this.privilege,
    required this.refId,
    required this.refType,
  });

  static Map<String, dynamic> toMap(UserMenuModel um) {
    return {
      'id': um.id,
      'cd': um.customData,
      'namespaceId': um.namespaceId,
      'menuId': um.menuId,
      'privilege': um.privilege,
      'refId': um.refId,
      'refType': um.refType,
    };
  }

  factory UserMenuModel.fromMap(Map<String, dynamic> map) {
    return UserMenuModel(
      id: map['id'] ?? '',
      customData: map['cd'] ?? '',
      namespaceId: map['namespaceId'] ?? '',
      menuId: map['menuId'] ?? '',
      privilege: map['privilege']?.toInt() ?? 0,
      refId: map['refId'] ?? '',
      refType: map['refType'] ?? '',
    );
  }

  factory UserMenuModel.fromJson(String source) =>
      UserMenuModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserMenuModel( id: $id,  cd: $customData,  namespaceId: $namespaceId,  menuId: $menuId,  privilege: $privilege,  refId: $refId,  refType: $refType, )';
  }
}
