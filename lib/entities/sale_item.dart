// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SaleItem {
  int? id;
  int productId;
  int saleId;
  String name;
  String? photoURL;
  int quantity;
  double price;
  double total;
  double profit;

  SaleItem({
    this.id,
    required this.productId,
    required this.saleId,
    required this.name,
    this.photoURL,
    required this.quantity,
    required this.price,
    required this.total,
    required this.profit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'saleId': saleId,
      'name': name,
      'photoURL': photoURL,
      'quantity': quantity,
      'price': price,
      'total': total,
      'profit': profit,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] != null ? map['id'] as int : null,
      productId: map['productId'] as int,
      saleId: map['saleId'] as int,
      name: map['name'] as String,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      total: map['total'] as double,
      profit: map['profit'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleItem.fromJson(String source) =>
      SaleItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
