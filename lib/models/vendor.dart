// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vendor {
  final String id;
  final String username;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String roles;
  final String password;

  Vendor({
    required this.id, 
    required this.username, 
    required this.email, 
    required this.state, 
    required this.city, 
    required this.locality, 
    required this.roles, 
    required this.password
    });
  // Convert 
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'roles': roles,
      'password': password,
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      locality: map['locality'] ?? '',
      roles: map['roles'] ?? '',
      password: map['password'] ?? '',
    );
  }
  // COnverting to Json because the data will be sent to json
  String toJson() => json.encode(toMap());
  // converting back to the vendor user object so that we can make use of it with in application
  factory Vendor.fromJson(String source) => Vendor.fromMap(json.decode(source) as Map<String, dynamic>);
}
