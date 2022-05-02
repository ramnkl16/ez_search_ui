//Auto code generated from xml definition 2022-04-28 10:39:36.1496389 -0400 EDT
//UserModel

import 'dart:convert';


class UserModel{ 
	String id; 
	String name; 
	String firstName; 
	String lastName; 
	String email; 
	String mobile;	


  UserModel({ 
	required this.id, 
	required this.name, 
	required this.firstName, 
	required this.lastName, 
	required this.email, 
	required this.mobile,
  });

 
  static Map<String, dynamic> toMap(UserModel us) {
    return { 
	    'id':us.id, 
	    'name':us.name, 
	    'firstName':us.firstName, 
	    'lastName':us.lastName, 
	    'email':us.email, 
	    'mobile':us.mobile,
      };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel( 
       id: map['id'] ?? '', 
       name: map['name'] ?? '', 
       firstName: map['firstName'] ?? '', 
       lastName: map['lastName'] ?? '', 
       email: map['email'] ?? '', 
       mobile: map['mobile'] ?? '',);
      }
    

  String toJson() => json.encode(toMap(this));

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel( id: $id,  name: $name,  firstName: $firstName,  lastName: $lastName,  email: $email,  mobile: $mobile, )';
  }}
