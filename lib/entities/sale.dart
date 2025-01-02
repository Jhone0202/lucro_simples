// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lucro_simples/entities/delivery_type.dart';

class Sale {
  int? id;
  int productId;
  int customerId;
  int companyId;
  DateTime saleDate;
  DateTime deliveryDate;
  int quantity;
  double discount;
  double subtotal;
  double total;
  double profit;
  DELIVERY_TYPE deliveryType;
  double deliveryCost;

  Sale({
    this.id,
    required this.productId,
    required this.customerId,
    required this.companyId,
    required this.saleDate,
    required this.deliveryDate,
    required this.quantity,
    required this.discount,
    required this.subtotal,
    required this.total,
    required this.profit,
    this.deliveryType = DELIVERY_TYPE.pickup,
    this.deliveryCost = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'customerId': customerId,
      'companyId': companyId,
      'saleDate': saleDate.millisecondsSinceEpoch,
      'deliveryDate': deliveryDate.millisecondsSinceEpoch,
      'quantity': quantity,
      'discount': discount,
      'subtotal': subtotal,
      'total': total,
      'profit': profit,
      'deliveryType': deliveryType.toString().split('.').last,
      'deliveryCost': deliveryCost,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] != null ? map['id'] as int : null,
      productId: map['productId'] as int,
      customerId: map['customerId'] as int,
      companyId: map['companyId'] as int,
      saleDate: DateTime.fromMillisecondsSinceEpoch(map['saleDate'] as int),
      deliveryDate:
          DateTime.fromMillisecondsSinceEpoch(map['deliveryDate'] as int),
      quantity: map['quantity'] as int,
      discount: map['discount'] as double,
      subtotal: map['subtotal'] as double,
      total: map['total'] as double,
      profit: map['profit'] as double,
      deliveryType: DELIVERY_TYPE.values.firstWhere(
        (e) => e.toString().split('.').last == map['deliveryType'],
      ),
      deliveryCost: map['deliveryCost'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sale.fromJson(String source) =>
      Sale.fromMap(json.decode(source) as Map<String, dynamic>);
}
