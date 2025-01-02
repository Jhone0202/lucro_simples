// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:lucro_simples/entities/customer_types.dart';

class Customer {
  int? id;
  String? photoURL;
  String name;
  CustomerType type;

  Customer({
    this.id,
    this.photoURL,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'photoURL': photoURL,
      'name': name,
      'type': type.id,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] != null ? map['id'] as int : null,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      name: map['name'] as String,
      type: CustomerType.fromId(map['type'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);
}
