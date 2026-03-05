import 'dart:convert';

class Vendor {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String locality;
  final String city;
  final String state;
  final String role;
  Vendor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.locality,
    required this.city,
    required this.state,
    required this.role,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'locality': locality,
      'city': city,
      'state': state,
      'role': role,
    };
  }

  String toJson() => json.encode(toMap());

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      locality: map['locality'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      role: map['role'] as String,
    );
  }

  factory Vendor.fromJson(String source) => Vendor.fromMap(json.decode(source));
}
