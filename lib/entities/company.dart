import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Company {
  int? id;
  String? photoURL;
  String name;
  String userName;

  Company({
    this.id,
    this.photoURL,
    required this.name,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'photoURL': photoURL,
      'name': name,
      'userName': userName,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] != null ? map['id'] as int : null,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      name: map['name'] as String,
      userName: map['userName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);
}
