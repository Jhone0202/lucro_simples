// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentMethod {
  int? id;
  final String name;
  final double increasePercent;
  final double discountPercent;
  final int maxInstallments;

  PaymentMethod({
    this.id,
    required this.name,
    this.increasePercent = 0,
    this.discountPercent = 0,
    this.maxInstallments = 1,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'increasePercent': increasePercent,
      'discountPercent': discountPercent,
      'maxInstallments': maxInstallments,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      increasePercent: map['increasePercent'] as double,
      discountPercent: map['discountPercent'] as double,
      maxInstallments: map['maxInstallments'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source) as Map<String, dynamic>);
}
